import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../utils/colors.dart';

class ListAlarm extends StatelessWidget {
  const ListAlarm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // 👈 prend seulement la hauteur de son contenu
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barre grise en haut
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Titre aligné à gauche
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'New alarm',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Liste des options
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: const FaIcon(FontAwesomeIcons.solidClock, color: Colors.deepPurple),
            ),
            title: const Text(
              "Alarm 1",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            subtitle: const Text(
              "Alarme simple avec sonnerie classique",
              style: TextStyle(
                // fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.black45),
            onTap: () {
              Navigator.pop(context);
              print("Alarm 1 sélectionnée");
            },
          ),

          Divider(color: Colors.grey[300], indent: 16, endIndent: 16),

          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            leading: CircleAvatar(
              backgroundColor: Colors.orange.withOpacity(0.1),
              child: const FaIcon(FontAwesomeIcons.puzzlePiece, color: Colors.orange),
            ),
            title: const Text(
              "Alarm 2",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            subtitle: const Text(
              "Alarme avec défis pour se réveiller",
              style: TextStyle(
                // fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              ),
            trailing: const Icon(Icons.chevron_right, color: Colors.black45),
            onTap: () {
              Navigator.pop(context);
              print("Alarm 2 sélectionnée");
            },
          ),

          Divider(color: Colors.grey[300], indent: 16, endIndent: 16),

          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            leading: CircleAvatar(
              backgroundColor: Colors.green.withOpacity(0.1),
              child: const FaIcon(FontAwesomeIcons.leaf, color: Colors.green),
            ),
            title: const Text(
              "Alarm 3",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            subtitle: const Text(
              "Alarme progressive avec sons naturels",
              style: TextStyle(
                // fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.black45),
            onTap: () {
              Navigator.pop(context);
              print("Alarm 3 sélectionnée");
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
