import 'package:animate_do/animate_do.dart';
import 'package:congreso_evento/core/build_section.dart';
import 'package:congreso_evento/core/header_section.dart';
import 'package:flutter/material.dart';

class ContenidoSection extends StatelessWidget {
  const ContenidoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BuildSection(
      title: HeaderSection(title: 'Contenido'),
      content: FadeInLeft(
        child: const Text(
          '• Charlas sobre avances médicos actuales\n• Talleres prácticos con especialistas\n• Espacios de networking entre profesionales',
          style: TextStyle(fontSize: 16, color: Color(0xFF002B80)),
        ),
      ),
    );
  }
}
