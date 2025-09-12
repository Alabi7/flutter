import 'package:flutter/material.dart';
import '../lib/utils/colors.dart';

class ListAlarm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6, // 60% de la hauteur de l'écran
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Petite barre au sommet
          Container(
            margin: EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          SizedBox(height: 20),
          
          // Titre "New alarm"
          Text(
            'New alarm',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          
          SizedBox(height: 30),
          
          // Liste des types d'alarmes
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildAlarmTypeItem(
                    context,
                    icon: Icons.alarm,
                    title: 'Alarm 1',
                    description: 'Alarme simple avec sonnerie classique',
                    onTap: () {
                      Navigator.pop(context);
                      // Action pour Alarm 1
                      print('Alarm 1 sélectionnée');
                    },
                  ),
                  
                  _buildAlarmTypeItem(
                    context,
                    icon: Icons.access_alarm,
                    title: 'Alarm 2',
                    description: 'Alarme avec défis pour se réveiller',
                    onTap: () {
                      Navigator.pop(context);
                      // Action pour Alarm 2
                      print('Alarm 2 sélectionnée');
                    },
                  ),
                  
                  _buildAlarmTypeItem(
                    context,
                    icon: Icons.alarm_add,
                    title: 'Alarm 3',
                    description: 'Alarme progressive avec sons naturels',
                    onTap: () {
                      Navigator.pop(context);
                      // Action pour Alarm 3
                      print('Alarm 3 sélectionnée');
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlarmTypeItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey[200]!,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Icône
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                
                SizedBox(width: 16),
                
                // Titre et description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Flèche
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textSecondary,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}