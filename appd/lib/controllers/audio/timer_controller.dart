import 'dart:async';
import 'package:flutter/foundation.dart';

/// Chronomètre (count-up) OU compte à rebours (count-down).
class TimerController {
  TimerController({Duration? countdownFrom})
      : _countdownFrom = countdownFrom,
        _time = ValueNotifier<Duration>(countdownFrom ?? Duration.zero);

  final Duration? _countdownFrom;        // null => count-up
  final ValueNotifier<Duration> _time;   // temps courant
  final ValueNotifier<bool> _running = ValueNotifier<bool>(false);

  Timer? _ticker;

  ValueListenable<Duration> get time => _time;
  ValueListenable<bool> get isRunning => _running;

  bool get _isCountdown => _countdownFrom != null;

  void start() {
    if (_running.value) return;
    _time.value = _isCountdown ? _countdownFrom! : Duration.zero;
    _running.value = true;
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_running.value) return;
      if (_isCountdown) {
        final next = _time.value - const Duration(seconds: 1);
        _time.value = next >= Duration.zero ? next : Duration.zero;
        if (_time.value == Duration.zero) pause(); // stop au 0
      } else {
        _time.value = _time.value + const Duration(seconds: 1);
      }
    });
  }

  void pause() {
    _running.value = false;
    _ticker?.cancel();
    _ticker = null;
  }

  void resume() {
    if (_running.value) return;
    if (_isCountdown && _time.value == Duration.zero) return; // terminé
    _running.value = true;
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!_running.value) return;
      if (_isCountdown) {
        final next = _time.value - const Duration(seconds: 1);
        _time.value = next >= Duration.zero ? next : Duration.zero;
        if (_time.value == Duration.zero) pause();
      } else {
        _time.value = _time.value + const Duration(seconds: 1);
      }
    });
  }

  void reset() {
    pause();
    _time.value = _isCountdown ? _countdownFrom! : Duration.zero;
  }

  void dispose() {
    _ticker?.cancel();
    _time.dispose();
    _running.dispose();
  }
}






/// TimerController
/// ----------------
/// Rôle : gère **uniquement le temps** de la session d’enregistrement.
/// - Peut fonctionner en **chronomètre** (count-up) ou en **compte à rebours** (count-down)
///   selon que `countdownFrom` est null (chronomètre) ou une durée (compte à rebours).
///
/// API principale :
/// - `start()`   : démarre le temps (0→… ou depuis `countdownFrom`)
/// - `pause()`   : met en pause (conserve la valeur courante)
/// - `resume()`  : reprend la marche
/// - `reset()`   : remet à 0 (ou à `countdownFrom`)
/// - `time`      : `ValueListenable<Duration>` exposant la valeur courante (écoutable dans l’UI)
/// - `isRunning` : `ValueListenable<bool>` indiquant si le timer tourne
///
/// Détails :
/// - Utilise un `Timer.periodic`(1s) interne, annulé proprement sur pause/reset/dispose.
/// - En mode compte à rebours, le temps descend jusqu’à `00:00:00` puis s’arrête
///   automatiquement (appel implicite à `pause()`).
///
/// Cycle de vie :
/// - Appeler `dispose()` quand vous n’en avez plus besoin (ex: `State.dispose()`).
///
/// Exemple d’usage :
/// ```dart
/// final timer = TimerController(countdownFrom: null); // chronomètre
/// timer.start();  // -> 00:00:01, 00:00:02, ...
/// timer.pause();  // stoppe la progression
/// timer.resume(); // reprend
/// timer.reset();  // revient à 00:00:00 (ou à countdownFrom)
/// ```
