import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:record/record.dart' as rec;
import 'package:waveform_flutter/waveform_flutter.dart' as wf;

/// Waveform live basé sur `record` + `waveform_flutter`.
/// - Idle : rien
/// - Recording : barres indigo, flux en temps réel
/// - Paused : fige + overlay gris
///
/// IMPORTANT : passer le *même* AudioRecorder que celui utilisé pour l’enregistrement.
class WaveRecord2 extends StatefulWidget {
  const WaveRecord2({
    super.key,
    required this.recorder,
    required this.isRecording,
    required this.isPaused,
    this.height = 115,
    this.margin = const EdgeInsets.symmetric(horizontal: 16),
    this.backgroundColor = const Color(0xFFF1F5F9),
    this.waveColor = const Color(0xFF4F46E5),   // indigo
    this.pausedTintColor = const Color(0x99A3A3A3), // voile gris en pause
    this.updateInterval = const Duration(milliseconds: 70),
    this.minLevelPercent = 3,      // floor visuel 0..100
    this.maxBarHeight = 100,       // correspond au "max" utilisé par la lib
  });

  final rec.AudioRecorder recorder;
  final bool isRecording;
  final bool isPaused;

  final double height;
  final EdgeInsetsGeometry margin;
  final Color backgroundColor;
  final Color waveColor;
  final Color pausedTintColor;
  final Duration updateInterval;
  final int minLevelPercent; // 0..100 mini visuel quand silence
  final int maxBarHeight;    // hauteur "max" pour WaveFormBar

  @override
  State<WaveRecord2> createState() => _WaveRecord2State();
}

class _WaveRecord2State extends State<WaveRecord2> {
  StreamSubscription<rec.Amplitude>? _sub;
  final _out = StreamController<wf.Amplitude>.broadcast();

  @override
  void initState() {
    super.initState();
    _attachIfNeeded();
  }

  @override
  void didUpdateWidget(covariant WaveRecord2 old) {
    super.didUpdateWidget(old);
    // branche/débranche selon l’état
    if (!old.isRecording && widget.isRecording) _attach();
    if (old.isRecording && !widget.isRecording) _detach();
  }

  @override
  void dispose() {
    _detach();
    _out.close();
    super.dispose();
  }

  void _attachIfNeeded() {
    if (widget.isRecording) _attach();
  }

  void _attach() {
    _sub?.cancel();
    _sub = widget.recorder
        .onAmplitudeChanged(widget.updateInterval)
        .listen((a) {
      // a.current est en dBFS [-60..0] en pratique → map vers [0..100]
      final db = a.current;
      // ignore: unnecessary_cast
      final clamped = db.isFinite ? db.clamp(-60.0, 0.0) as double : -60.0;
      var percent = ((clamped + 60.0) / 60.0) * 100.0; // 0..100
      // floor visuel pour "voir" quelque chose même en silence
      if (percent < widget.minLevelPercent) percent = widget.minLevelPercent.toDouble();

      _sub = widget.recorder
    .onAmplitudeChanged(widget.updateInterval)
    .listen((a) {
  // a.current peut être soit en dBFS négatifs, soit une amplitude linéaire positive.
  double percent;

  if (a.current.isFinite && a.current <= 0.0) {
    // Cas dBFS ~ [-60..0] : map -> [0..100]
    final db = a.current.clamp(-60.0, 0.0);
    percent = ((db + 60.0) / 60.0) * 100.0;
  } else {
    // Cas amplitude linéaire positive : normalise vs a.max (fallback si 0)
    final rawMax = (a.max.isFinite && a.max > 0) ? a.max : 32768.0;
    final norm = (a.current / rawMax).clamp(0.0, 1.0);
    // Petite compression pour un rendu plus joli
    percent = (math.sqrt(norm) * 100.0);
  }

  // Plancher visuel (même en silence) + bornes
  percent = percent.clamp(widget.minLevelPercent.toDouble(), 100.0);

  // IMPORTANT : utilisez une échelle stable (0..100) pour l’amplitude,
  // et laissez WaveFormBar décider de la hauteur en px via maxHeight.
  _out.add(wf.Amplitude(current: percent, max: 100.0));
}, onError: (_) {
  _detach();
});
    }, onError: (_) {
      // on stoppe le flux en cas d’erreur (évite spam)
      _detach();
    });
  }

  void _detach() {
    _sub?.cancel();
    _sub = null;
  }

  @override
  Widget build(BuildContext context) {
    final isIdle = !widget.isRecording && !widget.isPaused;

    if (isIdle) {
      // même fond, pas de waveform
      return Container(
        height: widget.height,
        margin: widget.margin,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
      );
    }

    return Container(
      height: widget.height,
      margin: widget.margin,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Waveform animé : on pousse wf.Amplitude (0..100)
            wf.AnimatedWaveList(
              stream: _out.stream,
              // on force la couleur via barBuilder
              barBuilder: (animation, amplitude) => wf.WaveFormBar(
                animation: animation,
                amplitude: amplitude,
                maxHeight: widget.maxBarHeight,
                color: widget.waveColor,
              ),
            ),

            // En pause : voile gris par-dessus (fige visuellement la teinte)
            if (widget.isPaused)
              AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 150),
                child: Container(color: widget.pausedTintColor),
              ),
          ],
        ),
      ),
    );
  }
}
