import 'package:animate_do/animate_do.dart';
import 'package:congreso_evento/core/header_section.dart';
import 'package:congreso_evento/core/web_helper/web_helper_stub.dart'
    if (dart.library.html) 'package:congreso_evento/core/web_helper/web_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // para Clipboard

class LugarSection extends StatefulWidget {
  const LugarSection({super.key});

  @override
  State<LugarSection> createState() => _LugarSectionState();
}

class _LugarSectionState extends State<LugarSection>
    with AutomaticKeepAliveClientMixin {
  static const _accent = Color(0xFF73c165);

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;

    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Image.network(
              'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/fotos_evento/local_evento.webp',
              fit: BoxFit.cover,
            ),
          ),
          // Fondo: gradiente suave (menos abrupto que dos colores duros)
          Positioned.fill(
            child: Container(color: Color.fromRGBO(0, 0, 0, 0.55)),
          ),

          // Glow sutil de marca detrás de la card (da foco)
          Align(
            alignment: Alignment.center,
            child: IgnorePointer(
              child: Container(
                width: isMobile ? 380 : 520,
                height: isMobile ? 220 : 280,
                decoration: BoxDecoration(
                  color: _accent.withValues(
                    alpha: 0.08,
                  ), // si tu SDK no tiene withValues: Color.fromRGBO(115,193,101,0.08)
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(115, 193, 101, 0.22),
                      blurRadius: 90,
                      spreadRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Card centrada
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
            child: Card(
              elevation: 10,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: const BorderSide(color: Color(0xFFFFFFFF), width: 1.5),
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Container(
                  color: const Color.fromRGBO(255, 255, 255, 0.98),
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 22,
                    vertical: isMobile ? 16 : 22,
                  ),
                  child: isMobile
                      ? const _MobileLayout()
                      : const _DesktopLayout(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ====== DESKTOP LAYOUT ======================================================
class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout();

  // Coordenadas / URLs
  static const double _lat = -24.054663;
  static const double _lon = -54.307983;
  static const int _zoom = 16;
  static const String _mapsUrl = 'https://maps.app.goo.gl/Kjath574HRit9K5u6';

  static const _accent = Color(0xFF73c165);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Texto
        const Expanded(
          flex: 6,
          child: Padding(
            padding: EdgeInsets.only(right: 18),
            child: _TextBlock(),
          ),
        ),

        // Mapa
        Expanded(
          flex: 5,
          child: FadeInRight(
            child: _EmbeddedMapCard(
              lat: _lat,
              lon: _lon,
              zoom: _zoom,
              radius: 18,
              accent: _accent,
              aspectRatio: 16 / 9,
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ActionChipBtn(
                    label: 'Abrir en Google Maps',
                    icon: Icons.map_outlined,
                    onTap: () => openExternalUrl(_mapsUrl),
                  ),
                  const SizedBox(width: 8),
                  _ActionChipBtn(
                    label: 'Copiar dirección',
                    icon: Icons.content_copy,
                    onTap: () => Clipboard.setData(
                      const ClipboardData(
                        text:
                            'Shopping Mall Mercosur – Saltos del Guairá, Paraguay',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// ====== MOBILE LAYOUT =======================================================
class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  // Coordenadas / URLs
  static const double _lat = -24.054663;
  static const double _lon = -54.307983;
  static const int _zoom = 16;
  static const String _mapsUrl = 'https://maps.app.goo.gl/Kjath574HRit9K5u6';
  static const _accent = Color(0xFF73c165);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _TextBlock(),
        const SizedBox(height: 16),
        _EmbeddedMapCard(
          lat: _lat,
          lon: _lon,
          zoom: _zoom,
          radius: 16,
          accent: _accent,
          aspectRatio: 16 / 9,
          footer: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _ActionChipBtn(
                label: 'Abrir en Google Maps',
                icon: Icons.map_outlined,
                onTap: () => openExternalUrl(_mapsUrl),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// ====== TEXT BLOCK ==========================================================
class _TextBlock extends StatelessWidget {
  const _TextBlock();

  static const _accent = Color(0xFF73c165);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Eyebrow / chip “Sede”

        // Título fuerte
        const HeaderSection(title: 'Lugar del Evento', color: _accent),

        // Subrayado/acento
        Container(
          margin: const EdgeInsets.only(top: 8, bottom: 14),
          width: 64,
          height: 4,
          decoration: BoxDecoration(
            color: _accent,
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        const Text(
          'Shopping Mall Mercosur – Saltos del Guairá, Paraguay',
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          '🛣 Fácil acceso · 🅿 Estacionamiento disponible',
          style: TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
        ),
      ],
    );
  }
}

/// ====== MAP CARD ============================================================
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
    visualizarMapa(url); // <-- asegúrate de que tu helper use este viewType
  }

  @override
  Widget build(BuildContext context) {
    final border = BorderRadius.circular(widget.radius);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 0.96),
        borderRadius: border,
        border: Border.all(color: const Color.fromRGBO(0, 0, 0, 0.06)),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.18),
            blurRadius: 20,
            offset: Offset(0, 12),
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
                      color: const Color(0xFFE0E0E0),
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

/// ====== ACTION CHIP =========================================================
class _ActionChipBtn extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _ActionChipBtn({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_ActionChipBtn> createState() => _ActionChipBtnState();
}

class _ActionChipBtnState extends State<_ActionChipBtn> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Material(
        color: const Color.fromRGBO(115, 193, 101, 0.18),
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(
                  widget.icon,
                  size: 18,
                  color: _hover
                      ? const Color(0xFF1B5E20)
                      : const Color(0xFF2E7D32),
                ),
                const SizedBox(width: 6),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _hover
                        ? const Color(0xFF1B5E20)
                        : const Color(0xFF2E7D32),
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
