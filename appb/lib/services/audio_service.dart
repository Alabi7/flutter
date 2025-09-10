import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();
  static bool _isPlaying = false;

  static Future<void> playAlarmSound({String? soundPath, double volume = 0.8}) async {
    if (_isPlaying) return;

    try {
      _isPlaying = true;
      await _player.setVolume(volume);
      await _player.setReleaseMode(ReleaseMode.loop);
      
      if (soundPath != null && soundPath != 'default') {
        await _player.play(AssetSource(soundPath));
      } else {
        await _player.play(AssetSource('sounds/default_alarm.mp3'));
      }
    } catch (e) {
      print('Erreur lors de la lecture audio: $e');
    }
  }

  static Future<void> stopAlarmSound() async {
    _isPlaying = false;
    await _player.stop();
  }

  static Future<void> dispose() async {
    await _player.dispose();
  }
}

