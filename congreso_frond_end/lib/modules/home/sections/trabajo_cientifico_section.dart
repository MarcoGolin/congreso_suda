// Web-only
// ignore: avoid_web_libraries_in_flutter
// import 'dart:html' as html;
// // 👇 ESTE es el que necesitás (en Web):
// import 'dart:ui_web' as ui;

import 'package:animate_do/animate_do.dart';
import 'package:congreso_evento/core/header_section.dart';
import 'package:congreso_evento/core/web_helper/web_helper_stub.dart'
    if (dart.library.html) 'package:congreso_evento/core/web_helper/web_helper.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TrabajoCientificoSection extends StatelessWidget {
  const TrabajoCientificoSection({super.key});

  static const _accent = Color(0xFF73c165);

  // Coordenadas aproximadas del Shopping Mercosur
  static const double _lat = -24.054663;
  static const double _lon = -54.307983;
  static const int _zoom = 16;

  static const String _googleMapsUrl =
      'https://maps.app.goo.gl/Kjath574HRit9K5u6';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 800;

    return Container(
      width: double.infinity,
      child: Stack(
        children: [
          // Fondo
          Positioned.fill(
            child: Image.network(
              'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/fotos_evento/congreso_02.webp',
              fit: BoxFit.cover,
            ),
          ),
          // Overlay oscuro (ajustá la opacidad si querés)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(isMobile ? 0.55 : 0.70),
                    Colors.black.withOpacity(isMobile ? 0.60 : 0.75),
                  ],
                ),
              ),
            ),
          ),

          // Contenido
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 24 : 50,
              vertical: isMobile ? 40 : 50,
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
                    // Texto
                    SizedBox(
                      width: isMobile ? double.infinity : 560,
                      child: FadeInLeft(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HeaderSection(
                              title: 'Trabajos Cientificos',
                              color: Colors.white,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Presentá tu trabajo, compartí tu conocimiento y marcá la diferencia.',
                              style: TextStyle(
                                fontSize: 26,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 14),
                            Text(
                              'Modalidades habilitadas:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.45,
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
                                color: Colors.white,
                                height: 1.6,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: SizedBox(
                                width: 400,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF73c165),
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 40,
                                      vertical: 20,
                                    ),
                                    textStyle: TextStyle(
                                      fontSize: 22,
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Mapa interactivo (iframe) con tarjeta
                    SizedBox(
                      width: isMobile ? size.width - 48 : 480,
                      child: FadeInRight(
                        child: _FramedImage(
                          url:
                              'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/fotos_evento/congreso_01.webp',
                          radius: 16,
                          frameWidth: 10,
                          aspectRatio: 16 / 9,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ====== FRAMED IMAGE (Imagen con marco blanco + borde suave) ===============
class _FramedImage extends StatefulWidget {
  final String url;
  final double radius;
  final double frameWidth;
  final double aspectRatio;

  const _FramedImage({
    required this.url,
    this.radius = 16,
    this.frameWidth = 8,
    this.aspectRatio = 4 / 3,
  });

  @override
  State<_FramedImage> createState() => _FramedImageState();
}

class _FramedImageState extends State<_FramedImage> {
  double _opacity = 0.0;
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final r = widget.radius;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..translate(0.0, _hover ? -2.0 : 0.0)
          ..scale(_hover ? 1.01 : 1.0),
        decoration: BoxDecoration(
          // “marco” blanco alrededor de la imagen
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(r),
          border: Border.all(
            color: const Color(0xFFFFFFFF), // borde blanco sutil
            width: 1.0,
          ),
          boxShadow: [
            // sombra suave para que “flote”
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.12),
              blurRadius: _hover ? 18 : 14,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        padding: EdgeInsets.all(widget.frameWidth),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(r - 4),
          child: AspectRatio(
            aspectRatio: widget.aspectRatio,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(color: const Color(0xFFEAEAEA)),
                Image.network(
                  widget.url,
                  fit: BoxFit.cover, // llena sin deformar
                  loadingBuilder: (_, child, progress) {
                    if (progress == null) {
                      if (_opacity == 0) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) setState(() => _opacity = 1.0);
                        });
                      }
                      return AnimatedOpacity(
                        opacity: _opacity,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        child: child,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  errorBuilder: (_, __, ___) => const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 42,
                      color: Colors.black38,
                    ),
                  ),
                ),
                // brillo muy sutil para “calidad”
                IgnorePointer(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: const [
                          Color.fromRGBO(255, 255, 255, 0.08),
                          Color.fromRGBO(255, 255, 255, 0.00),
                        ],
                      ),
                    ),
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

class _EmbeddedMapCard extends StatefulWidget {
  final double lat;
  final double lon;
  final int zoom;
  final double radius;
  final Color accent;
  final double aspectRatio;
  final Widget? footer;

  const _EmbeddedMapCard({
    required this.lat,
    required this.lon,
    this.zoom = 16,
    this.radius = 16,
    required this.accent,
    this.aspectRatio = 16 / 9,
    this.footer,
  });

  @override
  State<_EmbeddedMapCard> createState() => _EmbeddedMapCardState();
}

class _EmbeddedMapCardState extends State<_EmbeddedMapCard> {
  late final String _viewType;

  @override
  void initState() {
    super.initState();
    _viewType = 'gmap-embed-${DateTime.now().microsecondsSinceEpoch}';

    final url =
        'https://www.google.com/maps?q=${widget.lat},${widget.lon}&z=${widget.zoom}&output=embed';
    visualizarMapa(url);
  }

  @override
  Widget build(BuildContext context) {
    final border = BorderRadius.circular(widget.radius);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: border,
        border: Border.all(color: Colors.black.withOpacity(0.06)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      padding: const EdgeInsets.all(6),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(widget.radius - 4),
            child: AspectRatio(
              aspectRatio: widget.aspectRatio,
              child: kIsWeb
                  ? HtmlElementView(viewType: _viewType)
                  : Container(
                      color: Colors.black12,
                      alignment: Alignment.center,
                      child: const Text('Mapa interactivo disponible en Web'),
                    ),
            ),
          ),
          if (widget.footer != null) ...[
            const SizedBox(height: 10),
            widget.footer!,
            const SizedBox(height: 4),
          ],
        ],
      ),
    );
  }
}

class _ActionChipBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ActionChipBtn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF73c165).withOpacity(0.18),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: const [
              Icon(Icons.map, size: 18, color: Color(0xFF2E7D32)),
              SizedBox(width: 6),
              Text(
                'Abrir en Google Maps',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
