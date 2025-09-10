// services/vibration_service.dart
import 'package:vibration/vibration.dart';
import 'dart:async';

class VibrationService {
  static Timer? _vibrationTimer;

  static Future<void> startAlarmVibration() async {
    if (await Vibration.hasVibrator() ?? false) {
      _vibrationTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        Vibration.vibrate(duration: 500);
      });
    }
  }

  static void stopVibration() {
    _vibrationTimer?.cancel();
    _vibrationTimer = null;
    Vibration.cancel();
  }
}
