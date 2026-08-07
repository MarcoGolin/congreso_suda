import 'package:congreso_evento/core/animations/scroll_reveal.dart';
import 'package:congreso_evento/core/header_section.dart';
import 'package:congreso_evento/core/image/overlapped_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SobreSection extends StatelessWidget {
  const SobreSection({super.key});

  static const brandPrimary = Color(0xFF387f4d);
  static const brandLight = Color(0xFF73c165);
  static const ink = Color(0xFF111827);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return Container(
      width: double.infinity,
      color: Colors.white, // 👈 fondo blanco (pedido)
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 44 : 20,
        horizontal: isMobile ? 20 : 0,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 32,
            runSpacing: 40,
            children: [
              // === Texto =====================================================
              ScrollReveal(
                key: const Key('sobre-header'),
                delay: 100.ms,
                child: SizedBox(
                width: isMobile ? double.infinity : 620,
                child: Column(
                  crossAxisAlignment: isMobile
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.start,
                  children: [
                    const HeaderSection(
                      title: 'Sobre el Evento',
                      color: brandLight,
                    ),
                    const SizedBox(height: 10),

                    // Línea/indicador de marca
                    Container(
                      width: 72,
                      height: 4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: const LinearGradient(
                          colors: [brandLight, brandPrimary],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Subtítulo fuerte
                    Text(
                      'La medicina evoluciona, sé parte de la transformación.',
                      textAlign: isMobile ? TextAlign.center : TextAlign.start,
                      style: const TextStyle(
                        fontSize: 26,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                        color: ink,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Párrafos con mejor legibilidad
                    Text(
                      'El IV Congreso Internacional de la Universidad Sudamericana “Medicina Interdisciplinaria” reúne a profesionales, estudiantes y expertos para compartir conocimientos que marcan la diferencia.',
                      textAlign: isMobile
                          ? TextAlign.center
                          : TextAlign.justify,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Montserrat',
                        height: 1.65,
                        color: Colors.black.withOpacity(.82),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Durante tres días, Saltos del Guairá se convierte en el epicentro de la medicina interdisciplinaria: se construyen ideas, se desafían paradigmas y se imagina el futuro de la salud.',
                      textAlign: isMobile
                          ? TextAlign.center
                          : TextAlign.justify,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Montserrat',
                        height: 1.65,
                        color: Colors.black.withOpacity(.82),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Bullets con checks verdes
                    Wrap(
                      alignment: isMobile
                          ? WrapAlignment.center
                          : WrapAlignment.start,
                      runSpacing: 8,
                      children: const [
                        _Bullet(text: 'Charlas con referentes internacionales'),
                        _Bullet(text: 'Talleres prácticos y networking'),
                        _Bullet(
                          text:
                              'Líneas de investigación y trabajos científicos',
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    // Pills/estadísticas rápidas (opcional)
                    Wrap(
                      alignment: isMobile
                          ? WrapAlignment.center
                          : WrapAlignment.start,
                      spacing: 10,
                      runSpacing: 10,
                      children: const [
                        _StatPill(
                          title: '3 días',
                          subtitle: '9,10 y 11 oct 2025',
                        ),
                        _StatPill(title: '+20', subtitle: 'disertantes'),
                        _StatPill(title: '+900', subtitle: 'participantes'),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // // CTA (si querés mantener minimalista, podés ocultar el secundario)
                    // Wrap(
                    //   alignment: isMobile
                    //       ? WrapAlignment.center
                    //       : WrapAlignment.start,
                    //   spacing: 12,
                    //   runSpacing: 12,
                    //   children: [
                    //     _PrimaryCTA(
                    //       text: 'Conocé más',
                    //       onTap: () {
                    //         // TODO: navegar a sección "Sobre" extendida o agenda
                    //       },
                    //     ),
                    //     _GhostCTA(
                    //       text: 'Ver trabajos científicos',
                    //       onTap: () {
                    //         // TODO: navegar a sección Trabajos
                    //       },
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
              ), // fin ScrollReveal 'sobre-header'

              // === Imágenes superpuestas ====================================
              ScrollReveal(
                key: const Key('sobre-images'),
                delay: 200.ms,
                blurSigma: 0,
                child: SizedBox(
                width: isMobile ? size.width - 32 : 440,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OverlappedImages(
                      backUrl:
                          'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/fotos_evento/congreso_03.webp',
                      frontUrl:
                          'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/fotos_evento/congreso_04.webp',
                      width: isMobile ? size.width - 32 : 440,
                      aspectRatio: 4 / 3,
                      overlap: 44,
                      radius: 18,
                      isMobile: isMobile,
                    ),

                    // const SizedBox(height: 14),

                    // // Etiqueta pequeña con verde (refuerzo de marca)
                    // Container(
                    //   padding: const EdgeInsets.symmetric(
                    //     horizontal: 12,
                    //     vertical: 6,
                    //   ),
                    //   decoration: BoxDecoration(
                    //     color: const Color(
                    //       0xFFECF7EF,
                    //     ), // verde muy clarito sobre blanco
                    //     borderRadius: BorderRadius.circular(999),
                    //     border: Border.all(color: brandLight.withOpacity(.35)),
                    //   ),
                    //   child: const Text(
                    //     'Interdisciplinariedad • Innovación • Comunidad',
                    //     style: TextStyle(
                    //       fontFamily: 'Montserrat',
                    //       fontSize: 12.5,
                    //       color: brandPrimary,
                    //       fontWeight: FontWeight.w600,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              ), // fin ScrollReveal 'sobre-images'
            ],
          ),
        ),
      ),
    );
  }
}

// ================== UI helpers ==================

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.check_circle_rounded,
          size: 18,
          color: SobreSection.brandLight,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 15,
              height: 1.5,
              color: SobreSection.ink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatPill extends StatelessWidget {
  final String title;
  final String subtitle;
  const _StatPill({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FBF8), // leve verde sobre blanco
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: SobreSection.brandLight.withOpacity(.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: SobreSection.brandPrimary,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: Colors.black.withOpacity(.62),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryCTA extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _PrimaryCTA({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: SobreSection.brandPrimary,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                text,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_rounded,
                size: 18,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GhostCTA extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _GhostCTA({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: SobreSection.brandLight.withOpacity(.45),
              width: 1.1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.description_rounded,
                size: 18,
                color: SobreSection.brandPrimary.withOpacity(.9),
              ),
              const SizedBox(width: 8),
              Text(
                text,
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: Colors.black.withOpacity(.80),
                  fontWeight: FontWeight.w700,
                  fontSize: 14.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
