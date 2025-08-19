import 'package:flutter/material.dart';

class ImageCard extends StatefulWidget {
  final String url;
  final double? radius;
  final String? semanticsLabel;

  const ImageCard({
    super.key,
    required this.url,
    this.radius = 16,
    this.semanticsLabel,
  });

  @override
  State<ImageCard> createState() => _ImageCardState();
}

class _ImageCardState extends State<ImageCard> {
  bool _hover = false;
  double _opacity = 0.0;

  @override
  Widget build(BuildContext context) {
    final border = BorderRadius.circular(widget.radius!);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: border,
          border: Border.all(color: Colors.black.withOpacity(0.06)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_hover ? 0.20 : 0.06),
              blurRadius: _hover ? 18 : 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.radius! - 4),
          child: Semantics(
            label: widget.semanticsLabel,
            child: AspectRatio(
              aspectRatio:
                  4 / 3, // ajustá si tu foto es más vertical/horizontal
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Placeholder gris suave
                  Container(color: Colors.black12),

                  // Imagen real con fade-in
                  Image.network(
                    widget.url,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) {
                        // cuando termina de cargar, hacemos fade-in
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
                        size: 40,
                        color: Colors.black38,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
