import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Dispara una animación de entrada (fade + slideY + blur) cuando el widget
/// entra al viewport. Si el usuario tiene "Reduce motion" activo, renderiza
/// el child directamente sin efectos.
///
/// Patrón:
///   1. Antes de entrar: placeholder invisible (Opacity 0) registrado en
///      VisibilityDetector.
///   2. Al entrar: monta el child animado con flutter_animate → la animación
///      arranca desde el primer frame de presencia en pantalla.
class ScrollReveal extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;

  /// Desplazamiento vertical de inicio (en px, se convierte internamente a
  /// fracción relativa al tamaño del widget).
  final double slideYPx;
  final double blurSigma;
  final double visibilityThreshold;

  const ScrollReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 600),
    this.slideYPx = 28.0,
    this.blurSigma = 5.0,
    this.visibilityThreshold = 0.12,
  });

  @override
  State<ScrollReveal> createState() => _ScrollRevealState();
}

class _ScrollRevealState extends State<ScrollReveal> {
  bool _visible = false;

  // Clave estable por instancia de State — necesaria para VisibilityDetector
  late final Key _detectorKey;

  @override
  void initState() {
    super.initState();
    _detectorKey = widget.key ?? ValueKey(hashCode);
  }

  @override
  Widget build(BuildContext context) {
    // Respeta la preferencia de accesibilidad "Reduce motion"
    if (MediaQuery.of(context).disableAnimations) {
      return widget.child;
    }

    if (_visible) {
      // Child montado → flutter_animate lo anima desde el primer frame
      return widget.child
          .animate(delay: widget.delay)
          .fadeIn(duration: widget.duration, curve: Curves.easeOutCubic)
          .slideY(
            begin: widget.slideYPx / 100,
            end: 0,
            duration: widget.duration,
            curve: Curves.easeOutCubic,
          )
          .blur(
            begin: Offset(0, widget.blurSigma),
            end: Offset.zero,
            duration: widget.duration,
            curve: Curves.easeOutCubic,
          );
    }

    // Antes de entrar al viewport: placeholder invisible para que el
    // VisibilityDetector pueda reportar el porcentaje de visibilidad.
    return VisibilityDetector(
      key: _detectorKey,
      onVisibilityChanged: (info) {
        if (!_visible && info.visibleFraction >= widget.visibilityThreshold) {
          if (mounted) setState(() => _visible = true);
        }
      },
      child: Opacity(opacity: 0, child: widget.child),
    );
  }
}
