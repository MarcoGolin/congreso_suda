import 'package:animate_do/animate_do.dart';
import 'package:congreso_evento/core/header_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:url_launcher/url_launcher.dart';

// TODO: Reemplazar por tus enlaces reales
const String kReglamentoPdfUrl =
    'https://drive.google.com/file/d/1YJdeM4jRvI6Z0mbXmauUDEBfuMFupGXv/view';
const String kPlantillasDriveUrl =
    'https://drive.google.com/drive/folders/1Yhwk1iCk_qtF-Xf901-KE7isrIecBma2';

Future<void> _openExternal(String url) async {
  final uri = Uri.parse(url);
  // En Web abre nueva pestaña; en móviles usa app/navegador predeterminado
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

class TrabajoCientificoSection extends StatelessWidget {
  const TrabajoCientificoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 800;

    return SizedBox(
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
          // Overlay oscuro
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
                            const SizedBox(height: 12),
                            const Text(
                              'Presentá tu trabajo, compartí tu conocimiento y marcá la diferencia.',
                              style: TextStyle(
                                fontSize: 26,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                height: 1.5,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Modalidades habilitadas:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.45,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
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

                            // Botón principal
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: SizedBox(
                                width: 530,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF73c165),
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 40,
                                      vertical: 20,
                                    ),
                                    textStyle: const TextStyle(
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

                            // NUEVOS BOTONES SECUNDARIOS
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                SizedBox(
                                  width: isMobile ? double.infinity : 260,
                                  child: OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: Colors.white70,
                                        width: 1.2,
                                      ),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 18,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () =>
                                        _openExternal(kReglamentoPdfUrl),
                                    icon: const Icon(Icons.picture_as_pdf),
                                    label: const Text(
                                      'Reglamento',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: isMobile ? double.infinity : 260,
                                  child: OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: Colors.white70,
                                        width: 1.2,
                                      ),
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                        horizontal: 18,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () =>
                                        _openExternal(kPlantillasDriveUrl),
                                    icon: const Icon(Icons.cloud_download),
                                    label: const Text(
                                      'Modelos / Plantillas',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Imagen con marco
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
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(r),
          border: Border.all(color: const Color(0xFFFFFFFF), width: 1.0),
          boxShadow: [
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
                  fit: BoxFit.cover,
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
                IgnorePointer(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
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
