// lib/screens/focus_screen.dart (Version mise à jour)
import 'package:flutter/material.dart';
import '../widgets/page_template.dart';

class FocusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: 'Focus', // Le titre s'affichera dans le header
      icon: Icons.center_focus_strong,
      description: 'Concentrez-vous sur vos tâches',
      content: _buildFocusContent(),
    );
  }

  Widget _buildFocusContent() {
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
        Text('• Timer Pomodoro'),
        Text('• Blocage d\'applications'),
        Text('• Sons de concentration'),
        Text('• Statistiques de focus'),
      ],
    );
  }
}