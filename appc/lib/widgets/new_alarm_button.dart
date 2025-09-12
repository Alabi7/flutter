import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'list_alarm.dart';

class NewAlarmButton extends StatelessWidget {
  const NewAlarmButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showNewAlarmBottomSheet(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        elevation: 3,
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add, size: 20),
          SizedBox(width: 3),
          Text(
            'New Alarm',
            style: TextStyle(
              fontSize: 12, 
              fontWeight: FontWeight.w600,
              fontFamily: 'Roboto'
            ),
          ),
        ],
      ),
    );
  }

  void _showNewAlarmBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>  ListAlarm(),
    );
  }
}
