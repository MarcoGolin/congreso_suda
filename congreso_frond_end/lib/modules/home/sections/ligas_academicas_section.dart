import 'package:animate_do/animate_do.dart';
import 'package:congreso_evento/core/header_section.dart';
import 'package:flutter/material.dart';

class LigasAcademicasSection extends StatelessWidget {
  const LigasAcademicasSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 40 : 80,
        horizontal: 24,
      ),
      width: double.infinity,
      child: FadeInUp(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 10 : 20,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HeaderSection(title: '⚕ Ligas Académicas'),
                  const SizedBox(height: 16),
                  const Text(
                    'Durante los tres días del congreso, las Ligas Académicas de la Universidad Sudamericana Sede Saltos del Guairá llevarán adelante actividades simultáneas como:',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0C4793),
                      height: 1.6,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '🔹 Simposios\n'
                    '🔹 Conferencias magistrales\n'
                    '🔹 Talleres/Workshops',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Una oportunidad única para ver en acción a los futuros líderes académicos.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '🙌🏻 Impulsando la extensión, la investigación y el liderazgo desde la formación de grado. Protagonismo estudiantil en acción.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat',
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Futuras tarjetas de ligas destacadas
                  // Wrap(
                  //   spacing: 20,
                  //   runSpacing: 20,
                  //   children: [
                  //     _LigaCard(nombre: 'Liga de Pediatría', descripcion: 'Promueve actividades clínicas y sociales.'),
                  //   ],
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
