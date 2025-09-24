import 'package:flutter/material.dart';

/// Un bouton rond avec (optionnel) un libellé en dessous.
/// - Taille du cercle
/// - Icône + taille + couleur
/// - Couleur du cercle
/// - Bordure optionnelle
/// - Élévation
/// - Libellé + style + visibilité (avec maintien d'espace)


class CircleButton extends StatelessWidget {
  const CircleButton({
    super.key,
    this.size = 64,
    this.circleColor = Colors.red,
    this.border,                         // ex: const BorderSide(color: Colors.blueGrey, width: 1)
    this.elevation = 0,
    this.icon,
    this.iconSize,                       // par défaut: size * 0.5
    this.iconColor = Colors.black54,
    this.onTap,
    this.spacing = 5,
    this.label,                          // ex: 'Continue'
    this.labelStyle = const TextStyle(
      fontSize: 14, fontWeight: FontWeight.w300, color: Colors.grey),
    this.showLabel = false,
    this.maintainLabelSpace = true,
    this.labelWidth,
  });

  /// Diamètre du cercle
  final double size;

  /// Couleur de fond du cercle
  final Color circleColor;

  /// Bordure du cercle (mettre `BorderSide.none` pour aucune bordure)
  final BorderSide? border;

  /// Élévation Material
  final double elevation;

  /// Icône au centre (facultative)
  final IconData? icon;
  final double? iconSize;
  final Color iconColor;

  /// Action au tap
  final VoidCallback? onTap;

  /// Espace entre le cercle et le label
  final double spacing;

  /// Libellé en dessous (si null, aucun label n'est rendu)
  final String? label;
  final TextStyle? labelStyle;

  /// Afficher/masquer le label
  final bool showLabel;

  /// Conserver la place du label quand `showLabel == false`
  final bool maintainLabelSpace;
  final double? labelWidth; 

  @override
  Widget build(BuildContext context) {
    final _iconSize = iconSize ?? size * 0.5;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: circleColor,
          shape: CircleBorder(side: border ?? BorderSide.none),
          elevation: elevation,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox(
              width: size,
              height: size,
              child: icon == null
                  ? const SizedBox.shrink()
                  : Icon(icon, size: _iconSize, color: iconColor),
            ),
          ),
        ),
        SizedBox(height: spacing),
        if (label != null)
          Visibility(
            visible: showLabel,
            maintainSize: maintainLabelSpace,
            maintainAnimation: maintainLabelSpace,
            maintainState: maintainLabelSpace,
            child: SizedBox(
              width: labelWidth ?? 80, // ← Largeur fixe (par défaut 80px)
              height: 20, // ← Hauteur fixe
              child: Center( // ← Centre le texte
                child: Text(
                  label!,
                  style: labelStyle,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
      ],
    );
  }
}


















/*
Column(
  children: [
    Container(
      width: 54,
      height: 54,
      decoration: const BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      ),
    ),
    const SizedBox(height: 5),
    const Text(
      'Cancel',
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: Colors.grey,
      ),
    ),

  ],
  ),
  Column(
  children: [
    Container(
      width: 64,
      height: 64,
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
    ),
    const SizedBox(height: 5),
    const Text(
      'Done',
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: Colors.grey,
      ),
    ),
  ],
  ),

Visibility(
      visible: false, // <- mets true quand tu veux afficher "Continue"
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: const Text(
        'Continue',
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300, color: Colors.grey),
      ),


  */