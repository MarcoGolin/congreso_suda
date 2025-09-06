import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final String title;
  final Color? color;
  const HeaderSection({super.key, required this.title, this.color});

  @override
  Widget build(BuildContext context) {
    final themeTitle = Theme.of(context).textTheme;
    return Text(
      title,
      style: themeTitle.displaySmall?.copyWith(
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w800,
        color: color,
        letterSpacing: -0.5,
      ),
    );
  }
}
