// import 'package:appa/pages/appChoiceBlocking.dart';
import 'package:appa/pages/appOverviewScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';



enum BlockingMode { now, schedule }

class SelectTypeBlocking extends StatelessWidget {
  const SelectTypeBlocking({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      
      padding: const EdgeInsets.only(top: 15, bottom: 30, left: 16, right: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        // le bottom sheet a déjà un radius, donc on peut laisser sans radius ici
      ),
      child: Column(
        
        mainAxisSize: MainAxisSize.min,
        children: [
          // petite barre en haut
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          Center(
            child: Text(
              "Select your block type", 
              style: GoogleFonts.arimo(
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),

          const SizedBox(height: 30),
          

/*
          // ligne cliquable
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            leading: const FaIcon(FontAwesomeIcons.play, color: Colors.purpleAccent),
            title: const Text("Block Now", style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text("Let's start your blocking"),
            trailing: const Icon(Icons.chevron_right, color: Colors.black45),
            onTap: () async {
              Navigator.pop(context); // ferme le sheet
              await Future.delayed(const Duration(milliseconds: 120)); // petit délai de confort
              if (!context.mounted) return;
              Navigator.of(context).push(
                MaterialPageRoute(
                  // builder: (_) => const AppChoiceBlocking(mode: BlockingMode.now),
                  builder: (_) => const AppOverviewScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 30),

          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            leading: const FaIcon(FontAwesomeIcons.calendarCheck, color: Colors.purpleAccent),
            title: const Text("Create schedule", style: TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text("e.g. work hours from 9am to 5pm"),
            trailing: const Icon(Icons.chevron_right, color: Colors.black45),
            onTap: () async {
              Navigator.pop(context); // ferme le sheet
              await Future.delayed(const Duration(milliseconds: 120));
              if (!context.mounted) return;
              Navigator.of(context).push(
                MaterialPageRoute(
                  // builder: (_) => const AppChoiceBlocking(mode: BlockingMode.schedule),
                  builder: (_) => const AppOverviewScreen(),
                ),
              );
            },
          ),



          const SizedBox(height: 20),
         
*/

        ],
      ),
    );
  }
}
