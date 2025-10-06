import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';

import 'package:flutter/material.dart';

class OverlappedImages extends StatefulWidget {
  final String backUrl;
  final String frontUrl;
  final double width; // ancho total del bloque
  final double aspectRatio; // relación (ej. 4/3)
  final double overlap; // desplazamiento vertical del top (px)
  final double radius; // radio de borde
  final bool isMobile;

  const OverlappedImages({
    super.key,
    required this.backUrl,
    required this.frontUrl,
    required this.width,
    this.aspectRatio = 4 / 3,
    this.overlap = 40,
    this.radius = 16,
    this.isMobile = false,
  });

  @override
  State<OverlappedImages> createState() => _OverlappedImagesState();
}

enum _TopCard { back, front }

class _OverlappedImagesState extends State<OverlappedImages> {
  _TopCard _top = _TopCard.front; // por defecto, la "front" arriba
  bool _hoverBack = false;
  bool _hoverFront = false;

  static const _kAnim = Duration(milliseconds: 320);
  static const _curve = Curves.easeInOut;
  static const _accent = Color(0xFF73c165);

  @override
  Widget build(BuildContext context) {
    final height = widget.width / widget.aspectRatio;
    final cardW = widget.width * 0.78;
    final cardH = height * 0.78;

    Widget _buildBackCard() {
      final isTop = _top == _TopCard.back;
      return AnimatedPositioned(
        duration: _kAnim,
        curve: _curve,
        top: isTop ? widget.overlap : 0,
        left: isTop ? null : 0,
        right: isTop ? 0 : null,
        child: _HoverImageCard(
          url: widget.backUrl,
          width: cardW,
          height: cardH,
          radius: widget.radius,
          baseScale: isTop ? 1.02 : 0.98,
          elevation: (isTop ? (_hoverBack ? 22 : 16) : 12).toDouble(),
          isMobile: widget.isMobile,
          onHover: (v) => setState(() => _hoverBack = v),
          onTap: () {
            if (!isTop) setState(() => _top = _TopCard.back);
          },
          // Efectos de “profundidad”
          dimmed: !isTop,
          blurSigma: isTop ? 0 : 1.8,
          borderColor: isTop
              ? _accent.withOpacity(0.28)
              : Colors.black.withOpacity(0.06),
        ),
      );
    }

    Widget _buildFrontCard() {
      final isTop = _top == _TopCard.front;
      return AnimatedPositioned(
        duration: _kAnim,
        curve: _curve,
        top: isTop ? widget.overlap : 0,
        left: isTop ? null : 0,
        right: isTop ? 0 : null,
        child: _HoverImageCard(
          url: widget.frontUrl,
          width: cardW,
          height: cardH,
          radius: widget.radius,
          baseScale: isTop ? 1.02 : 0.98,
          elevation: (isTop ? (_hoverFront ? 24 : 18) : 12).toDouble(),
          isMobile: widget.isMobile,
          onHover: (v) => setState(() => _hoverFront = v),
          onTap: () {
            if (!isTop) setState(() => _top = _TopCard.front);
          },
          dimmed: !isTop,
          blurSigma: isTop ? 0 : 1.8,
          borderColor: isTop
              ? _accent.withOpacity(0.28)
              : Colors.black.withOpacity(0.06),
        ),
      );
    }

    // Z-index: renderizamos la tarjeta “top” al final
    final children = <Widget>[
      // Glow suave de marca detrás
      Positioned(
        top: height * 0.18,
        left: widget.width * 0.06,
        child: Container(
          width: widget.width * 0.68,
          height: widget.width * 0.42,
          decoration: BoxDecoration(
            color: _accent.withOpacity(0.10),
            borderRadius: BorderRadius.circular(widget.width),
            boxShadow: [
              BoxShadow(
                color: _accent.withOpacity(0.18),
                blurRadius: 60,
                spreadRadius: 10,
              ),
            ],
          ),
        ),
      ),
      if (_top == _TopCard.front) ...[
        _buildBackCard(), // abajo (izq)
        _buildFrontCard(), // arriba (der)
      ] else ...[
        _buildFrontCard(), // abajo (izq)
        _buildBackCard(), // arriba (der)
      ],
    ];

    return SizedBox(
      width: widget.width,
      height: height + widget.overlap,
      child: Stack(clipBehavior: Clip.none, children: children),
    );
  }
}

class _HoverImageCard extends StatefulWidget {
  final String url;
  final double width;
  final double height;
  final double radius;
  final double baseScale; // escala base (más grande si está arriba)
  final double elevation; // intensidad de sombra
  final bool isMobile;
  final bool dimmed; // desaturar cuando está atrás
  final double blurSigma; // blur cuando está atrás
  final Color borderColor; // borde sutil (resalta la activa)
  final ValueChanged<bool> onHover;
  final VoidCallback? onTap;

  const _HoverImageCard({
    required this.url,
    required this.width,
    required this.height,
    required this.radius,
    required this.baseScale,
    required this.elevation,
    required this.isMobile,
    required this.onHover,
    required this.dimmed,
    required this.blurSigma,
    required this.borderColor,
    this.onTap,
  });

  @override
  State<_HoverImageCard> createState() => _HoverImageCardState();
}

class _HoverImageCardState extends State<_HoverImageCard> {
  bool _hover = false;

  void _setHover(bool v) {
    if (widget.isMobile) return; // sin hover en mobile
    setState(() => _hover = v);
    widget.onHover(v);
  }

  // Matriz de saturación (s=1 normal, s=0 gris)
  List<double> _saturationMatrix(double s) {
    final inv = 1 - s;
    const r = 0.2126, g = 0.7152, b = 0.0722;
    return [
      inv * r + s,
      inv * g,
      inv * b,
      0,
      0,
      inv * r,
      inv * g + s,
      inv * b,
      0,
      0,
      inv * r,
      inv * g,
      inv * b + s,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final scale = widget.baseScale * (_hover ? 1.015 : 1.0);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          width: widget.width,
          height: widget.height,
          transform: Matrix4.identity()
            ..translate(0.0, _hover ? -3.0 : 0.0)
            ..scale(scale),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(widget.radius),
            border: Border.all(color: widget.borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: widget.elevation,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Imagen con filtros (blur + desaturación cuando está atrás)
              ColorFiltered(
                colorFilter: ColorFilter.matrix(
                  _saturationMatrix(widget.dimmed ? 0.45 : 1.0),
                ),
                child: ImageFiltered(
                  enabled: widget.blurSigma > 0,
                  imageFilter: ImageFilter.blur(
                    sigmaX: widget.blurSigma,
                    sigmaY: widget.blurSigma,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: widget.url,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 300),
                    placeholder: (context, url) =>
                        Container(color: Colors.black12),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 40,
                        color: Colors.black38,
                      ),
                    ),
                  ),
                ),
              ),

              // Overlay sutil de brillo (ligero en hover)
              IgnorePointer(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white.withOpacity(_hover ? 0.10 : 0.06),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
