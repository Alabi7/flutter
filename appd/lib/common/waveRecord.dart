import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:record/record.dart';

/// Waveform "live" pour l'enregistrement via le plugin `record`.
/// - isRecording: démarre l'écoute du micro et anime les barres (indigo)
/// - isPaused: fige les barres et passe en gris
/// - idle: n'écoute pas, affiche juste un placeholder (optionnel)
///
/// IMPORTANT: passer le *même* AudioRecorder que celui utilisé pour l'enregistrement
/// (ex: _session.audio.recorder), sinon conflit d'accès au micro.
class WaveRecord extends StatefulWidget {
  const WaveRecord({
    super.key,
    required this.recorder,
    required this.isRecording,
    required this.isPaused,
    this.waveColor = const Color(0xFF4F46E5),      // indigo
    this.pausedColor = const Color(0xFF9CA3AF),    // gris
    this.backgroundColor = const Color(0xFFF1F5F9),
    this.scaleFactor = 1.0,                        // amplifie l'amplitude
    this.samples = 120,                            // nombre de barres visibles
    this.barGap = 2.0,                             // espace entre barres
    this.cornerRadius = 3.0,
    this.idleMessage,
    this.pauseMessage,
  });

  final AudioRecorder recorder;
  final bool isRecording;
  final bool isPaused;

  final Color waveColor;
  final Color pausedColor;
  final Color backgroundColor;

  /// Multiplie la hauteur (1.0 = normal, 1.5 = plus grand, etc.)
  final double scaleFactor;

  /// Nombre de barres affichées
  final int samples;

  /// Espace horizontal entre barres
  final double barGap;

  final double cornerRadius;

  final String? idleMessage;
  final String? pauseMessage;

  @override
  State<WaveRecord> createState() => _WaveRecordState();
}

class _WaveRecordState extends State<WaveRecord> {
  late List<double> _vals; // valeurs normalisées 0..1
  StreamSubscription<Amplitude>? _ampSub;

  @override
  void initState() {
    super.initState();
    _vals = List<double>.filled(widget.samples, 0.0, growable: false);
    _maybeAttach();
  }

  @override
  void didUpdateWidget(covariant WaveRecord oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si on passe en recording -> brancher le flux amplitude
    // Si on quitte recording -> débrancher (on garde les valeurs figées)
    final wasRec = oldWidget.isRecording;
    final nowRec = widget.isRecording;
    if (!wasRec && nowRec) _attach();
    if (wasRec && !nowRec) _detach();
  }

  @override
  void dispose() {
    _detach();
    super.dispose();
  }

  void _maybeAttach() {
    if (widget.isRecording) _attach();
  }

  void _attach() {
    _ampSub?.cancel();
    // 60–100ms donne un rendu fluide sans trop charger l'UI
    _ampSub = widget.recorder
        .onAmplitudeChanged(const Duration(milliseconds: 80))
        .listen((amp) {
      // amp.current est en dBFS (négatif). On mappe [-60, 0] -> [0, 1]
      final db = amp.current; // ex: -45.0
      // clamp à [-60..0] pour un affichage stable
      // ignore: unnecessary_cast
      final clamped = db.isFinite ? db.clamp(-60.0, 0.0) as double : -60.0;
      double norm = (clamped + 60.0) / 60.0; // 0 à -60dB, 1 à 0dB
      norm = (norm * widget.scaleFactor).clamp(0.0, 1.0);

      // Ajoute la valeur à droite, décale la fenêtre
      setState(() {
        _vals = List<double>.from(_vals)..removeAt(0)..add(norm);
      });
    }, onError: (_) {
      // en cas d'erreur du flux, on stoppe l'écoute pour éviter un spam
      _detach();
    });
  }

  void _detach() {
    _ampSub?.cancel();
    _ampSub = null;
  }

  @override
  Widget build(BuildContext context) {
    final isIdle = !widget.isRecording && !widget.isPaused;
    final color = widget.isPaused ? widget.pausedColor : widget.waveColor;

    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Waveform peint
          CustomPaint(
            painter: _BarsPainter(
              values: _vals,
              color: color,
              gap: widget.barGap,
              radius: widget.cornerRadius,
            ),
          ),

          // Messages overlay (facultatifs)
          if (isIdle && (widget.idleMessage != null))
            Center(
              child: Text(
                widget.idleMessage!,
                style: const TextStyle(
                  color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          if (widget.isPaused && (widget.pauseMessage != null))
            Center(
              child: Text(
                widget.pauseMessage!,
                style: const TextStyle(
                  color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
        ],
      ),
    );
  }
}

class _BarsPainter extends CustomPainter {
  _BarsPainter({
    required this.values,
    required this.color,
    required this.gap,
    required this.radius,
  });

  final List<double> values; // 0..1
  final Color color;
  final double gap;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final n = values.length;

    if (n <= 0) return;

    // largeur de barre calculée d'après width, n, gap
    final totalGap = gap * (n - 1);
    final barW = math.max(1.0, (size.width - totalGap) / n);
    final midY = size.height / 2.0;

    for (int i = 0; i < n; i++) {
      final v = values[i];
      final h = v * (size.height * 0.9) / 2.0; // 90% de la hauteur max
      final left = i * (barW + gap);
      final top = midY - h;
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, barW, h * 2.0),
        Radius.circular(radius),
      );
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BarsPainter old) {
    return old.values != values || old.color != color || old.gap != gap || old.radius != radius;
  }
}
