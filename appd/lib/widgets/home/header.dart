import 'package:flutter/material.dart';
import '../../utils/colors.dart';
// import 'package:google_fonts/google_fonts.dart';

/// AppBar du home (publique pour pouvoir l'importer partout)
class HomeHeader extends StatelessWidget implements PreferredSizeWidget {
  const HomeHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    // print('Police du thème: ${Theme.of(context).textTheme.titleLarge?.fontFamily}');
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      backgroundColor: Colors.white,
      centerTitle: false,
      title: const Padding(
        padding: EdgeInsets.only(left: 4),
        child: Text(
          'Mynote AI',
          style: TextStyle(
            fontSize: 21, 
            fontWeight: FontWeight.bold, 
            color: AppColors.textPrimary,
            fontFamily: 'Roboto'
          
          ),
        ),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 8),
          child: ProBadge(onPressed: _noop),
        ),
        SizedBox(width: 6),
        Padding(
          padding: EdgeInsets.only(right: 12),
          child: UserBubble(onPressed: _noop),
        ),
      ],
    );
  }
}

// Petite fonction no-op pour l’exemple (évite d’avoir à passer une callback partout)
void _noop() {}

/// Badge PRO (tu peux le rendre privé si utilisé uniquement ici)
class ProBadge extends StatelessWidget {
  final VoidCallback onPressed;
  const ProBadge({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.textPrimary,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(18),
        child: const SizedBox(
          width: 56,
          height: 27,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_awesome, size: 14, color: AppColors.white),
              SizedBox(width: 5),
              Text(
                'PRO',
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                  fontFamily: 'Roboto'
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bulle utilisateur
class UserBubble extends StatelessWidget {
  final VoidCallback onPressed;
  const UserBubble({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      shape: const CircleBorder(
      side: BorderSide(
        color: AppColors.borderPrimary ,  // Couleur de la bordure
        width: 1.0,          // Épaisseur de la bordure
      ),
    ),
      elevation: 0,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: const SizedBox(
          width: 37,
          height: 36,
          child: Icon(Icons.person_outline, color: Colors.black54),
        ),
      ),
    );
  }
}


