import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RecordLottie extends StatefulWidget {
  const RecordLottie({
    super.key,
    required this.isRecording,
    required this.isPaused,
    this.asset = 'assets/animations/sphereAnimation1.json',
    // this.asset = 'assets/animations/wave.json',
    this.height = 115,
    this.backgroundColor = const Color.fromARGB(0, 241, 245, 249),
    this.borderRadius = 8.0,
    this.speed = 1.0, // 1.0 = normal, 2.0 = 2x plus rapide
  });

  final bool isRecording;
  final bool isPaused;

  final String asset;
  final double height;
  final Color backgroundColor;
  final double borderRadius;
  final double speed;

  @override
  State<RecordLottie> createState() => _RecordLottieState();
}

class _RecordLottieState extends State<RecordLottie>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(vsync: this);
  bool _loaded = false;
  Duration _baseDuration = const Duration(milliseconds: 1200);

  static const _greyMatrix = <double>[
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0.2126, 0.7152, 0.0722, 0, 0,
    0,      0,      0,      1, 0,
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Duration _scaled(Duration d, double speed) {
    final sp = (speed <= 0) ? 1.0 : speed;
    return Duration(microseconds: (d.inMicroseconds / sp).round());
  }


void _syncPlayback() {
  if (!_loaded) return;

  final isIdle = !widget.isRecording && !widget.isPaused;

  // 1) Idle : on revient proprement au début
  if (isIdle) {
    _ctrl.stop(canceled: false);
    _ctrl.value = 0.0;
    return;
  }

  // 2) Pause : on fige EXACTEMENT à la frame courante
  if (widget.isPaused) {
    _ctrl.stop(canceled: false);
    return;
  }

  // 3) Recording : on assure une boucle sans couture
  final period = _scaled(_baseDuration, widget.speed);
  final pos = _ctrl.value.clamp(0.0, 1.0);

  // a) Si on reprend en plein milieu, on termine d’abord ce cycle
  if (pos > 0.0 && pos < 1.0) {
    _ctrl.stop(canceled: false);
    final remainingUs = (period.inMicroseconds * (1.0 - pos)).round();
    _ctrl
        .animateTo(
          1.0,
          duration: Duration(microseconds: remainingUs),
          curve: Curves.linear,
        )
        .whenComplete(() {
      if (!mounted || !widget.isRecording) return;
      // b) Puis on boucle 0 → 1 → 0 → 1... (sans “saut”)
      _ctrl.repeat(min: 0.0, max: 1.0, period: period);
    });
  } else {
    // Déjà en bout ou au début : démarre la boucle normale 0 → 1
    _ctrl.stop(canceled: false);
    _ctrl.repeat(min: 0.0, max: 1.0, period: period);
  }
}


  @override
  void didUpdateWidget(covariant RecordLottie oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncPlayback();
  }

  @override
  Widget build(BuildContext context) {
    final isIdle = !widget.isRecording && !widget.isPaused;

    if (isIdle) {
      // conteneur “vide” comme placeholder
      return Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
      );
    }

    final lottie = Lottie.asset(
      widget.asset,
      controller: _ctrl,
      fit: BoxFit.contain,
      onLoaded: (comp) {
        _baseDuration = comp.duration;
        _loaded = true;
        // on ne démarre pas ici; on laisse _syncPlayback décider
        _ctrl.value = _ctrl.value.clamp(0.0, 1.0);
        _syncPlayback();
        setState(() {}); // 1er build avec _loaded = true (safe)
      },
    );

    final child = widget.isPaused
        ? ColorFiltered(
            colorFilter: const ColorFilter.matrix(_greyMatrix),
            child: lottie,
          )
        : lottie;

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(widget.borderRadius),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
