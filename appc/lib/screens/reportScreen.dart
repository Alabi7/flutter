import 'package:flutter/material.dart';
import '../widgets/page_template.dart';

class ReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: 'Report', // Le titre s'affichera dans le header
      icon: Icons.bar_chart,
      description: 'Consultez vos statistiques et rapports',
      content: _buildReportContent(),
    );
  }

  Widget _buildReportContent() {
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
        Text('• Statistiques de sommeil'),
        Text('• Graphiques de progression'),
        Text('• Analyse des habitudes'),
        Text('• Rapports hebdomadaires'),
      ],
    );
  }
}