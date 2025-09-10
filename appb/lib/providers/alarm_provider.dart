import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/alarm_model.dart';
import '../services/alarm_service.dart';

class AlarmProvider extends ChangeNotifier {
  final Box<AlarmModel> _alarmBox = Hive.box<AlarmModel>('alarms');
  List<AlarmModel> _alarms = [];

  List<AlarmModel> get alarms => _alarms;

  AlarmProvider() {
    _loadAlarms();
  }

  void _loadAlarms() {
    _alarms = _alarmBox.values.toList();
    _alarms.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    notifyListeners();
  }

  Future<void> addAlarm(AlarmModel alarm) async {
    await _alarmBox.put(alarm.id, alarm);
    await AlarmService.scheduleAlarm(alarm);
    _loadAlarms();
  }

  Future<void> updateAlarm(AlarmModel alarm) async {
    await _alarmBox.put(alarm.id, alarm);
    await AlarmService.cancelAlarm(alarm.id);
    if (alarm.isEnabled) {
      await AlarmService.scheduleAlarm(alarm);
    }
    _loadAlarms();
  }

  Future<void> deleteAlarm(String alarmId) async {
    await _alarmBox.delete(alarmId);
    await AlarmService.cancelAlarm(alarmId);
    _loadAlarms();
  }

  Future<void> toggleAlarm(String alarmId) async {
    final alarm = _alarmBox.get(alarmId);
    if (alarm != null) {
      alarm.isEnabled = !alarm.isEnabled;
      await updateAlarm(alarm);
    }
  }
}