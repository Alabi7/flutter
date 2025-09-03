import 'package:appa/utils/constants.dart';
import 'package:appa/widgets/buttonNewBlocking.dart';
import 'package:flutter/material.dart';
// import 'package:appa/widgets/headerMenu.dart'; // adapte l'import
import 'package:google_fonts/google_fonts.dart';
import 'package:appa/widgets/myIconButton.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/services.dart';




class AppBlockingScreen extends StatefulWidget {
  const AppBlockingScreen({super.key});

  @override
  State<AppBlockingScreen> createState() => _AppBlockingScreenState();
}

class _AppBlockingScreenState extends State<AppBlockingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: false, // force à gauche
        backgroundColor: const Color.fromARGB(147, 64, 210, 251),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: const Color.fromARGB(147, 64, 210, 251), // même couleur que l’appbar
          statusBarIconBrightness: Brightness.light, // icônes blanches
        ),
        title: 
          Text(
            "Blocking",
            style: GoogleFonts.arimo(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        actions: [ // <= ici on place ton bouton
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Myiconbutton(
              icon: Iconsax.user4,
              pressed: () {/* print("Notification cliquée !");*/ },
            ),
          ),
        ],
      ),


     body: Stack(
        children: [
          // 🔹 Contenu normal de ta page
          Center(child: Text("Contenu principal ici")),

          // 🔹 Bouton flottant superposé
          const ButtonNewBlocking()


        ],
        
      ),


    );
  }
}



















// appBar: AppHeaderBar(
//         title: 'Blocking',
//         // subtitle: 'Manage your blocking rules',
//         actionIcon: Icons.add,          // IconButton à droite
//         onAction: () {
//           // TODO: ouvrir un bottom sheet pour ajouter une règle
//           // showModalBottomSheet(...);
//         },
//       ),
//       body: const Center(child: Text('Blocking content here')),