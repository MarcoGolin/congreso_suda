import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final String title;
  const HeaderSection({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Text(
      title,
      style: TextStyle(
        fontSize: isMobile ? 20 : 22,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF00B2C5),
      ),
    );
  }
}
