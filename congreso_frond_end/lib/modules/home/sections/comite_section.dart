import 'dart:math';

import 'package:congreso_evento/core/header_section.dart';
import 'package:congreso_evento/modules/home/model/organizadores.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _openLink(String url) async {
  final uri = Uri.tryParse(url);
  if (uri != null) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

class ComiteSection extends StatelessWidget {
  final List<Organizadores> organizadores;
  final bool isLoading;

  const ComiteSection({
    super.key,
    required this.organizadores,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF121A14);
    const brandPrimary = Color(0xFF387f4d);
    const brandLight = Color(0xFF73c165);
    final width = MediaQuery.of(context).size.width;

    final themeTitle = Theme.of(context).textTheme;
    final isMobile = width < 800;

    // Lista a mostrar (placeholder si está cargando)
    final baseItems = isLoading
        ? List<Organizadores>.generate(
            8,
            (i) =>
                Organizadores(nombre: '', cargo: '', foto: '', destacar: i < 2),
          )
        : organizadores;

    // 👉 Orden: destacados primero, manteniendo orden relativo dentro de cada grupo
    final destacados = baseItems.where((o) => o.destacar).toList();
    final normales = baseItems.where((o) => !o.destacar).toList();
    final orderedItems = [...destacados, ...normales];

    return Container(
      color: bg,
      padding: EdgeInsets.symmetric(
        vertical: 50,
        horizontal: isMobile ? 20 : 0,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              HeaderSection(title: 'Comité Organizador', color: brandLight),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 4,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF73c165), Color(0xFF387f4d)],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Personas que hacen posible el #IVCIUSMI 2025',
                      style: themeTitle.titleMedium?.copyWith(
                        color: Colors.white70,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Wrap centrado
              LayoutBuilder(
                builder: (context, constraints) {
                  double target = 260; // ancho base
                  if (constraints.maxWidth < 600) target = 300;
                  if (constraints.maxWidth < 420) target = 340;

                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1280),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        runAlignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 16,
                        runSpacing: 16,
                        children: orderedItems.map((org) {
                          final w = target + (org.destacar ? 12 : 0);
                          final h = (org.destacar ? 270 : 250).toDouble();
                          return SizedBox(
                            width: w,
                            height: h,
                            child: _OrganizerCard(
                              organizador: org,
                              destacado: org.destacar,
                              loading: isLoading || organizadores.isEmpty,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OrganizerCard extends StatefulWidget {
  final Organizadores organizador;
  final bool loading;
  final bool destacado;

  const _OrganizerCard({
    required this.organizador,
    required this.loading,
    this.destacado = false,
  });

  @override
  State<_OrganizerCard> createState() => _OrganizerCardState();
}

class _OrganizerCardState extends State<_OrganizerCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    const brandPrimary = Color(0xFF387f4d);
    const brandLight = Color(0xFF73c165);

    final borderColor = _hover
        ? brandLight.withOpacity(.55)
        : (widget.destacado ? brandLight.withOpacity(.35) : Colors.white10);

    final shadows = <BoxShadow>[
      if (_hover)
        BoxShadow(
          color: brandLight.withOpacity(.18),
          blurRadius: 20,
          offset: const Offset(0, 12),
        ),
      if (!_hover && widget.destacado)
        BoxShadow(
          color: brandLight.withOpacity(.12),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
    ];

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..translate(0.0, _hover ? -6.0 : 0.0),
        decoration: BoxDecoration(
          color: const Color(0xFF0F1711),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            width: widget.destacado ? 1.6 : 1.0,
            color: borderColor,
          ),
          boxShadow: shadows,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _hover
                ? [const Color(0xFF122017), const Color(0xFF0F1612)]
                : [const Color(0xFF111A14), const Color(0xFF0E1511)],
          ),
        ),
        padding: const EdgeInsets.all(18),
        child: _buildContent(context, brandPrimary, brandLight),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    Color brandPrimary,
    Color brandLight,
  ) {
    if (widget.loading) {
      return Column(
        children: [
          Container(
            height: 96,
            width: 96,
            decoration: const BoxDecoration(
              color: Colors.white10,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 16),
          Container(height: 16, width: 140, color: Colors.white12),
          const SizedBox(height: 8),
          Container(height: 14, width: 100, color: Colors.white10),
        ],
      );
    }

    final org = widget.organizador;

    // Avatar con halo si es destacado
    Widget avatar = _AvatarFoto(
      foto: org.foto,
      nombre: org.nombre,
      size: widget.destacado ? 104 : 96,
      heroTag: 'org-photo-${org.foto}-${org.nombre}',
      // onTap: () => _showOrganizerDialog(context, org),
    );
    if (widget.destacado) {
      avatar = Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: brandLight.withOpacity(.22),
              blurRadius: 24,
              spreadRadius: 2,
            ),
          ],
        ),
        child: avatar,
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        avatar,
        const SizedBox(height: 14),
        Text(
          org.nombre.trim(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 16,
            height: 1.2,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 6),
        Text(
          org.cargo.trim(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(.72),
            fontSize: 13,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const Spacer(),
        Container(
          margin: const EdgeInsets.only(top: 14),
          height: 3,
          width: 36,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(3),
            gradient: LinearGradient(colors: [brandLight, brandPrimary]),
          ),
        ),
      ],
    );
  }
}

void _showOrganizerDialog(BuildContext context, Organizadores org) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Cerrar',
    barrierColor: Colors.black.withOpacity(0.55),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (ctx, _, __) {
      final maxW = MediaQuery.of(ctx).size.width;
      final maxH = MediaQuery.of(ctx).size.height;

      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: maxW > 900 ? 900 : maxW - 32,
            constraints: BoxConstraints(maxHeight: maxH - 64),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0F1711),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10, width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, .25),
                  blurRadius: 24,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Imagen grande con Hero + zoom
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Container(
                        color: const Color(0xFF1B2A20),
                        child: org.foto.isNotEmpty
                            ? Hero(
                                tag: 'org-photo-${org.foto}-${org.nombre}',
                                child: InteractiveViewer(
                                  minScale: 1.0,
                                  maxScale: 4.0,
                                  child: Image.network(
                                    org.foto,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) =>
                                        _LargeFallback(
                                          initials: _initialsFromName(
                                            org.nombre,
                                          ),
                                        ),
                                  ),
                                ),
                              )
                            : _LargeFallback(
                                initials: _initialsFromName(org.nombre),
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                // Nombre y cargo
                Text(
                  org.nombre,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  org.cargo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.white.withOpacity(.75),
                  ),
                ),
                const SizedBox(height: 12),
                // Acciones
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => Navigator.of(ctx).pop(),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.white.withOpacity(.25)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                      ),
                      icon: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Cerrar',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (ctx, anim, _, child) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOut);
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: .98, end: 1.0).animate(curved),
          child: child,
        ),
      );
    },
  );
}

String _badgeFromCargo(String cargo) {
  final c = cargo.toLowerCase();
  if (c.contains('presi')) return 'Presidencia';
  if (c.contains('vice')) return 'Vicepresidencia';
  if (c.contains('director') || c.contains('dirección')) return 'Dirección';
  return 'Destacado';
}

class _BadgeChip extends StatelessWidget {
  final String label;
  const _BadgeChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF16331F),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFF73c165).withOpacity(.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 16, color: Color(0xFF73c165)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w800,
              fontSize: 11.5,
              color: Colors.white,
              letterSpacing: .2,
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarFoto extends StatelessWidget {
  final String foto;
  final String nombre;
  final String? heroTag;
  final VoidCallback? onTap;
  final double size;

  const _AvatarFoto({
    required this.foto,
    required this.nombre,
    this.heroTag,
    this.onTap,
    this.size = 96,
  });

  @override
  Widget build(BuildContext context) {
    final initials = _initialsFromName(nombre);
    final avatar = ClipOval(
      child: Container(
        height: size,
        width: size,
        color: const Color(0xFF1B2A20),
        child: (foto.isNotEmpty)
            ? Image.network(
                foto,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fallback(initials),
                loadingBuilder: (ctx, child, progress) {
                  if (progress == null) return child;
                  return _fallback(initials);
                },
              )
            : _fallback(initials),
      ),
    );

    final clickable = GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: onTap != null
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: avatar,
      ),
    );

    return (heroTag != null && heroTag!.isNotEmpty)
        ? Hero(tag: heroTag!, child: clickable)
        : clickable;
  }

  Widget _fallback(String initials) {
    return Center(
      child: Text(
        initials,
        style: const TextStyle(
          fontFamily: 'Montserrat',
          color: Colors.white70,
          fontSize: 28,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

String _initialsFromName(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty) return '—';
  String pick(String s) => s.isNotEmpty ? s.characters.first.toUpperCase() : '';
  if (parts.length == 1) return pick(parts.first);
  return (pick(parts.first) + pick(parts.last)).substring(
    0,
    min(2, (pick(parts.first) + pick(parts.last)).length),
  );
}

class _LargeFallback extends StatelessWidget {
  final String initials;
  const _LargeFallback({required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1B2A20),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            color: Colors.white70,
            fontSize: 72,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}
