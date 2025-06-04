import 'package:flutter/material.dart';

class BuildSection extends StatelessWidget {
  final Widget title;
  final Widget content;
  const BuildSection({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      padding: const EdgeInsets.all(24),
      color: const Color(0xFFF5F8FA),
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [title, content],
      ),
    );
  }
}
