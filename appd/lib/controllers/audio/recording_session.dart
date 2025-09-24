import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:appd/controllers/audio/timer_controller.dart';
import 'package:appd/controllers/audio/audio_capture_controller.dart';

/// Coordonne audio + timer pour rester en phase avec tes états UI.
class RecordingSession {
  RecordingSession({Duration? countdownFrom})
      : timer = TimerController(countdownFrom: countdownFrom),
        audio = AudioCaptureController() {
    // Optionnel : écouter les phases audio si tu veux propager ailleurs
  }

  final TimerController timer;
  final AudioCaptureController audio;

  ValueListenable<RecordingPhase> get phase => audio.phase;
  ValueListenable<Duration> get time => timer.time;

  Future<void> start() async {
    await audio.start();
    timer.start();
  }

  Future<void> pause() async {
    await audio.pause();
    timer.pause();
  }

  Future<void> resume() async {
    await audio.resume();
    timer.resume();
  }

  /// Stop “confirmé” → garde le fichier et stoppe le timer
  Future<String?> confirmStop() async {
    final path = await audio.stop();
    timer.pause();
    return path;
  }

  /// Cancel → supprime le fichier et remet timer + audio à zéro
  Future<void> cancel() async {
    await audio.cancel();
    timer.reset();
  }

  void dispose() {
    timer.dispose();
    audio.dispose();
  }
}









/// RecordingSession
/// ----------------
/// Rôle : **orchestration** entre `TimerController` (temps) et `AudioCaptureController` (audio).
/// Fournit une **façade simple** pour démarrer/pauser/reprendre/terminer l’enregistrement
/// tout en gardant le timer synchronisé.
///
/// Ce que la session expose :
/// - `phase` : `ValueListenable<RecordingPhase>` (idle/recording/paused) — issu de l’audio
/// - `time`  : `ValueListenable<Duration>` — issu du timer
///
/// API :
/// - `start()`        : démarre **audio + timer**
/// - `pause()`        : met en pause **audio + timer**
/// - `resume()`       : reprend **audio + timer**
/// - `confirmStop()`  : stoppe l’audio (conserve le fichier) + **pause** le timer, retourne le `filePath`
/// - `cancel()`       : annule l’audio (supprime le fichier) + **reset** le timer
///
/// Construction :
/// - `RecordingSession(countdownFrom: null)` -> **chronomètre**
/// - `RecordingSession(countdownFrom: Duration(...))` -> **compte à rebours**
///
/// Cycle de vie :
/// - Appeler `dispose()` pour relayer aux deux contrôleurs.
///
/// Exemple d’usage (UI) :
/// ```dart
/// final session = RecordingSession();
/// session.start();        // -> UI passe à "recording", timer démarre
/// session.pause();        // -> "paused", timer s'arrête
/// session.resume();       // -> "recording", timer reprend
/// final path = await session.confirmStop(); // -> idle, fichier prêt à l'usage
/// await session.cancel(); // -> idle, fichier supprimé, timer reset
/// ```
