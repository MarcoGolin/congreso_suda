import 'package:animate_do/animate_do.dart';
import 'package:congreso_evento/core/header_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TrabajosCientificosSection extends StatefulWidget {
  const TrabajosCientificosSection({super.key});

  @override
  State<TrabajosCientificosSection> createState() =>
      _TrabajosCientificosSectionState();
}

class _TrabajosCientificosSectionState
    extends State<TrabajosCientificosSection> {
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
                  HeaderSection(title: '🔬 Trabajos Científicos'),
                  SizedBox(height: 16),
                  Text(
                    'Presentá tu trabajo, compartí tu conocimiento y marcá la diferencia.',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0C4793),
                      height: 1.6,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Modalidades habilitadas:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Artículos originales de investigación\n'
                    '• Artículos de revisión bibliográfica\n'
                    '• Casos clínicos\n'
                    '• Resúmenes en modalidad póster',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    '🎖 Los mejores trabajos serán premiados en la ceremonia de cierre.\n'
                    '📩 Muy pronto estarán disponibles las bases, fechas y plantillas para el envío.',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat',
                      color: Colors.black87,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  SizedBox(height: 40),
                  FadeInUp(
                    delay: const Duration(milliseconds: 700),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 20 : 50,
                      ),
                      child: SizedBox(
                        width: 400,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0C4793),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 20 : 40,
                              vertical: isMobile ? 15 : 20,
                            ),
                            textStyle: TextStyle(
                              fontSize: isMobile ? 18 : 22,
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 10,
                          ),
                          onPressed: () {
                            Modular.to.pushNamedAndRemoveUntil(
                              '/trabajo_cientifico/',
                              ModalRoute.withName('/'),
                            );
                          },

                          child: const Text(
                            'Enviar trabajo científico',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
