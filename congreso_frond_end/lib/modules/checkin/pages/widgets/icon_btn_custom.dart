import 'package:flutter/material.dart';

class IconBtnCustom extends StatelessWidget {
  const IconBtnCustom({
    super.key,
    required this.icon,
    required this.onTap,
    this.tooltip,
  });
  final IconData icon;
  final VoidCallback onTap;
  final String? tooltip;
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: Ink(
        decoration: const ShapeDecoration(
          color: Colors.black54,
          shape: CircleBorder(),
        ),
        child: IconButton(
          icon: Icon(icon, color: Colors.white, size: 20),
          onPressed: onTap,
        ),
      ),
    );
  }
}
