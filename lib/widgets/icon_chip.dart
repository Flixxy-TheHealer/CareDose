import 'package:flutter/material.dart';

class IconChip extends StatelessWidget {
  const IconChip({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    super.key,
  });

  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(color: backgroundColor, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor),
    );
  }
}
