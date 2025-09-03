import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget myCardWithListTile(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          leading: const FaIcon(FontAwesomeIcons.play, color: Colors.purpleAccent),
          title: const Text("Titre de la ligne", style: TextStyle(fontWeight: FontWeight.w600)),
          subtitle: const Text("Petite description sur une ou deux lignes."),
          trailing: const Icon(Icons.chevron_right, color: Colors.black45),
          onTap: () {
            // TODO: action au clic
          },
        ),
      ],
    ),
  );
}
