import 'package:animate_do/animate_do.dart';
import 'package:congreso_evento/modules/home/sections/widgets/count_down_timer.dart';
import 'package:flutter/material.dart';

class InicioSection extends StatefulWidget {
  // Add a ScrollController to listen for scroll events
  final ScrollController scrollController;

  const InicioSection({super.key, required this.scrollController});

  @override
  State<InicioSection> createState() => _InicioSectionState();
}

class _InicioSectionState extends State<InicioSection>
    with AutomaticKeepAliveClientMixin {
  final DateTime _targetDate = DateTime(2025, 10, 09, 8, 0, 0);

  double _backgroundOffset = 0.0; // This will control the parallax movement

  @override
  bool get wantKeepAlive => true;

  final bool inscripcionesCerradas = true;

  @override
  void initState() {
    super.initState();
    // Listen to scroll events from the parent ScrollController
    widget.scrollController.addListener(_updateParallaxOffset);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_updateParallaxOffset);
    super.dispose();
  }

  void _updateParallaxOffset() {
    final parallaxFactor = 1.0; // 0 = imagen fija
    final newOffset = widget.scrollController.offset * parallaxFactor;

    if ((newOffset - _backgroundOffset).abs() > 0.5) {
      setState(() {
        _backgroundOffset = newOffset;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return LayoutBuilder(
      builder: (context, constraints) {
        double logoWidth = isMobile ? 280 : constraints.maxWidth * 0.50;
        // if (logoWidth > 150) logoWid0th = 150;

        return Stack(
          fit: StackFit.expand,
          children: [
            // Fondo con parallax
            // White filter with opacity
            // Fondo con parallax
            Positioned.fill(
              child: Transform.translate(
                offset: Offset(
                  0,
                  _backgroundOffset,
                ), // mover en sentido inverso si querés efecto suave
                child: Image.asset(
                  'assets/imagenes/fondo/fondo_liviano.webp',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Main content (Logo, Text, CTA, Countdown, University Logos)
            Container(
              alignment: Alignment.center,
              width: size.width,
              height: size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: isMobile ? 8 : 7,
                    child: Center(
                      child: SingleChildScrollView(
                        // Kept for content overflow safety
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 20 : 40,
                          vertical: 20,
                        ),
                        child: FadeInLeft(
                          delay: const Duration(milliseconds: 300),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Container(
                                    width: 500,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Visibility(
                                          visible: !isMobile,
                                          replacement: Image.asset(
                                            'assets/imagenes/logo/logo_congreso.webp',
                                            width: logoWidth,
                                            fit: BoxFit.fitWidth,
                                          ),
                                          child: Image.asset(
                                            'assets/imagenes/logo/logo_congreso_largo.webp',
                                            width: logoWidth,
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                        Text(
                                          'Estás a un paso de vivir la medicina desde otra perspectiva\n'
                                          'Reserva tu lugar en el evento médico más esperado del año',
                                          style: TextStyle(
                                            fontSize: isMobile ? 12 : 35,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            shadows: [
                                              Shadow(
                                                offset: Offset(0, 1),
                                                blurRadius: 2,
                                                color: Colors.black.withOpacity(
                                                  0.3,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          replacement: const SizedBox(
                                            height: 20,
                                          ),
                                          visible: !isMobile,
                                          child: Image.asset(
                                            // 'assets/imagenes/logo/unisud_investigacion.png',
                                            'assets/imagenes/logo/unisud_investigacion_verde.png',
                                            width: 400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CountdownTimer(targetDate: _targetDate),
                                      const SizedBox(height: 10),

                                      Text(
                                        '📅 9, 10 y 11 de octubre de 2025',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: isMobile ? 12 : 18,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              offset: Offset(0, 1),
                                              blurRadius: 2,
                                              color: Colors.black.withOpacity(
                                                0.3,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '📍 Shopping Mall Mercosur, Saltos del Guairá, Paraguay',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: isMobile ? 12 : 18,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              offset: Offset(0, 1),
                                              blurRadius: 2,
                                              color: Colors.black.withOpacity(
                                                0.3,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 15),

                                      FadeInUp(
                                        delay: const Duration(
                                          milliseconds: 700,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: isMobile ? 20 : 50,
                                          ),
                                          child: Column(
                                            children: [
                                              // Reemplaza el SizedBox + ElevatedButton.icon por:
                                              SizedBox(
                                                width: 420,
                                                child: Tooltip(
                                                  message:
                                                      'Las inscripciones han finalizado. Te esperamos en el próximo congreso.',
                                                  child: DecoratedBox(
                                                    decoration: BoxDecoration(
                                                      gradient: LinearGradient(
                                                        begin:
                                                            Alignment.topLeft,
                                                        end: Alignment
                                                            .bottomRight,
                                                        colors: [
                                                          const Color(
                                                            0xFF9CA3AF,
                                                          ).withOpacity(
                                                            0.3,
                                                          ), // gris medio
                                                          const Color(
                                                            0xFF6B7280,
                                                          ).withOpacity(
                                                            0.3,
                                                          ), // gris oscuro
                                                        ],
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            18,
                                                          ),
                                                      border: Border.all(
                                                        color:
                                                            const Color(
                                                              0xFF73c165,
                                                            ).withOpacity(
                                                              0.65,
                                                            ), // borde verde sutil
                                                        width: 1.2,
                                                      ),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.black
                                                              .withOpacity(
                                                                0.25,
                                                              ),
                                                          blurRadius: 14,
                                                          offset: const Offset(
                                                            0,
                                                            8,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    child: Material(
                                                      color: Colors.transparent,
                                                      child: InkWell(
                                                        // Estado “finalizado”: sin acción
                                                        onTap: null,
                                                        splashColor:
                                                            Colors.white24,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.symmetric(
                                                                horizontal:
                                                                    isMobile
                                                                    ? 18
                                                                    : 24,
                                                                vertical:
                                                                    isMobile
                                                                    ? 14
                                                                    : 18,
                                                              ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .lock_clock_rounded,
                                                                color: Colors
                                                                    .white,
                                                                size: 24,
                                                              ),
                                                              const SizedBox(
                                                                width: 12,
                                                              ),
                                                              Flexible(
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Text(
                                                                      'INSCRIPCIONES FINALIZADAS',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            isMobile
                                                                            ? 16
                                                                            : 20,
                                                                        fontWeight:
                                                                            FontWeight.w800,
                                                                        letterSpacing:
                                                                            0.8,
                                                                        shadows: [
                                                                          Shadow(
                                                                            offset: const Offset(
                                                                              0,
                                                                              1,
                                                                            ),
                                                                            blurRadius:
                                                                                2,
                                                                            color: Colors.black.withOpacity(
                                                                              0.35,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              // Chip "Próximo año"
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              const SizedBox(height: 20),
                                              if (inscripcionesCerradas)
                                                Column(
                                                  children: [
                                                    Text(
                                                      '✨ Las inscripciones para el #IVCIUSMI 2025 han finalizado.',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: isMobile
                                                            ? 13
                                                            : 17,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white,
                                                        shadows: [
                                                          Shadow(
                                                            offset:
                                                                const Offset(
                                                                  0,
                                                                  1,
                                                                ),
                                                            blurRadius: 2,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                  0.3,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      '💚 Agradecemos profundamente a todos los participantes\n'
                                                      'y te invitamos a ser parte del próximo congreso el año que viene.',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: isMobile
                                                            ? 12
                                                            : 16,
                                                        color: Colors.white
                                                            .withOpacity(0.9),
                                                        height: 1.4,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      '¡Nos vemos pronto!',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: isMobile
                                                            ? 14
                                                            : 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: const Color(
                                                          0xFF73c165,
                                                        ),
                                                        shadows: [
                                                          Shadow(
                                                            offset:
                                                                const Offset(
                                                                  0,
                                                                  1,
                                                                ),
                                                            blurRadius: 2,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                  0.3,
                                                                ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        replacement: const SizedBox(height: 20),
                                        visible: isMobile,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 20,
                                          ),
                                          child: Image.asset(
                                            'assets/imagenes/logo/unisud_investigacion_verde.png',
                                            width: 140,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
