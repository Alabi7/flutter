// import 'dart:isolate';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import '../models/alarm_model.dart';
import 'notification_service.dart';
import 'audio_service.dart';
import 'Vibration_service.dart';

class AlarmService {
  static Future<void> initialize() async {
    await AndroidAlarmManager.initialize();
    await initializeBackgroundService();
  }

  static Future<void> initializeBackgroundService() async {
    final service = FlutterBackgroundService();
    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
      ),
    );
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) {
    // Service en arrière-plan pour maintenir les alarmes actives
    service.on('alarm_trigger').listen((event) {
      final alarmId = event?['alarmId'] as String;
      _triggerAlarm(alarmId);
    });
  }

  static Future<void> scheduleAlarm(AlarmModel alarm) async {
    final now = DateTime.now();
    var scheduledTime = alarm.dateTime;

    // Si l'alarme est pour aujourd'hui mais dans le passé, programmer pour demain
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(Duration(days: 1));
    }

    // Programmer l'alarme avec AndroidAlarmManager
    await AndroidAlarmManager.oneShotAt(
      scheduledTime,
      alarm.id.hashCode,
      _alarmCallback,
      params: {
        'alarmId': alarm.id,
        'title': alarm.title,
      },
      exact: true,
      wakeup: true,
    );
  }

  static Future<void> cancelAlarm(String alarmId) async {
    await AndroidAlarmManager.cancel(alarmId.hashCode);
  }

  @pragma('vm:entry-point')
  static void _alarmCallback(int id, Map<String, dynamic> params) {
    final alarmId = params['alarmId'] as String;
    _triggerAlarm(alarmId);
  }

  static void _triggerAlarm(String alarmId) {
    // Déclencher la notification
    NotificationService.showAlarmNotification(
      id: alarmId,
      title: 'Réveil !',
      body: 'Il est temps de se réveiller !',
    );

    // Démarrer la lecture audio
    AudioService.playAlarmSound();

    // Démarrer la vibration
    VibrationService.startAlarmVibration();
  }
}