import 'package:flutter/material.dart';
import '../widgets/custom_header.dart';
import '../widgets/new_alarm_button.dart';
import '../utils/colors.dart';

class AlarmScreen extends StatelessWidget {
  const AlarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const CustomHeader(title: 'Alarm'),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Icon(Icons.alarm, size: 80, color: AppColors.primary),
          const SizedBox(height: 20),
          Text(
            'Aucune alarme configurée',
            style: TextStyle(fontSize: 18, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          Container(
            height: 400,
            color: Colors.redAccent,
          ),
        ],
      ),

      // 👉 Ton NewAlarmButton est placé en bas à droite
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: bottomInset), // remonte au-dessus de la navbar
        child: const NewAlarmButton(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
