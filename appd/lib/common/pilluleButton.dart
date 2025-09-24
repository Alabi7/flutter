import 'package:flutter/material.dart';

class PillButton extends StatelessWidget { // ← Enlever le _
  final String label;
  final IconData? icon; // ← Optionnel puisque tu ne l'utilises pas
  final Color background;
  final Color foreground;
  final VoidCallback onPressed;
  final BorderSide? border;

  const PillButton({
    super.key, // ← Ajouter la key
    required this.label,
    this.icon, // ← Plus requis
    required this.background,
    required this.foreground,
    required this.onPressed,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      shape: StadiumBorder(side: border ?? BorderSide.none),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // ← Pour s'adapter au contenu
            children: [
              if (icon != null) ...[
                Icon(icon, color: foreground, size: 18),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  color: foreground,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}