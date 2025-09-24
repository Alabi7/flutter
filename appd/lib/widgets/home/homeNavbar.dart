import 'package:appd/widgets/home/newNoteRecord.dart';
import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import 'newNoteSheet.dart';


class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
        child: Row(
          children: [
            Expanded(
              child: _PillButton(
                label: 'Record',
                icon: Icons.fiber_manual_record_rounded,
                background: Colors.black,
                // background: AppColors.butonPrimary,
                foreground: Colors.white,
                onPressed: () {
                  showNewNoteRecord(context, initialIndex: 0);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _PillButton(
                label: 'New Note',
                icon: Icons.edit_outlined,
                background: AppColors.white,
                foreground: Colors.black87,
                border: const BorderSide(color: Colors.black12),
                onPressed: () {
                  showNewNoteSheet(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;
  final VoidCallback onPressed;
  final BorderSide? border;

  const _PillButton({
    required this.label,
    required this.icon,
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
            children: [
              Icon(icon, color: foreground, size: 18),
              const SizedBox(width: 8),
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
