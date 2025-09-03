import 'package:appa/widgets/selectTypeBlocking.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ButtonNewBlocking extends StatelessWidget {
  const ButtonNewBlocking({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 30,
      bottom: 30,
      child: FloatingActionButton(
        backgroundColor: Colors.purpleAccent,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => const FractionallySizedBox(
              // heightFactor: 0.4, // 40% de la hauteur de l’écran
              child: SelectTypeBlocking(), // <-- ici on met ton widget
            ),
          );
        },
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
    );
  }
}
