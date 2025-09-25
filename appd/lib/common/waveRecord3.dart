import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:record/record.dart';

/// Waveform "live" branché sur le *même* AudioRecorder.
/// LOGIQUE INCHANGÉE : on ne modifie que l'affichage.
/// - Enregistrement: barres indigo + petit plancher visuel en silence
/// - Pause: figé + couleur grise
/// - Idle: placeholder/texte (pas de barres)
class WaveRecord extends StatefulWidget {
  const WaveRecord({
    super.key,
    required this.recorder,
    required this.isRecording,
    required this.isPaused,
    this.waveColor = const Color(0xFF4F46E5),
    this.pausedColor = const Color(0xFF9CA3AF),
    this.backgroundColor = const Color(0xFFF1F5F9),

    // --- paramètres existants, inchangés ---
    this.scaleFactor = 1.0,
    this.samples = 120,
    this.barGap = 2.0,
    this.cornerRadius = 3.0,
    this.idleMessage,
    this.pauseMessage,

    // --- NOUVEAUTÉS purement visuelles ---
    this.barThickness,              // si null => largeur auto (comme avant)
    this.visualFloor = 0.06,        // plancher des barres quand c'est très calme (0..1)
  });

  final AudioRecorder recorder;
  final bool isRecording;
  final bool isPaused;

  final Color waveColor;
  final Color pausedColor;
  final Color backgroundColor;

  final double scaleFactor;
  final int samples;
  final double barGap;
  final double cornerRadius;

  final String? idleMessage;
  final String? pauseMessage;

  /// Largeur fixe des barres (px). Si null → calcule auto (comportement initial).
  final double? barThickness;

  /// Plancher visuel (hauteur minimale normalisée 0..1) appliqué
  /// UNIQUEMENT PENDANT l'enregistrement, pour ne jamais "disparaître".
  final double visualFloor;

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
    _ampSub = widget.recorder
        .onAmplitudeChanged(const Duration(milliseconds: 80))
        .listen((amp) {
      // LOGIQUE INCHANGÉE
      final db = amp.current;
      // ignore: unnecessary_cast
      final clamped = db.isFinite ? db.clamp(-60.0, 0.0) as double : -60.0;
      double norm = (clamped + 60.0) / 60.0; // 0..1
      norm = (norm * widget.scaleFactor).clamp(0.0, 1.0);

      setState(() {
        _vals = List<double>.from(_vals)..removeAt(0)..add(norm);
      });
    }, onError: (_) {
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
    final color  = widget.isPaused ? widget.pausedColor : widget.waveColor;

    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: _BarsPainter(
              values: _vals,
              color: color,
              gap: widget.barGap,
              radius: widget.cornerRadius,
              // NOUVEAU ↓
              barThickness: widget.barThickness,
              applyFloor: widget.isRecording,   // plancher uniquement en enregistrement
              visualFloor: widget.visualFloor,  // petite barre quand silence
            ),
          ),

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
    this.barThickness,          // largeur fixe des barres (si null → auto)
    this.applyFloor = false,    // applique le plancher visuel ?
    this.visualFloor = 0.06,    // hauteur mini (0..1) quand applyFloor = true
  });

  final List<double> values; // 0..1
  final Color color;
  final double gap;
  final double radius;

  final double? barThickness;
  final bool applyFloor;
  final double visualFloor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final n = values.length;
    if (n <= 0) return;

    // Largeur de barre : soit fixe, soit calculée comme avant
    double barW;
    double effGap = gap;

    if (barThickness != null) {
      barW = math.max(1.0, barThickness!);
      final totalBarsW = barW * n;
      final remain = size.width - totalBarsW;
      effGap = n > 1 ? math.max(0.0, remain / (n - 1)) : 0.0;
    } else {
      final totalGap = gap * (n - 1);
      barW = math.max(1.0, (size.width - totalGap) / n);
    }

    final midY = size.height / 2.0;

    for (int i = 0; i < n; i++) {
      final raw = values[i];
      // "plancher" visuel uniquement pendant RECORDING (sinon on garde 0)
      final v = applyFloor ? math.max(raw, visualFloor) : raw;

      final h = v * (size.height * 0.9) / 2.0; // 90% de la hauteur max
      final left = i * (barW + effGap);
      final top = midY - h;

      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, barW, h * 2.0),
        Radius.circular(radius),             // arrondi "WhatsApp-like"
      );
      canvas.drawRRect(rrect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BarsPainter old) {
    return old.values != values ||
           old.color  != color  ||
           old.gap    != gap    ||
           old.radius != radius ||
           old.barThickness != barThickness ||
           old.applyFloor  != applyFloor ||
           old.visualFloor != visualFloor;
  }
}
