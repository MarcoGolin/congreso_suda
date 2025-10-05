import 'package:animate_do/animate_do.dart';
import 'package:congreso_evento/core/header_section.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// TODO: Reemplazar por tus enlaces reales
const String kReglamentoPdfUrl =
    'https://drive.google.com/file/d/1YJdeM4jRvI6Z0mbXmauUDEBfuMFupGXv/view';
const String kPlantillasDriveUrl =
    'https://drive.google.com/drive/folders/1Yhwk1iCk_qtF-Xf901-KE7isrIecBma2';

Future<void> _openExternal(String url) async {
  final uri = Uri.parse(url);
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

const bool kConvocatoriaCerrada = true;
// Opcional: fecha de cierre (solo informativa en el UI)
const String kFechaCierre = '29/09/2025';

class TrabajoCientificoSection extends StatelessWidget {
  const TrabajoCientificoSection({super.key});

  static const brandPrimary = Color(0xFF387f4d);
  static const brandLight = Color(0xFF73c165);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

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
          // Overlay oscuro con leve viñeta
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(isMobile ? 0.55 : 0.70),
                    Colors.black.withOpacity(isMobile ? 0.62 : 0.78),
                  ],
                ),
              ),
            ),
          ),

          // Contenido
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 24 : 50,
              vertical: isMobile ? 44 : 64,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: isMobile ? double.infinity : 1100,
                  ),
                  width: isMobile ? double.infinity : 580,
                  child: FadeInLeft(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const HeaderSection(
                          title: 'Trabajos Científicos',
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
                        const Text(
                          'Presentá tu trabajo, compartí tu conocimiento y marcá la diferencia.',
                          style: TextStyle(
                            fontSize: 26,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w700,
                            height: 1.35,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.start,
                        ),

                        const SizedBox(height: 18),

                        // ---- Modalidades habilitadas
                        const Text(
                          'Modalidades habilitadas',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.45,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            _Bullet(text: 'Artículo original de investigación'),
                            _Bullet(text: 'Artículo de revisión bibliográfica'),
                            _Bullet(text: 'Caso clínico'),
                            _Bullet(text: 'Resumen en modalidad póster'),
                          ],
                        ),

                        // CTA principal
                        Padding(
                          padding: const EdgeInsets.only(top: 22),
                          child: SizedBox(
                            width: isMobile ? double.infinity : 520,
                            child: kConvocatoriaCerrada
                                ? _ClosedCallout(fechaCierre: kFechaCierre)
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: brandLight,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 40,
                                        vertical: 18,
                                      ),
                                      textStyle: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        fontFamily: 'Montserrat',
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      elevation: 10,
                                    ),
                                    onPressed: () {
                                      // Antes navegaba al formulario:
                                      // Modular.to.pushNamedAndRemoveUntil('/trabajo_cientifico/', ModalRoute.withName('/'));
                                      // Ahora, si quisieras mantener el botón visible pero avisar:
                                      // showDialog(...) // pero ya lo ocultamos cuando está cerrada
                                    },
                                    child: const Text(
                                      'Enviar trabajo científico',
                                    ),
                                  ),
                          ),
                        ),

                        // Botones secundarios
                        const SizedBox(height: 12),
                        Wrap(
                          alignment: isMobile
                              ? WrapAlignment.center
                              : WrapAlignment.start,
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            SizedBox(
                              width: isMobile ? double.infinity : 252,
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: Colors.white.withOpacity(.75),
                                    width: 1.1,
                                  ),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 16,
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
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: isMobile ? double.infinity : 252,
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: Colors.white.withOpacity(.75),
                                    width: 1.1,
                                  ),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                    horizontal: 16,
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
                                    fontSize: 15.5,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'Montserrat',
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ClosedCallout extends StatelessWidget {
  final String? fechaCierre;
  const _ClosedCallout({this.fechaCierre});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.22)),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_clock_rounded, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Convocatoria cerrada',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                Text(
                  fechaCierre != null
                      ? 'Las postulaciones finalizaron el $fechaCierre.'
                      : 'Las postulaciones han finalizado.',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontFamily: 'Montserrat',
                    fontSize: 14.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============== helpers visuales reutilizados =================

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.check_circle_rounded,
          size: 18,
          color: TrabajoCientificoSection.brandLight,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 15,
              height: 1.5,
              color: Colors.white,
            ),
          ),
        ),
      ],
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
