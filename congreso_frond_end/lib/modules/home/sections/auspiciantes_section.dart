import 'package:congreso_evento/core/header_section.dart';
import 'package:congreso_evento/modules/auspiciantes/model/auspiciante.dart';
import 'package:flutter/material.dart';

class AuspiciantesCarouselSection extends StatelessWidget {
  final String titulo;
  final List<Auspiciante> sponsors;

  const AuspiciantesCarouselSection({
    super.key,
    required this.titulo,
    required this.sponsors,
  });

  @override
  Widget build(BuildContext context) {
    if (sponsors.isEmpty) {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: const Center(
          child: Text(
            'No hay auspiciantes disponibles',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ),
      );
    }

    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 900;

    // Asegurar orden (top-12 primero) y separar bandas
    final data = Auspiciante.prioritize(sponsors);
    final principales = data.where((s) => Auspiciante.isPriority(s)).toList();
    final restantes = data.where((s) => !Auspiciante.isPriority(s)).toList();

    return Container(
      constraints: const BoxConstraints(maxWidth: 1100),
      alignment: Alignment.center,
      color: Colors.white,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 44 : 64,
        horizontal: isMobile ? 20 : 40,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;

          // Tamaños responsivos
          final cols = _colsForWidth(w);
          const spacing = 7.0;
          const paddingH = 5.0;
          final itemWidth = (w - paddingH * 2 - spacing * (cols - 1)) / cols;

          final maxLogoHeight = _maxLogoHeightForWidth(w);
          final heroHeight = _heroHeightForWidth(w); // un poco más grande

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const HeaderSection(title: 'Auspiciantes', color: brandLight),
              const SizedBox(height: 10),
              Row(
                children: [
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
                ],
              ),

              // ===== Banda de PRINCIPALES (centrados, fila(s) separadas) =====
              const SizedBox(height: 20),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Wrap(
                    spacing: 14,
                    runSpacing: 14,
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: principales.map((s) {
                      return _HeroSponsorLogo(
                        url: s.url,
                        name: s.name,
                        maxHeight: 120,
                        // ancho flexible, pero acotamos para que luzcan uniformes
                        maxWidth: _heroWidthForHeight(heroHeight),
                      );
                    }).toList(),
                  ),
                ),
              ),

              // Separador suave
              const SizedBox(height: 22),
              Container(height: 1, color: const Color(0x11000000)),
              const SizedBox(height: 16),

              // ===== Grid del RESTO (como tenías, centrado) =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: paddingH),
                child: Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  alignment: WrapAlignment.center,
                  children: restantes.map((s) {
                    return SizedBox(
                      width: itemWidth,
                      child: _LogoTile(
                        url: s.url,
                        name: s.name,
                        maxHeight: maxLogoHeight,
                        isPriority: false, // resto
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  int _colsForWidth(double w) {
    if (w >= 1400) return 8;
    if (w >= 1200) return 7;
    if (w >= 992) return 6;
    if (w >= 768) return 5;
    if (w >= 560) return 4;
    return 3;
  }

  double _maxLogoHeightForWidth(double w) {
    if (w >= 1400) return 64;
    if (w >= 1200) return 60;
    if (w >= 992) return 56;
    if (w >= 768) return 52;
    if (w >= 560) return 48;
    return 44;
  }

  double _heroHeightForWidth(double w) {
    // ~20–30% más que el resto, según ancho
    if (w >= 1400) return 84;
    if (w >= 1200) return 80;
    if (w >= 992) return 76;
    if (w >= 768) return 72;
    if (w >= 560) return 64;
    return 58;
  }

  double _heroWidthForHeight(double h) {
    // Relación ancho/alto típica para logos rectangulares en contenedor
    // (no recorta la imagen; solo limita el contenedor)
    return h * 2.2; // ajustar si querés más ancho
  }
}

// ===== Tiles =====

// Héroe (PRINCIPALES): estilo “ligas académicas”, sin chip ni card.
// Fondo blanco, borde suave, sombra + hover levita; imagen contain.
class _HeroSponsorLogo extends StatefulWidget {
  final String url;
  final String name;
  final double maxHeight;
  final double maxWidth;

  const _HeroSponsorLogo({
    required this.url,
    required this.name,
    required this.maxHeight,
    required this.maxWidth,
  });

  @override
  State<_HeroSponsorLogo> createState() => _HeroSponsorLogoState();
}

class _HeroSponsorLogoState extends State<_HeroSponsorLogo> {
  bool _hover = false;
  double _opacity = 0.0;

  @override
  Widget build(BuildContext context) {
    final h = widget.maxHeight;
    final w = widget.maxWidth;

    final img = Image.network(
      widget.url,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      width: w,
      height: h,
      loadingBuilder: (_, child, progress) {
        if (progress == null) {
          if (_opacity == 0) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => _opacity = 1.0);
            });
          }
          return AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeOut,
            child: child,
          );
        }
        return const SizedBox.shrink();
      },
      errorBuilder: (_, __, ___) =>
          const Icon(Icons.broken_image, color: Colors.black26, size: 20),
    );

    final child = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      transform: Matrix4.identity()
        ..translate(0.0, _hover ? -2.0 : 0.0)
        ..scale(_hover ? 1.03 : 1.0),
      constraints: BoxConstraints(maxHeight: h, maxWidth: w),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFFFFF), width: 0.8),
        boxShadow: [
          const BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.10),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
          if (_hover)
            const BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.08),
              blurRadius: 18,
              offset: Offset(0, 10),
            ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Center(child: img),
          // brillo diagonal suave al estilo ligas
          IgnorePointer(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromRGBO(255, 255, 255, 0.10),
                    Color.fromRGBO(255, 255, 255, 0.00),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Tooltip(message: widget.name, child: child),
    );
  }
}

// Resto (tu tile actual, sin chip y sin “card look”)
class _LogoTile extends StatefulWidget {
  final String url;
  final String name;
  final double maxHeight;
  final bool isPriority;

  const _LogoTile({
    required this.url,
    required this.name,
    required this.maxHeight,
    this.isPriority = false,
  });

  @override
  State<_LogoTile> createState() => _LogoTileState();
}

class _LogoTileState extends State<_LogoTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final content = Tooltip(
      message: widget.name,
      preferBelow: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: widget.maxHeight),
        child: Center(
          child: Image.network(
            widget.url,
            fit: BoxFit.contain,
            filterQuality: FilterQuality.medium,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.image_not_supported_outlined,
              color: Colors.black38,
              size: 18,
            ),
          ),
        ),
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _hover ? Colors.black.withOpacity(.02) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: content,
      ),
    );
  }
}

// Colores (si no los tenías en este archivo)
const brandPrimary = Color(0xFF387f4d);
const brandLight = Color(0xFF73c165);
