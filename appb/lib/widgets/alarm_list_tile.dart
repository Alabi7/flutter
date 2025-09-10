import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/alarm_model.dart';
import '../providers/alarm_provider.dart';
import '../utils/time_formatter.dart';

class AlarmListTile extends StatelessWidget {
  final AlarmModel alarm;

  const AlarmListTile({Key? key, required this.alarm}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Icon(
          Icons.alarm,
          size: 32,
          color: alarm.isEnabled ? Theme.of(context).primaryColor : Colors.grey,
        ),
        title: Text(
          TimeFormatter.format24Hour(alarm.dateTime),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: alarm.isEnabled ? null : Colors.grey,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(alarm.title),
            SizedBox(height: 4),
            Text(_getRepeatText()),
          ],
        ),
        trailing: Switch(
          value: alarm.isEnabled,
          onChanged: (value) {
            Provider.of<AlarmProvider>(context, listen: false)
                .toggleAlarm(alarm.id);
          },
        ),
        onTap: () {
          // Naviguer vers l'écran d'édition
        },
      ),
    );
  }

  String _getRepeatText() {
    if (alarm.repeatDays.every((day) => !day)) {
      return 'Une seule fois';
    }
    
    final days = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
    final activeDays = <String>[];
    
    for (int i = 0; i < alarm.repeatDays.length; i++) {
      if (alarm.repeatDays[i]) {
        activeDays.add(days[i]);
      }
    }
    
    return activeDays.join(', ');
  }
}