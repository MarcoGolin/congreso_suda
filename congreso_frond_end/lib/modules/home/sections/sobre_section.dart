import 'package:animate_do/animate_do.dart';
import 'package:congreso_evento/core/header_section.dart';
import 'package:flutter/material.dart';

class SobreSection extends StatelessWidget {
  const SobreSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 800;

    return Container(
      width: double.infinity,
      color: Colors.white, // Fondo blanco
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
                HeaderSection(title: '🧠 Sobre el Evento'),
                SizedBox(height: 16),
                Text(
                  'La medicina no se detiene. Evoluciona. Y vos podés ser parte de esta transformación.',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0C4793),
                    height: 1.6,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 16),
                Text(
                  'El IV Congreso Internacional de Medicina nace con un propósito: reunir a profesionales, estudiantes y expertos para compartir conocimientos que marcan la diferencia.',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    color: Colors.black87,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 16),
                Text(
                  'Durante tres días, Saltos del Guairá se convierte en el epicentro de la medicina interdisciplinaria.\n'
                  'Aquí se construyen ideas, se desafían paradigmas y se imagina el futuro de la salud.\n'
                  'Sumate a un evento que reúne a mentes brillantes, estudiantes apasionados y profesionales con vocación.',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    color: Colors.black87,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 32),
                HeaderSection(title: '🎯 Nuestra misión'),
                SizedBox(height: 16),
                Text(
                  'El IV CIUSMI nace con el objetivo de fortalecer la formación integral, impulsar la producción científica, '
                  'y generar un espacio donde converjan la ciencia, la docencia y la innovación médica.\n\n'
                  'Una iniciativa que ya se consolidó como uno de los eventos más esperados por la comunidad académica, '
                  'y que sigue creciendo edición tras edición.',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    color: Colors.black87,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: 32),
                HeaderSection(title: '🏅 Reconocimientos y Apoyos'),
                SizedBox(height: 16),
                Text(
                  'Aliados que fortalecen la excelencia. En breve anunciaremos el respaldo de instituciones que apoyan esta edición.',
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
                  'Las ediciones anteriores fueron declaradas de interés por:',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  '• Universidad Sudamericana\n'
                  '• Consejo Nacional de Ciencia y Tecnología - CONACYT\n'
                  '• Sociedad Científica del Paraguay\n'
                  '• Municipalidad de Saltos del Guairá\n'
                  '• Programa Nacional de Enfermedades Inmunoprevenibles y Programa Ampliado de Inmunizaciones (PNEI-PAI)\n'
                  '• Programa Nacional de Control del VIH/SIDA e ITS (PRONASIDA)\n'
                  '• INAT (Instituto Nacional de Ablación y Trasplante)\n'
                  '• Sociedad Paraguaya de Neurología (SPN)\n'
                  '• Sociedad Paraguaya de Infectología (SPI)\n'
                  '• Sociedad Paraguaya de Pediatría (SPP)\n'
                  '• Entre otros.',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    color: Colors.black87,
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  '🤝 Porque la calidad se construye en comunidad.',
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
