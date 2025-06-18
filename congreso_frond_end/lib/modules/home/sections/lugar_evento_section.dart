import 'package:animate_do/animate_do.dart';
import 'package:congreso_evento/core/header_section.dart';
import 'package:flutter/material.dart';

class LugarEventoSection extends StatelessWidget {
  const LugarEventoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: isMobile ? 40 : 80,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: FadeInLeft(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,

              children: const [
                HeaderSection(title: '📍 Lugar del evento'),
                SizedBox(height: 16),
                Text(
                  'Shopping Mall Mercosur – Saltos del Guairá, Paraguay',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0C4793),
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '🛣 Fácil acceso\n'
                  '🅿 Estacionamiento disponible',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    color: Colors.black87,
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '📸 ¡Viví el evento en un espacio diseñado para inspirar!',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    color: Colors.black87,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
