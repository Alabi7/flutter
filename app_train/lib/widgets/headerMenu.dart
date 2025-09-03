import 'package:flutter/material.dart';

class HeaderMenu extends StatelessWidget {
  const HeaderMenu({
    super.key,
    required this.text,
    required this.onIconPressed,
    this.icon = Icons.auto_awesome,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  final String text;
  final VoidCallback onIconPressed;
  final IconData icon;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              )),
          IconButton(
            icon: Icon(icon),
            onPressed: onIconPressed,
            tooltip: 'Action',
          ),
        ],
      ),
    );
  }
}
