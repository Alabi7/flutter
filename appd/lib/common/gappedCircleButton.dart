import 'package:flutter/material.dart';

/// Bouton rond + label optionnel.
/// Conserve les anciennes options ET ajoute un anneau (ring) séparé du disque.
/// - size : diamètre du disque central
/// - circleColor : couleur du disque
/// - border : (mode legacy) fine bordure collée au disque
/// - ringWidth / ringGap / ringColor / gapColor : anneau séparé + espace
///   -> si ringWidth==0 && ringGap==0 => comportement identique à l’ancien
class GappedCircleButton extends StatelessWidget {
  const GappedCircleButton({
    super.key,
    this.size = 64,
    this.circleColor = Colors.red,
    this.border,                         // ex: BorderSide(color: Colors.blueGrey, width: 1)
    this.elevation = 0,
    this.icon,
    this.iconSize,                       // défaut = size * 0.5
    this.iconColor = Colors.black54,
    this.onTap,
    this.spacing = 5,
    this.label,                          // ex: 'Continue'
    this.labelStyle = const TextStyle(
      fontSize: 14, fontWeight: FontWeight.w300, color: Colors.grey),
    this.showLabel = false,
    this.maintainLabelSpace = true,

    // --- nouvelles options pour l’anneau séparé ---
    this.ringWidth = 0,                  // épaisseur de l’anneau (0 = désactivé)
    this.ringGap = 0,                    // espace entre anneau et disque
    this.ringColor = const Color(0xFFD9DDE3),
    this.gapColor = Colors.white,
    this.labelWidth,
    
  });

  // Disque central
  final double size;
  final Color circleColor;
  final BorderSide? border;
  final double elevation;

  // Icône
  final IconData? icon;
  final double? iconSize;
  final Color iconColor;

  // Action
  final VoidCallback? onTap;

  // Label
  final double spacing;
  final String? label;
  final TextStyle? labelStyle;
  final bool showLabel;
  final bool maintainLabelSpace;

  // Anneau séparé
  final double ringWidth;
  final double ringGap;
  final Color ringColor;
  final Color gapColor;

  final double? labelWidth; 


  bool get _useRing => ringWidth > 0 || ringGap > 0;

  @override
  Widget build(BuildContext context) {
    final _iconSize = iconSize ?? size * 0.5;
    final outer = _useRing ? size + 2 * (ringWidth + ringGap) : size;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          elevation: elevation,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: SizedBox(
              width: outer,
              height: outer,
              child: _useRing ? _buildRingButton(_iconSize) : _buildLegacyButton(_iconSize),
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







  // --- version avec anneau + gap ---
  Widget _buildRingButton(double iconSz) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        shape: CircleBorder(side: BorderSide(color: ringColor, width: ringWidth)),
      ),
      child: Padding(
        padding: EdgeInsets.all(ringWidth),
        child: DecoratedBox(
          decoration: ShapeDecoration(shape: const CircleBorder(), color: gapColor),
          child: Padding(
            padding: EdgeInsets.all(ringGap),
            child: Container(
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: icon == null ? const SizedBox.shrink()
                                  : Icon(icon, size: iconSz, color: iconColor),
            ),
          ),
        ),
      ),
    );
  }

  // --- version ancienne : cercle + petite bordure collée ---
  Widget _buildLegacyButton(double iconSz) {
    return Container(
      decoration: BoxDecoration(
        color: circleColor,
        shape: BoxShape.circle,
        border: (border != null && border != BorderSide.none)
            ? Border.all(color: border!.color, width: border!.width)
            : null,
      ),
      alignment: Alignment.center,
      child: icon == null ? const SizedBox.shrink()
                          : Icon(icon, size: iconSz, color: iconColor),
    );
  }
}


/*


// 1) Style “ancien” (sans anneau) – identique à ton widget d’avant
CircleButton(
  size: 64,
  circleColor: Colors.red,
  border: const BorderSide(color: Colors.blueGrey, width: 1),
  icon: Icons.person_outline,
  iconColor: Colors.black54,
  label: 'Continue',
  showLabel: false,
  onTap: () {},
),

// 2) Style avec anneau et écart (comme ta capture)
CircleButton(
  size: 56,                       // disque central
  ringWidth: 2,                   // épaisseur anneau
  ringGap: 6,                     // espace entre anneau et disque
  ringColor: const Color(0xFFD9DDE3),
  gapColor: Colors.white,
  circleColor: const Color(0xFFEF5A49),
  onTap: () {},
),

// 3) Avec label visible + icône blanche
CircleButton(
  size: 64,
  ringWidth: 2,
  ringGap: 4,
  circleColor: Colors.indigo,
  ringColor: const Color(0xFFE2E6ED),
  icon: Icons.pause,
  iconColor: Colors.white,
  label: 'Pause',
  showLabel: true,
  onTap: () {},
),


*/