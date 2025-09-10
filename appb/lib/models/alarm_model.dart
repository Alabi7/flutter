import 'package:hive/hive.dart';

part 'alarm_model.g.dart'; // Important : ce fichier sera généré

@HiveType(typeId: 0)
class AlarmModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  DateTime dateTime;

  @HiveField(3)
  bool isEnabled;

  @HiveField(4)
  List<bool> repeatDays; // Lun, Mar, Mer, Jeu, Ven, Sam, Dim

  @HiveField(5)
  String soundPath;

  @HiveField(6)
  double volume;

  @HiveField(7)
  bool vibrate;

  @HiveField(8)
  AlarmDismissMode dismissMode;

  @HiveField(9)
  int snoozeCount;

  @HiveField(10)
  int snoozeDuration; // en minutes

  AlarmModel({
    required this.id,
    required this.title,
    required this.dateTime,
    this.isEnabled = true,
    List<bool>? repeatDays,
    this.soundPath = 'default',
    this.volume = 0.8,
    this.vibrate = true,
    this.dismissMode = AlarmDismissMode.button,
    this.snoozeCount = 3,
    this.snoozeDuration = 5,
  }) : repeatDays = repeatDays ?? List.filled(7, false);

  // Méthode pour créer une copie avec des modifications
  AlarmModel copyWith({
    String? id,
    String? title,
    DateTime? dateTime,
    bool? isEnabled,
    List<bool>? repeatDays,
    String? soundPath,
    double? volume,
    bool? vibrate,
    AlarmDismissMode? dismissMode,
    int? snoozeCount,
    int? snoozeDuration,
  }) {
    return AlarmModel(
      id: id ?? this.id,
      title: title ?? this.title,
      dateTime: dateTime ?? this.dateTime,
      isEnabled: isEnabled ?? this.isEnabled,
      repeatDays: repeatDays ?? this.repeatDays,
      soundPath: soundPath ?? this.soundPath,
      volume: volume ?? this.volume,
      vibrate: vibrate ?? this.vibrate,
      dismissMode: dismissMode ?? this.dismissMode,
      snoozeCount: snoozeCount ?? this.snoozeCount,
      snoozeDuration: snoozeDuration ?? this.snoozeDuration,
    );
  }

  @override
  String toString() {
    return 'AlarmModel(id: $id, title: $title, dateTime: $dateTime, isEnabled: $isEnabled)';
  }
}

@HiveType(typeId: 1)
enum AlarmDismissMode {
  @HiveField(0)
  button,
  @HiveField(1)
  math,
  @HiveField(2)
  qrCode,
  @HiveField(3)
  photo,
  @HiveField(4)
  shake,
}