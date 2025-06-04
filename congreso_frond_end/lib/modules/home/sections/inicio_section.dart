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

class _InicioSectionState extends State<InicioSection> {
  final DateTime _targetDate = DateTime(2025, 10, 09, 0, 0, 0);

  double _backgroundOffset = 0.0; // This will control the parallax movement

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
    final parallaxFactor = 0.3;
    final newOffset = widget.scrollController.offset * parallaxFactor;

    // Solo actualiza si el cambio es mayor a un umbral para evitar muchos rebuilds
    if ((newOffset - _backgroundOffset).abs() > 0.5) {
      setState(() {
        _backgroundOffset = newOffset;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return LayoutBuilder(
      builder: (context, constraints) {
        double logoWidth = isMobile
            ? constraints.maxWidth * 0.3
            : constraints.maxWidth * 0.15;
        if (logoWidth > 150) logoWidth = 150;

        return Stack(
          fit: StackFit.expand,
          children: [
            // Fondo con parallax
            Transform.translate(
              offset: Offset(0, _backgroundOffset),
              child: Image.asset(
                'assets/imagenes/fondo/fondo_inicio.jpg',
                fit: BoxFit.cover,
                height:
                    constraints.maxHeight +
                    100, // Para que no haya huecos al mover
                width: constraints.maxWidth,
              ),
            ),
            // White filter with opacity
            Positioned.fill(
              child: Container(color: Colors.white.withOpacity(0.2)),
            ),

            // Main content (Logo, Text, CTA, Countdown, University Logos)
            Container(
              alignment: Alignment.center,
              width: size.width,
              height: size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                        child: Flex(
                          direction: isMobile ? Axis.vertical : Axis.horizontal,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: isMobile ? 0 : 2,
                              child: FadeInLeft(
                                delay: const Duration(milliseconds: 300),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/imagenes/logo/logo_congreso_solo.png',
                                      width: logoWidth,
                                    ),
                                    const SizedBox(height: 20),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          'IV CONGRESO INTERNACIONAL\nUNIVERSIDAD SUDAMERICANA\n"MEDICINA INTERDISCIPLINARIA"',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: isMobile ? 18 : 28,
                                            fontWeight: FontWeight.w900,
                                            color: const Color(0xFF0C4793),
                                            height: 1.2,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          'Estás a un paso de vivir la medicina desde otra perspectiva\nReserva tu lugar en el evento médico más esperado del año',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: isMobile ? 12 : 18,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0,
                                      ),
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          'SALTOS DEL GUAYRÁ - PARAGUAY',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: isMobile ? 12 : 18,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
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
                                              backgroundColor: const Color(
                                                0xFF0C4793,
                                              ),
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
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              elevation: 10,
                                            ),
                                            onPressed: () {
                                              print(
                                                'Botón INSCRÍBETE AHORA presionado',
                                              );
                                            },
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
                                    const SizedBox(height: 20),
                                    CountdownTimer(targetDate: _targetDate),
                                    const SizedBox(height: 5),
                                    Text(
                                      '9, 10 y 11 de octubre de 2025',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: isMobile ? 16 : 23,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  FadeInUp(
                    delay: const Duration(milliseconds: 900),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 5, top: 5),
                      child: Wrap(
                        spacing: isMobile ? 20 : 50,
                        runSpacing: isMobile ? 20 : 50,
                        alignment: WrapAlignment.center,
                        children: [
                          Image.asset(
                            'assets/imagenes/logo/suda_logo_largo_blanco.png',
                            width: isMobile ? 140 : 200,
                          ),
                          Image.asset(
                            'assets/imagenes/logo/suda_inv_logo_largo_blanco.png',
                            width: isMobile ? 140 : 200,
                          ),
                        ],
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
