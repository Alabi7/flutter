import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

enum RecordingPhase { idle, recording, paused }



class AudioCaptureController {
  AudioCaptureController() : phase = ValueNotifier(RecordingPhase.idle);

  final AudioRecorder _recorder = AudioRecorder();
  AudioRecorder get recorder => _recorder;
  
  final ValueNotifier<RecordingPhase> phase;
  String? _filePath;

  String? get filePath => _filePath;

  Future<void> start() async {
    if (phase.value == RecordingPhase.recording) return;
    if (!await _recorder.hasPermission()) return;

    final dir = await getApplicationDocumentsDirectory();
    _filePath = '${dir.path}/rec_${DateTime.now().millisecondsSinceEpoch}.m4a';
    // final tmp = await getTemporaryDirectory(); // stockage éphémère

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.aacLc,
        sampleRate: 44100,
        bitRate: 128000,
      ),
      path: _filePath!,
    );
    phase.value = RecordingPhase.recording;
  }

  Future<void> pause() async {
    if (phase.value != RecordingPhase.recording) return;
    await _recorder.pause();
    phase.value = RecordingPhase.paused;
  }

  Future<void> resume() async {
    if (phase.value != RecordingPhase.paused) return;
    await _recorder.resume();
    phase.value = RecordingPhase.recording;
  }

  /// Arrête l’enregistrement et garde le fichier. Retourne le path final.
  Future<String?> stop() async {
    if (phase.value == RecordingPhase.idle) return _filePath;
    final path = await _recorder.stop();
    phase.value = RecordingPhase.idle;
    // _filePath reste le même (ou path si non-null)
    _filePath = path ?? _filePath;
    return _filePath;
  }

  /// Annule tout et supprime le fichier si présent.
  Future<void> cancel() async {
    try { await _recorder.stop(); } catch (_) {}
    if (_filePath != null) {
      final f = File(_filePath!);
      if (await f.exists()) { await f.delete(); }
    }
    _filePath = null;
    phase.value = RecordingPhase.idle;
  }

  void dispose() {
    _recorder.dispose();
    phase.dispose();
  }
}




/// AudioCaptureController
/// ----------------------
/// Rôle : gère **uniquement l’enregistrement audio local** via le plugin `record`.
///
/// États (`RecordingPhase`) :
/// - `idle`      : pas d’enregistrement actif
/// - `recording` : en train d’enregistrer
/// - `paused`    : enregistrement en pause
///
/// API principale :
/// - `start()`         : démarre l’enregistrement (crée un fichier `.m4a` dans Documents)
/// - `pause()`         : met en pause (fichier toujours ouvert)
/// - `resume()`        : reprend l’enregistrement en cours
/// - `stop()`          : **arrête** et **conserve** le fichier, retourne le `filePath`
/// - `cancel()`        : **annule** et **supprime** le fichier si créé
/// - `phase`           : `ValueListenable<RecordingPhase>` pour piloter l’UI
/// - `filePath`        : chemin du fichier courant (peut être null avant start/si cancel)
///
/// Détails d’implémentation :
/// - Format : AAC-LC `.m4a` (`sampleRate: 44100`, `bitRate: 128000`)
/// - Emplacement : **dossier Documents de l’app**
///   (`getApplicationDocumentsDirectory()`), nommage : `rec_<timestamp>.m4a`.
/// - `stop()` ferme l’enregistrement et garde le fichier.
/// - `cancel()` ferme (si besoin) **et supprime** le fichier créé.
///
/// Permissions :
/// - Android : `<uses-permission android:name="android.permission.RECORD_AUDIO"/>`
/// - iOS     : `NSMicrophoneUsageDescription` dans `Info.plist`
///
/// Cycle de vie :
/// - Appeler `dispose()` pour libérer le `AudioRecorder`.
///
/// Exemple d’usage :
/// ```dart
/// final audio = AudioCaptureController();
/// await audio.start();          // passe à RecordingPhase.recording
/// await audio.pause();          // -> paused
/// await audio.resume();         // -> recording
/// final path = await audio.stop(); // -> idle, et `path` vers le .m4a créé
/// await audio.cancel();         // si vous voulez tout annuler + supprimer le fichier
/// ```
