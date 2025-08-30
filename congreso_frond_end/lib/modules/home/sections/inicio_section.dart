import 'package:animate_do/animate_do.dart';
import 'package:congreso_evento/modules/home/sections/widgets/count_down_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class InicioSection extends StatefulWidget {
  // Add a ScrollController to listen for scroll events
  final ScrollController scrollController;

  const InicioSection({super.key, required this.scrollController});

  @override
  State<InicioSection> createState() => _InicioSectionState();
}

class _InicioSectionState extends State<InicioSection>
    with AutomaticKeepAliveClientMixin {
  final DateTime _targetDate = DateTime(2025, 10, 09, 0, 0, 0);

  double _backgroundOffset = 0.0; // This will control the parallax movement

  @override
  bool get wantKeepAlive => true;

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
        double logoWidth = isMobile ? 300 : constraints.maxWidth * 0.50;
        // if (logoWidth > 150) logoWidth = 150;

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
                  'assets/imagenes/fondo/fondo.webp',
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
                                            'assets/imagenes/logo/logo_congreso.png',
                                            width: logoWidth,
                                            fit: BoxFit.fitWidth,
                                          ),
                                          child: Image.asset(
                                            'assets/imagenes/logo/logo_congreso_largo.png',
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
                                          child: SizedBox(
                                            width: 400,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(
                                                  0xFF387f4d,
                                                ),
                                                foregroundColor: Colors.white,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: isMobile
                                                      ? 20
                                                      : 40,
                                                  vertical: isMobile ? 15 : 20,
                                                ),
                                                textStyle: TextStyle(
                                                  fontSize: isMobile ? 18 : 22,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                elevation: 10,
                                              ),
                                              onPressed: () => Modular.to
                                                  .pushNamedAndRemoveUntil(
                                                    '/congresista/',
                                                    ModalRoute.withName('/'),
                                                  ),

                                              child: const Text(
                                                'INSCRÍBETE AHORA',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
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
