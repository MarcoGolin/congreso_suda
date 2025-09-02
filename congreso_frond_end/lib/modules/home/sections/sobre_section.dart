import 'package:congreso_evento/core/header_section.dart';
import 'package:congreso_evento/core/image/overlapped_images.dart';
import 'package:flutter/material.dart';

class SobreSection extends StatelessWidget {
  const SobreSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 800;

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 50,
        horizontal: isMobile ? 20 : 0,
      ),
      width: double.infinity,
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 32,
            runSpacing: 50,
            children: [
              // Texto
              SizedBox(
                width: isMobile ? double.infinity : 640,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    HeaderSection(title: 'Sobre el Evento'),
                    SizedBox(height: 12),
                    Text(
                      'La medicina no se detiene, evoluciona y vos podés ser parte de esta transformación.',
                      style: TextStyle(
                        fontSize: 26,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'IV Congreso Internacional de la Universidad Sudamericana “Medicina Interdisciplinaria” nace con un propósito: reunir a profesionales, estudiantes y expertos para compartir conocimientos que marcan la diferencia.',
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
                  ],
                ),
              ),

              SizedBox(
                width: isMobile ? size.width - 32 : 420,
                child: OverlappedImages(
                  backUrl:
                      'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/fotos_evento/congreso_03.webp',
                  frontUrl:
                      'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/fotos_evento/congreso_04.webp',
                  width: isMobile ? size.width - 32 : 420,
                  aspectRatio: 4 / 3,
                  overlap: 44,
                  radius: 18,
                  isMobile: isMobile,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
