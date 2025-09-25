import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:record/record.dart';

/// Bulle de chat BLEUE avec waveform blanche + "playhead" central.
/// - recording: animation en temps réel (depuis `record`).
/// - paused   : tracé figé.
/// - idle     : bulle vide (sans wave).
///
/// IMPORTANT : passe le *même* AudioRecorder que celui de ton enregistrement.
class BlueLiveVoiceBubble extends StatefulWidget {
  const BlueLiveVoiceBubble({
    super.key,
    required this.recorder,
    required this.recording,
    required this.paused,
    this.height = 76,
    this.background = const Color(0xFF2F67FF), // bleu bulle
    this.cornerRadius = 14,
    this.showLeftPlayGlyph = true,
  });

  final AudioRecorder recorder;
  final bool recording;
  final bool paused;

  final double height;
  final Color background;
  final double cornerRadius;
  final bool showLeftPlayGlyph;

  @override
  State<BlueLiveVoiceBubble> createState() => _BlueLiveVoiceBubbleState();
}



class _BlueLiveVoiceBubbleState extends State<BlueLiveVoiceBubble> {
  // --- Style/const identiques...
  static const int _samples = 96;
  static const double _barW = 4.0, _gap = 2.5, _radius = 2.5;
  static const Duration _uiInterval = Duration(milliseconds: 90);  // vitesse visuelle (lente)
  static const Duration _ampInterval = Duration(milliseconds: 30); // lecture micro (rapide)
  static const double _floorA = 0.05, _floorB = 0.09;

  late List<double> _vals;
  StreamSubscription<Amplitude>? _amp; // flux amplitude (rapide)
  Timer? _uiTick;                       // timer UI (lent)
  double _lastRaw = 0;                  // dernière amplitude normalisée 0..1 (rapide)
  double _ema = 0;                      // lissage affiché
  bool _toggle = false;

  @override
  void initState() {
    super.initState();
    _vals = List<double>.filled(_samples, 0.0, growable: false);
    _attachIfNeeded();
  }

  @override
  void didUpdateWidget(covariant BlueLiveVoiceBubble old) {
    super.didUpdateWidget(old);
    if (!old.recording && widget.recording) _attach();
    if (old.recording && !widget.recording) _detach();
    if (!widget.recording && !widget.paused) {
      _vals = List<double>.filled(_samples, 0.0, growable: false);
      _ema = 0; _lastRaw = 0;
    }
  }

  @override
  void dispose() {
    _detach();
    super.dispose();
  }

  void _attachIfNeeded() { if (widget.recording) _attach(); }

  // ↓↓↓ CHANGEMENT ICI : on sépare prélèvement rapide et dessin lent
  void _attach() {
    _detach(); // sécurité

    // 1) flux amplitude rapide → met seulement à jour _lastRaw (pas de setState)
    _amp = widget.recorder.onAmplitudeChanged(_ampInterval).listen((a) {
      double v;
      if (a.current.isFinite && a.current <= 0.0) {
        final db = a.current.clamp(-60.0, 0.0);
        v = (db + 60.0) / 60.0;
      } else {
        final rawMax = (a.max.isFinite && a.max > 0) ? a.max : 32768.0;
        final norm = (a.current / rawMax).clamp(0.0, 1.0);
        v = math.pow(norm, 0.35).toDouble();
      }
      _lastRaw = v; // on garde juste la dernière valeur dispo
    }, onError: (_) { _detach(); });

    // 2) timer UI lent → dessine avec la DERNIÈRE amplitude (donc retard réduit)
    _uiTick = Timer.periodic(_uiInterval, (_) {
      // lissage et plancher
      _ema = 0.6 * _ema + 0.4 * _lastRaw;
      double out = _ema;
      if (out < _floorA) { _toggle = !_toggle; out = _toggle ? _floorA : _floorB; }

      if (mounted) {
        setState(() {
          _vals = List<double>.from(_vals)..removeAt(0)..add(out.clamp(0.0, 1.0));
        });
      }
    });
  }

  void _detach() {
    _amp?.cancel(); _amp = null;
    _uiTick?.cancel(); _uiTick = null;
  }

  @override
  Widget build(BuildContext context) {
    final isIdle = !widget.recording && !widget.paused;
    final bg = widget.background;
    if (isIdle) {
      return Container(height: widget.height,
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(widget.cornerRadius)));
    }
    return Container(
      height: widget.height,
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(widget.cornerRadius)),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Align(alignment: Alignment.centerLeft,
            child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 18)),
          Padding(
            padding: const EdgeInsets.only(left: 22, right: 6),
            child: CustomPaint(
              painter: _BubbleWavePainter(
                values: _vals, barW: _barW, gap: _gap, radius: _radius, color: Colors.white),
            ),
          ),
          IgnorePointer(child: CustomPaint(painter: _CenterLinePainter(color: Colors.white, thickness: 2))),
        ],
      ),
    );
  }
}
class _BubbleWavePainter extends CustomPainter {
  _BubbleWavePainter({
    required this.values,
    required this.color,
    required this.barW,
    required this.gap,
    required this.radius,
  });

  final List<double> values; // 0..1
  final Color color;
  final double barW;
  final double gap;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final n = values.length;
    if (n == 0) return;

    // Zone utile (on ne dessine pas sous l’icône de gauche)
    final w = size.width;
    final h = size.height;
    final midY = h / 2.0;

    // On remplit en partant de la GAUCHE, largeur fixe pour look WhatsApp
    for (int i = 0; i < n; i++) {
      final left = i * (barW + gap);
      if (left > w) break;

      final v = values[i];
      final hh = v * (h * 0.86) / 2.0; // 86% de la hauteur max pour un peu d'air
      final top = midY - hh;

      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, barW, hh * 2),
        Radius.circular(radius),
      );
      canvas.drawRRect(rrect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BubbleWavePainter old) {
    return old.values != values ||
           old.color  != color  ||
           old.barW   != barW   ||
           old.gap    != gap    ||
           old.radius != radius;
  }
}

class _CenterLinePainter extends CustomPainter {
  _CenterLinePainter({required this.color, this.thickness = 2});

  final Color color;
  final double thickness;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;

    final x = size.width / 2;
    // petite marge top/bottom pour être joli
    final top = size.height * 0.16;
    final bottom = size.height * 0.84;
    canvas.drawLine(Offset(x, top), Offset(x, bottom), paint);
  }

  @override
  bool shouldRepaint(covariant _CenterLinePainter old) =>
      old.color != color || old.thickness != thickness;
}
