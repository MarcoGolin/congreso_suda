import 'package:flutter/material.dart';

const brandPrimary = Color(0xFF387f4d); // ya lo tenés
const brandLight = Color(0xFF73c165); // ya lo tenés
const kBorder = Color(0xFFE5E7EB);
const kMuted = Color(0xFF6B7280);
const kInk = Color(0xFF111827);

class EmptyResult extends StatelessWidget {
  final String title;
  final String? subtitle;
  const EmptyResult({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 520,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: kBorder),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 36,
              color: brandPrimary.withOpacity(.8),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: kInk,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: kMuted),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
