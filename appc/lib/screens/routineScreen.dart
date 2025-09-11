import 'package:flutter/material.dart';
import '../widgets/page_template.dart';

class RoutineScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: 'Routine', // Le titre s'affichera dans le header
      icon: Icons.repeat,
      description: 'Configurez vos routines quotidiennes',
      content: _buildRoutineContent(),
    );
  }

  Widget _buildRoutineContent() {
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
        Text('• Routines matinales'),
        Text('• Routines du soir'),
        Text('• Suivi des habitudes'),
        Text('• Rappels personnalisés'),
      ],
    );
  }
}

