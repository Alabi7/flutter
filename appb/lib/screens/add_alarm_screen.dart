import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/alarm_model.dart';
import '../providers/alarm_provider.dart';

class AddAlarmScreen extends StatefulWidget {
  final AlarmModel? existingAlarm;

  const AddAlarmScreen({Key? key, this.existingAlarm}) : super(key: key);

  @override
  _AddAlarmScreenState createState() => _AddAlarmScreenState();
}

class _AddAlarmScreenState extends State<AddAlarmScreen> {
  final _titleController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  List<bool> _repeatDays = List.filled(7, false);
  String _selectedSound = 'default';
  double _volume = 0.8;
  bool _vibrate = true;
  AlarmDismissMode _dismissMode = AlarmDismissMode.button;
  int _snoozeCount = 3;
  int _snoozeDuration = 5;

  final List<String> _dayNames = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
  final List<String> _soundOptions = ['default', 'gentle', 'loud', 'nature', 'classic'];
  
  final Map<AlarmDismissMode, String> _dismissModeNames = {
    AlarmDismissMode.button: 'Bouton simple',
    AlarmDismissMode.math: 'Calcul mathématique',
    AlarmDismissMode.qrCode: 'Scanner QR Code',
    AlarmDismissMode.photo: 'Prendre une photo',
    AlarmDismissMode.shake: 'Secouer le téléphone',
  };

  @override
  void initState() {
    super.initState();
    if (widget.existingAlarm != null) {
      _loadExistingAlarm();
    }
  }

  void _loadExistingAlarm() {
    final alarm = widget.existingAlarm!;
    _titleController.text = alarm.title;
    _selectedTime = TimeOfDay.fromDateTime(alarm.dateTime);
    _repeatDays = List.from(alarm.repeatDays);
    _selectedSound = alarm.soundPath;
    _volume = alarm.volume;
    _vibrate = alarm.vibrate;
    _dismissMode = alarm.dismissMode;
    _snoozeCount = alarm.snoozeCount;
    _snoozeDuration = alarm.snoozeDuration;
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveAlarm() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez entrer un titre pour l\'alarme')),
      );
      return;
    }

    final now = DateTime.now();
    var alarmDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    // Si l'heure est déjà passée aujourd'hui, programmer pour demain
    if (alarmDateTime.isBefore(now)) {
      alarmDateTime = alarmDateTime.add(Duration(days: 1));
    }

    final alarm = AlarmModel(
      id: widget.existingAlarm?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      dateTime: alarmDateTime,
      repeatDays: _repeatDays,
      soundPath: _selectedSound,
      volume: _volume,
      vibrate: _vibrate,
      dismissMode: _dismissMode,
      snoozeCount: _snoozeCount,
      snoozeDuration: _snoozeDuration,
    );

    final provider = Provider.of<AlarmProvider>(context, listen: false);
    
    if (widget.existingAlarm != null) {
      provider.updateAlarm(alarm);
    } else {
      provider.addAlarm(alarm);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingAlarm != null ? 'Modifier l\'alarme' : 'Nouvelle alarme'),
        actions: [
          TextButton(
            onPressed: _saveAlarm,
            child: Text(
              'SAUVER',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre de l'alarme
            _buildSectionTitle('Titre'),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Mon alarme',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 24),

            // Heure
            _buildSectionTitle('Heure'),
            InkWell(
              onTap: _selectTime,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, size: 32),
                    SizedBox(width: 16),
                    Text(
                      _selectedTime.format(context),
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Icon(Icons.edit),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),

            // Répétition
            _buildSectionTitle('Répéter'),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _dayNames.asMap().entries.map((entry) {
                        int index = entry.key;
                        String day = entry.value;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _repeatDays[index] = !_repeatDays[index];
                            });
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _repeatDays[index] 
                                ? Theme.of(context).primaryColor 
                                : Colors.grey[300],
                            ),
                            child: Center(
                              child: Text(
                                day,
                                style: TextStyle(
                                  color: _repeatDays[index] ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),

            // Son d'alarme
            _buildSectionTitle('Son d\'alarme'),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedSound,
                      decoration: InputDecoration(
                        labelText: 'Son',
                        border: OutlineInputBorder(),
                      ),
                      items: _soundOptions.map((sound) {
                        return DropdownMenuItem(
                          value: sound,
                          child: Text(sound.toUpperCase()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSound = value!;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text('Volume: '),
                        Expanded(
                          child: Slider(
                            value: _volume,
                            onChanged: (value) {
                              setState(() {
                                _volume = value;
                              });
                            },
                            divisions: 10,
                            label: '${(_volume * 100).round()}%',
                          ),
                        ),
                      ],
                    ),
                    SwitchListTile(
                      title: Text('Vibration'),
                      value: _vibrate,
                      onChanged: (value) {
                        setState(() {
                          _vibrate = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),

            // Mode de désactivation
            _buildSectionTitle('Mode de désactivation'),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: DropdownButtonFormField<AlarmDismissMode>(
                  value: _dismissMode,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: _dismissModeNames.entries.map((entry) {
                    return DropdownMenuItem(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _dismissMode = value!;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 24),

            // Snooze
            _buildSectionTitle('Snooze'),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Nombre de snoozes: '),
                        Spacer(),
                        DropdownButton<int>(
                          value: _snoozeCount,
                          items: [0, 1, 2, 3, 5, 10].map((count) {
                            return DropdownMenuItem(
                              value: count,
                              child: Text('$count'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _snoozeCount = value!;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Text('Durée du snooze: '),
                        Spacer(),
                        DropdownButton<int>(
                          value: _snoozeDuration,
                          items: [1, 3, 5, 10, 15, 30].map((duration) {
                            return DropdownMenuItem(
                              value: duration,
                              child: Text('$duration min'),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _snoozeDuration = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}