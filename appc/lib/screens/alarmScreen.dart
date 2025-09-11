import 'package:flutter/material.dart';
import '../widgets/page_template.dart';

class AlarmScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: 'Alarm', // Le titre s'affichera dans le header
      icon: Icons.alarm,
      description: 'Gérez vos alarmes ici',
      content: _buildAlarmContent(),
    );
  }

  Widget _buildAlarmContent() {
    return Column(
      children: [
        Text(
          'Fonctionnalités à venir :',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 10),
        Text('• Créer des alarmes personnalisées'),
        Text('• Défis pour se réveiller'),
        Text('• Sons d\'alarme variés'),
        Text('• Répétition et snooze'),
      ],
    );
  }
}