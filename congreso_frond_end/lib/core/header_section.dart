import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final String title;
  final Color? color;
  const HeaderSection({super.key, required this.title, this.color});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Text(
      title,
      style: TextStyle(
        fontSize: isMobile ? 20 : 22,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}
