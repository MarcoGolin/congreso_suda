import 'package:animate_do/animate_do.dart';
import 'package:congreso_evento/core/header_section.dart';
import 'package:flutter/material.dart';

class DisertantesSection extends StatelessWidget {
  const DisertantesSection({super.key});

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderSection(title: '👨‍⚕ Disertantes'),
                const SizedBox(height: 16),
                const Text(
                  'Mentes brillantes. Experiencias que inspiran.',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0C4793),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Los disertantes del IV CUSMI serán revelados muy pronto. Serán seleccionados por su impacto científico, su trayectoria profesional y su compromiso con la educación médica de calidad.',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    color: Colors.black87,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 16),
                const Text(
                  '👀 Próximamente: Lista oficial + agenda de temas.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                    color: Colors.black87,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 40),

                // Cards visibles cuando haya disertantes
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: [
                    // Ejemplo de card de disertante (remplazar con lista real)
                    _DisertanteCard(
                      nombre: 'Dra. Ana López',
                      especialidad: 'Pediatría',
                      tema: 'Vacunación en edad escolar',
                      imagenUrl: 'assets/images/disertante1.jpg',
                    ),
                    _DisertanteCard(
                      nombre: 'Dr. Juan Martínez',
                      especialidad: 'Neurología',
                      tema: 'Nuevas terapias para epilepsia',
                      imagenUrl: 'assets/images/disertante2.jpg',
                    ),
                    // Más disertantes...
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 🧑‍⚕ Widget card reutilizable
class _DisertanteCard extends StatelessWidget {
  final String nombre;
  final String especialidad;
  final String tema;
  final String imagenUrl;

  const _DisertanteCard({
    required this.nombre,
    required this.especialidad,
    required this.tema,
    required this.imagenUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return SizedBox(
      width: isMobile ? double.infinity : 280,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.asset(
                  imagenUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                nombre,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                especialidad,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                tema,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                  color: Colors.black87,
                  fontFamily: 'Montserrat',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
