import 'package:appa/pages/appChoiceBlocking.dart';
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
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AppChoiceBlocking(), // plus de mode
            ),
          );
        },
        child: const FaIcon(FontAwesomeIcons.plus),
      ),
    );
  }
}

