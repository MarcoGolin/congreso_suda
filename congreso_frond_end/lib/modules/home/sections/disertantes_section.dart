import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:congreso_evento/core/animations/scroll_reveal.dart';
import 'package:congreso_evento/core/empty_result.dart';
import 'package:congreso_evento/core/header_section.dart';
import 'package:congreso_evento/modules/disertante/model/disertante.dart';
import 'package:congreso_evento/modules/home/widgets/flayer_ligth_box.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';

const _brandPrimary = Color(0xFF387f4d);
const _brandPrimaryLight = Color(0xFFE9F5EE);

class DisertantesCarouselSection extends StatefulWidget {
  final String titulo;
  final List<Disertante> disertantes;
  final Duration autoPlayInterval;
  final Duration pageAnimDuration;

  const DisertantesCarouselSection({
    super.key,
    required this.titulo,
    required this.disertantes,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.pageAnimDuration = const Duration(milliseconds: 260),
  });

  @override
  State<DisertantesCarouselSection> createState() =>
      _DisertantesCarouselSectionState();
}

class _DisertantesCarouselSectionState
    extends State<DisertantesCarouselSection> {
  late PageController _ctrl;
  int _current = 0;
  int _virtualPage = 0;
  double _page = 0;

  Timer? _timer;

  // Edge-scroll (solo desktop/hover)
  Timer? _edgeTimer;
  bool _hovering = false;
  double _hoverX = -1;
  double _carouselWidth = 0;
  static const double _edgeZonePx = 80;

  // NEW: control de interacción/animación
  bool _userScrolling = false; // usuario tocando/arrastrando
  bool _isAnimating = false; // animación programática en curso
  Timer? _resumeAutoplayTimer; // debounce para reanudar autoplay

  int get _startVirtualPage {
    final n = widget.disertantes.isEmpty ? 1 : widget.disertantes.length;
    return n * 100000;
  }

  double _fractionForWidth(double w) {
    if (w >= 1400) return 0.18;
    if (w >= 1200) return 0.22;
    if (w >= 992) return 0.26;
    if (w >= 768) return 0.34;
    if (w >= 560) return 0.46;
    return 0.78;
  }

  double _heightForWidth(double w) => 360;

  @override
  void initState() {
    super.initState();
    _virtualPage = _startVirtualPage;
    _ctrl = PageController(viewportFraction: 0.78, initialPage: _virtualPage)
      ..addListener(() {
        if (!_ctrl.hasClients) return;
        setState(() => _page = _ctrl.page ?? _virtualPage.toDouble());
      });
    _startAutoplay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _edgeTimer?.cancel();
    _resumeAutoplayTimer?.cancel(); // NEW
    _ctrl.dispose();
    super.dispose();
  }

  void _startAutoplay() {
    _timer?.cancel();
    if (widget.disertantes.length <= 1) return;
    _timer = Timer.periodic(widget.autoPlayInterval, (_) {
      // NEW: no auto-avanzar si hay interacción o animación en curso
      if (!mounted ||
          !_ctrl.hasClients ||
          _hovering ||
          _userScrolling ||
          _isAnimating) {
        return;
      }
      _goToVirtual(_virtualPage + 1);
    });
  }

  // NEW: helpers para pausar/reanudar autoplay
  void _pauseAutoplay() {
    _resumeAutoplayTimer?.cancel();
    _userScrolling = true;
  }

  void _resumeAutoplayDebounced([
    Duration delay = const Duration(milliseconds: 800),
  ]) {
    _resumeAutoplayTimer?.cancel();
    _resumeAutoplayTimer = Timer(delay, () {
      _userScrolling = false;
    });
  }

  // Edge-scroll (solo con mouse/hover)
  void _onHover(PointerHoverEvent e, double width) {
    _hovering = true;
    _hoverX = e.localPosition.dx.clamp(0, width);
    _carouselWidth = width;
    _maybeStartEdgeTimer();
  }

  void _onExit(_) {
    _hovering = false;
    _hoverX = -1;
    _edgeTimer?.cancel();
    _edgeTimer = null;
  }

  void _maybeStartEdgeTimer() {
    final dir = _edgeDirection();
    if (dir == 0) {
      _edgeTimer?.cancel();
      _edgeTimer = null;
      return;
    }
    if (_edgeTimer != null) return;

    Duration interval() {
      final d = dir < 0 ? _hoverX : (_carouselWidth - _hoverX);
      final t = (d / _edgeZonePx).clamp(0.0, 1.0);
      final ms = 120 + (280 * t).toInt();
      return Duration(milliseconds: ms);
    }

    _edgeTimer = Timer.periodic(interval(), (t) async {
      if (!_hovering || !_ctrl.hasClients) {
        _edgeTimer?.cancel();
        _edgeTimer = null;
        return;
      }
      final d = _edgeDirection();
      if (d == 0) {
        _edgeTimer?.cancel();
        _edgeTimer = null;
        return;
      }
      await _goToVirtual(_virtualPage + d);
      _edgeTimer?.cancel();
      _edgeTimer = null;
      _maybeStartEdgeTimer();
    });
  }

  int _edgeDirection() {
    if (!_hovering || _carouselWidth <= 0) return 0;
    if (_hoverX <= _edgeZonePx) return -1;
    if (_hoverX >= _carouselWidth - _edgeZonePx) return 1;
    return 0;
  }

  Future<void> _goToVirtual(int vPage) async {
    if (!_ctrl.hasClients) return;
    _isAnimating = true; // NEW
    _virtualPage = vPage;
    try {
      await _ctrl.animateToPage(
        _virtualPage,
        duration: widget.pageAnimDuration,
        curve: Curves.easeOutCubic,
      );
    } finally {
      _isAnimating = false; // NEW
    }
  }

  int _realIndexFromVirtual(int vIndex) {
    final n = widget.disertantes.length;
    if (n == 0) return 0;
    final m = vIndex % n;
    return m < 0 ? m + n : m;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final fraction = _fractionForWidth(c.maxWidth);
        final height = _heightForWidth(c.maxWidth);
        if (_ctrl.viewportFraction != fraction) {
          final old = _ctrl;
          _ctrl =
              PageController(
                viewportFraction: fraction,
                initialPage: _virtualPage,
              )..addListener(() {
                if (!_ctrl.hasClients || !mounted) return;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted && _ctrl.hasClients) {
                    setState(() {
                      _page = _ctrl.page ?? _virtualPage.toDouble();
                    });
                  }
                });
              });
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_ctrl.hasClients) _ctrl.jumpToPage(_virtualPage);
          });
          old.dispose();
          _startAutoplay();
        }

        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 28),
          child: Center(
            child: Column(
              children: [
                // Header + flechas
                ScrollReveal(
                  key: const Key('disertantes-header'),
                  delay: 100.ms,
                  child: Container(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeaderSection(
                        title: 'Disertantes',
                        color: brandLight,
                      ),
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
                    ],
                  ),
                ),
                ), // fin ScrollReveal 'disertantes-header'
                const SizedBox(height: 20),
                // Carrusel + edge-scroll + control de scroll del usuario
                MouseRegion(
                  onEnter: (_) => _hovering = true,
                  onExit: _onExit,
                  onHover: (e) => _onHover(e, c.maxWidth),
                  child: Listener(
                    // NEW: pausa autoplay al tocar y reanuda con debounce al soltar
                    onPointerDown: (_) => _pauseAutoplay(),
                    onPointerUp: (_) => _resumeAutoplayDebounced(),
                    onPointerCancel: (_) => _resumeAutoplayDebounced(),
                    child: NotificationListener<UserScrollNotification>(
                      onNotification: (n) {
                        if (n.direction == ScrollDirection.idle) {
                          _resumeAutoplayDebounced();
                        } else {
                          _pauseAutoplay();
                        }
                        return false;
                      },
                      child: SizedBox(
                        height: height,
                        child: PageView.builder(
                          controller: _ctrl,
                          padEnds: true, // centrado real
                          clipBehavior: Clip.none, // permite escala fuera
                          allowImplicitScrolling: true,
                          onPageChanged: (vIndex) => setState(() {
                            _virtualPage = vIndex;
                            _current = _realIndexFromVirtual(vIndex);
                            _page = vIndex.toDouble();
                          }),
                          itemBuilder: (context, vIndex) {
                            final n = widget.disertantes.length;
                            if (n == 0) return const SizedBox.shrink();
                            final i = _realIndexFromVirtual(vIndex);
                            final d = widget.disertantes[i];

                            final dist = (_page - vIndex).abs();
                            final scale = (1.10 - dist * 0.38).clamp(0.72, 1.0);
                            final opacity = (1.00 - dist * 0.65).clamp(
                              0.35,
                              1.00,
                            );
                            final isCenter = dist < 0.25;

                            return AnimatedScale(
                              scale: scale,
                              duration: const Duration(milliseconds: 180),
                              curve: Curves.easeOut,
                              child: Opacity(
                                opacity: opacity,
                                child: _HoverCard(
                                  child: _DisertanteSlide(
                                    disertante: d,
                                    height: height,
                                    heroIndex: i,
                                    highlighted: isCenter,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Dots reales
                Center(
                  child: Wrap(
                    spacing: 6,
                    children: List.generate(
                      widget.disertantes.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: _current == i ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _current == i
                              ? _brandPrimary
                              : Colors.grey.withOpacity(.4),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ---- Card con hover lift ----
class _HoverCard extends StatefulWidget {
  final Widget child;
  const _HoverCard({required this.child});

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        transform: Matrix4.identity()..translate(0.0, _hover ? -4.0 : 0.0, 0.0),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 160),
          scale: _hover ? 1.02 : 1.0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(_hover ? .12 : .05),
                  blurRadius: _hover ? 18 : 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

// ---- Slide compacto (tarjeta) ----
class _DisertanteSlide extends StatelessWidget {
  final Disertante disertante;
  final double height;
  final int heroIndex;
  final bool highlighted;

  const _DisertanteSlide({
    required this.disertante,
    required this.height,
    required this.heroIndex,
    required this.highlighted,
  });

  @override
  Widget build(BuildContext context) {
    final img = disertante.flyersPathsOrUrls.isNotEmpty
        ? disertante.flyersPathsOrUrls.first
        : null;

    return Padding(
      // simétrico para que el centro se perciba centrado
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _openLightbox(context, disertante),
          child: Container(
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: highlighted
                    ? _brandPrimary.withOpacity(.55)
                    : const Color(0xFFE5E7EB),
                width: highlighted ? 2.5 : 1,
              ),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, _brandPrimaryLight],
              ),
              boxShadow: highlighted
                  ? [
                      BoxShadow(
                        color: _brandPrimary.withOpacity(.28),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Stack(
              children: [
                if (img != null)
                  Positioned.fill(
                    child: Hero(
                      tag: 'flyer_${disertante.nombre}_$heroIndex',
                      child: CachedNetworkImage(
                        imageUrl: img,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        placeholder: (context, url) => const Center(
                          child: SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                _brandPrimary,
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => const Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),

                // Overlay
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.center,
                        colors: [
                          Colors.black.withOpacity(highlighted ? .45 : .65),
                          Colors.black.withOpacity(.06),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // CTA
                Positioned(
                  left: 12,
                  right: 12,
                  bottom: 12,
                  child: Row(
                    children: const [
                      Icon(
                        Icons.slideshow_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Ver flyers',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openLightbox(BuildContext context, Disertante d) {
    final urls = d.flyersPathsOrUrls;
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(.8),
      builder: (_) => FlyerLightbox(
        heroTag: 'flyer_${d.nombre}_$heroIndex',
        images: urls,
        title: d.nombre,
      ),
    );
  }
}
