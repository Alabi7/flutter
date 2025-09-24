import 'package:appd/common/pilluleButton.dart';
import 'package:flutter/material.dart';

Future<void> showNoConnectionDialog(
  BuildContext context, {
  VoidCallback? onRetry,
  bool barrierDismissible = false, // touche en dehors pour fermer
}) {
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (_) => const NoConnection(),
  ).then((_) {
    // Si tu veux relancer une action après fermeture via "Retry"
    if (onRetry != null) onRetry();
  });
}

class NoConnection extends StatelessWidget {
  const NoConnection({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Carré arrondi avec bord (pas un cercle)
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFF6F7FB),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade300, width: 1),
              ),
              child: const Icon(
                Icons.signal_wifi_off_rounded,
                color: Colors.black54,
                size: 28,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'No Connection',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            const Text(
              "Couldn't contact the servers. Please\ncheck your connection and try again.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Color(0xFF767980), height: 1.35),
            ),

            const SizedBox(height: 20),

            // Bouton pill plein largeur
            SizedBox(
              width: double.infinity,
              child: PillButton(
                label: 'Retry',
                background: const Color(0xFF0C1F6E), // bleu foncé
                foreground: Colors.white,
                border: BorderSide.none,
                onPressed: () {
                  Navigator.of(context).pop(); // ferme le pop-up
                  // l'action onRetry sera appelée par .then(...) de showNoConnectionDialog
                },
              ),
            ),
          ],
        ),
      ),
    );
  }





  
}
