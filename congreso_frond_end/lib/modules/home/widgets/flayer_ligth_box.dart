import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

const _brandPrimary = Color(0xFF387f4d);

class FlyerLightbox extends StatefulWidget {
  final List<String> images;
  final String title;
  final String heroTag;
  const FlyerLightbox({
    super.key,
    required this.images,
    required this.title,
    required this.heroTag,
  });

  @override
  State<FlyerLightbox> createState() => _FlyerLightboxState();
}

class _FlyerLightboxState extends State<FlyerLightbox> {
  final _ctrl = PageController();
  final TransformationController _tCtrl = TransformationController();
  int _index = 0;
  bool _zoomed = false;

  @override
  void initState() {
    super.initState();
    _tCtrl.addListener(_onTransform);
  }

  @override
  void dispose() {
    _tCtrl.removeListener(_onTransform);
    _tCtrl.dispose();
    super.dispose();
  }

  void _onTransform() {
    final s = _tCtrl.value.getMaxScaleOnAxis();
    final z = s > 1.01;
    if (z != _zoomed) setState(() => _zoomed = z);
  }

  void _resetZoom() {
    _tCtrl.value = Matrix4.identity();
    _zoomed = false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            PageView.builder(
              controller: _ctrl,
              physics: _zoomed
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
              onPageChanged: (i) {
                setState(() => _index = i);
                _resetZoom();
              },
              itemCount: widget.images.length,
              itemBuilder: (_, i) => InteractiveViewer(
                transformationController: _tCtrl,
                minScale: 1,
                maxScale: 3.0,
                panEnabled: _zoomed,
                child: Hero(
                  tag: i == 0 ? widget.heroTag : '${widget.heroTag}_$i',
                  child: CachedNetworkImage(
                    imageUrl: widget.images[i],
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(_brandPrimary),
                      ),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            if (widget.images.length > 1)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: _NavBtn(
                    icon: Icons.chevron_left,
                    onTap: () {
                      final n = widget.images.length;
                      final prev = (_index - 1 + n) % n;
                      _ctrl.animateToPage(
                        prev,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                      );
                    },
                  ),
                ),
              ),
            if (widget.images.length > 1)
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _NavBtn(
                    icon: Icons.chevron_right,
                    onTap: () {
                      final n = widget.images.length;
                      final next = (_index + 1) % n;
                      _ctrl.animateToPage(
                        next,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                      );
                    },
                  ),
                ),
              ),

            if (widget.images.length > 1)
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.images.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _index == i ? 22 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _index == i
                            ? _brandPrimary
                            : Colors.white.withOpacity(.65),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),

            Positioned(
              left: 8,
              right: 8,
              top: 8,
              child: Row(
                children: [
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withOpacity(.08),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}
