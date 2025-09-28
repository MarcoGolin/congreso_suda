import 'package:animate_do/animate_do.dart';
import 'package:congreso_evento/core/header_section.dart';
import 'package:congreso_evento/modules/talleres/models/taller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

const _brandPrimary = Color(0xFF387f4d);
const _brandLight = Color(0xFF73c165);

enum _Vista { tarjetas, agenda }

// Colores base (fondo claro)
const _surface = Colors.white;
const _surfaceAlt = Color(0xFFF7F9F8);
const _ink = Color(0xFF0F1411);
const _muted = Colors.black54;
const _line = Color(0xFFE6ECE8);

// Sombra suave para hover
List<BoxShadow> _hoverShadows(bool hover) => [
  if (hover)
    BoxShadow(
      color: _brandLight.withOpacity(.18),
      blurRadius: 20,
      offset: const Offset(0, 12),
    )
  else
    BoxShadow(
      color: Colors.black.withOpacity(.04),
      blurRadius: 10,
      offset: const Offset(0, 6),
    ),
];

class TallerInscripcionSection extends StatefulWidget {
  final List<Taller> talleres;

  const TallerInscripcionSection({super.key, required this.talleres});

  @override
  State<TallerInscripcionSection> createState() =>
      _TallerInscripcionSectionState();
}

class _TallerInscripcionSectionState extends State<TallerInscripcionSection>
    with TickerProviderStateMixin {
  late final DateFormat _dfDate; // Ej: "Jue 9 de Oct"
  late final DateFormat _dfTime; // Ej: "14:30"
  _Vista _vista = _Vista.tarjetas;

  @override
  void initState() {
    super.initState();
    _dfDate = DateFormat("EEE d 'de' MMM", 'es_PY');
    _dfTime = DateFormat("HH:mm", 'es_PY');
  }

  @override
  Widget build(BuildContext context) {
    if (widget.talleres.isEmpty) return const _EmptyState();

    // 1) Agrupar por día (fecha sin hora) y ordenar por horario
    final Map<DateTime, List<Taller>> porDia = _groupByDay(widget.talleres);
    final diasOrdenados = porDia.keys.toList()..sort((a, b) => a.compareTo(b));

    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 900;

    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: isMobile ? 10 : 16,
        horizontal: isMobile ? 20 : 0,
      ),
      child: FadeInUp(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const HeaderSection(title: 'Talleres', color: _brandLight),
                  const SizedBox(height: 10),

                  // Línea/indicador de marca
                  Row(
                    children: [
                      Container(
                        width: 72,
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          gradient: const LinearGradient(
                            colors: [_brandLight, _brandPrimary],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Toggle de vista
                  Row(
                    children: [
                      _VistaToggle(
                        value: _vista,
                        onChanged: (v) => setState(() => _vista = v),
                      ),
                      const Spacer(),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // 2) Tabs por día
                  DefaultTabController(
                    length: diasOrdenados.length,
                    child: Builder(
                      builder: (context) {
                        final tabCtrl = DefaultTabController.of(context);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TabBar(
                              isScrollable: true,
                              labelColor: _brandPrimary,
                              unselectedLabelColor: Colors.black54,
                              labelStyle: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                              indicator: UnderlineTabIndicator(
                                borderSide: const BorderSide(
                                  color: _brandLight,
                                  width: 3,
                                ),
                                insets: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                              ),
                              tabs: [
                                for (final d in diasOrdenados)
                                  Tab(text: _dfDate.format(d).toUpperCase()),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Contenido auto-altura (sin scroll interno)
                            AnimatedSize(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              alignment: Alignment.topCenter,
                              child: _AutoHeightTabBody(
                                controller: tabCtrl,
                                children: [
                                  for (final d in diasOrdenados)
                                    (_vista == _Vista.tarjetas)
                                        ? _GridDelDia(
                                            talleres: porDia[d]!,
                                            onTap: _showTallerSheet,
                                            dfTime: _dfTime,
                                            dense: true,
                                          )
                                        : _AgendaDelDia(
                                            talleres: porDia[d]!,
                                            dfTime: _dfTime,
                                            onTap: _showTallerSheet,
                                          ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
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

  Map<DateTime, List<Taller>> _groupByDay(List<Taller> talleres) {
    final map = <DateTime, List<Taller>>{};
    for (final t in talleres) {
      final d = DateTime(
        t.fechaHora!.year,
        t.fechaHora!.month,
        t.fechaHora!.day,
      );
      (map[d] ??= []).add(t);
    }
    // Ordenar cada día por hora
    for (final list in map.values) {
      list.sort((a, b) => a.fechaHora!.compareTo(b.fechaHora!));
    }
    return map;
  }

  void _showTallerSheet(Taller t) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final costo = _formatPrecio(t.costo ?? 0.0);
        return SafeArea(
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.9,
            minChildSize: 0.6,
            maxChildSize: 0.96,
            builder: (_, controller) {
              return Stack(
                children: [
                  // Contenido scroll
                  SingleChildScrollView(
                    controller: controller,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Flayer grande
                        _FlayerHero(url: t.flayer!, tag: 'taller_${t.id}'),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            16,
                            16,
                            16,
                            100,
                          ), // deja espacio para CTA sticky
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.titulo!,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  height: 1.1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _InfoChipRow(
                                items: [
                                  (
                                    Icons.schedule,
                                    _dfTime.format(t.fechaHora!),
                                  ),
                                  (Icons.meeting_room_outlined, t.sala!),
                                  (Icons.person_outline, t.organizador!),
                                  (Icons.payments_outlined, costo),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                t.descripcion!,
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.35,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // CTA sticky
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: const Offset(0, -3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).maybePop();

                                Modular.to.pushNamedAndRemoveUntil(
                                  '/taller_inscripcion/${t.id}',
                                  ModalRoute.withName('/'),
                                );
                              },
                              icon: const Icon(Icons.how_to_reg),
                              label: const Text('Inscribirme'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _brandPrimary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  String _formatPrecio(double value) {
    if (value <= 0.0) return 'Gratis';
    final s = value.toStringAsFixed(0);
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idx = s.length - i;
      buf.write(s[i]);
      if (idx > 1 && idx % 3 == 1) buf.write('.');
    }
    return 'Gs ${buf.toString()}';
  }
}

class _AutoHeightTabBody extends StatefulWidget {
  final TabController controller;
  final List<Widget> children;

  const _AutoHeightTabBody({required this.controller, required this.children});

  @override
  State<_AutoHeightTabBody> createState() => _AutoHeightTabBodyState();
}

class _AutoHeightTabBodyState extends State<_AutoHeightTabBody> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTabChange);
  }

  @override
  void didUpdateWidget(covariant _AutoHeightTabBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onTabChange);
      widget.controller.addListener(_onTabChange);
    }
  }

  void _onTabChange() => setState(() {}); // fuerza re-build al cambiar tab

  @override
  void dispose() {
    widget.controller.removeListener(_onTabChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final idx = widget.controller.index;
    return IndexedStack(index: idx, children: widget.children);
  }
}

/* ---------- VISTA: TARJETAS COMPACTAS POR DÍA ---------- */

class _GridDelDia extends StatelessWidget {
  final List<Taller> talleres;
  final DateFormat dfTime;
  final void Function(Taller) onTap;
  final bool dense; // <<--- NEW

  const _GridDelDia({
    required this.talleres,
    required this.dfTime,
    required this.onTap,
    this.dense = false, // <<--- NEW
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = _computeItemWidth(constraints.maxWidth);
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: dense ? 8 : 12,
            horizontal: dense ? 6 : 8,
          ),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: dense ? 8 : 12,
            runSpacing: dense ? 8 : 12,
            children: talleres.map((t) {
              return SizedBox(
                width: itemWidth,
                child: _TallerCardCompact(
                  taller: t,
                  dfTime: dfTime,
                  onTap: () => onTap(t),
                  dense: dense, // <<--- NEW
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  double _computeItemWidth(double maxWidth) {
    if (dense) {
      // Más columnas en mobile, cards mínimas
      const minW = 160.0;
      const target = 200.0;
      const maxWCard = 260.0;

      if (maxWidth <= target + 20) return (maxWidth - 20).clamp(minW, maxWCard);
      final columns = maxWidth > 1280
          ? 6
          : maxWidth > 1080
          ? 5
          : maxWidth > 860
          ? 4
          : maxWidth > 600
          ? 3
          : 2; // forzamos 2 columnas en móviles angostos
      final gutters = (columns - 1) * 8;
      final width = (maxWidth - gutters - 8) / columns;
      return width.clamp(minW, maxWCard);
    } else {
      // Config anterior (desktop/tablet)
      const minW = 220.0;
      const target = 280.0;
      const maxWCard = 330.0;

      if (maxWidth <= target + 24) return (maxWidth - 24).clamp(minW, maxWCard);
      final columns = maxWidth > 1280
          ? 5
          : maxWidth > 1080
          ? 4
          : maxWidth > 860
          ? 3
          : maxWidth > 600
          ? 2
          : 1;
      final gutters = (columns - 1) * 12;
      final width = (maxWidth - gutters - 12) / columns;
      return width.clamp(minW, maxWCard);
    }
  }
}

class _TallerCardCompact extends StatefulWidget {
  final Taller taller;
  final DateFormat dfTime;
  final VoidCallback onTap;
  final bool dense;

  const _TallerCardCompact({
    required this.taller,
    required this.dfTime,
    required this.onTap,
    this.dense = false,
  });

  @override
  State<_TallerCardCompact> createState() => _TallerCardCompactState();
}

class _TallerCardCompactState extends State<_TallerCardCompact> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.taller;
    final costo = _formatPrecio(t.costo!);

    final pad = EdgeInsets.fromLTRB(
      widget.dense ? 10 : 12,
      widget.dense ? 10 : 12,
      widget.dense ? 10 : 12,
      widget.dense ? 10 : 12,
    );
    final iconSize = widget.dense ? 12.0 : 14.0;
    final metaFs = widget.dense ? 11.5 : 12.5;
    final titleFs = widget.dense ? 13.0 : 14.5;
    final orgFs = widget.dense ? 11.0 : 12.5;

    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: _HoverCardLight(
          accented: false,
          padding: EdgeInsets.zero, // manejamos padding adentro
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Flayer con micro-zoom al hover
              Hero(
                tag: 'taller_${t.id}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
                  child: AspectRatio(
                    aspectRatio: widget.dense ? (4 / 3) : 1,
                    child: AnimatedScale(
                      scale: _hover ? 1.02 : 1.0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      child:
                          (t.flayer!.isNotEmpty &&
                              (t.flayer!.startsWith('http') || kIsWeb))
                          ? Image.network(
                              t.flayer!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const _ImageFallbackSmall(),
                              loadingBuilder: (c, w, p) =>
                                  p == null ? w : const _ImageSkeletonSmall(),
                            )
                          : const _ImageFallbackSmall(),
                    ),
                  ),
                ),
              ),

              // Contenido
              Padding(
                padding: pad,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.schedule, size: iconSize, color: _muted),
                        const SizedBox(width: 4),
                        Text(
                          widget.dfTime.format(t.fechaHora!),
                          style: TextStyle(
                            fontSize: metaFs,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.meeting_room_outlined,
                          size: iconSize,
                          color: Colors.black45,
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            t.sala!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: metaFs,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        _PriceTagMiniLight(
                          text: costo,
                          dense: widget.dense,
                          hovered: _hover,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      t.titulo!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: titleFs,
                        height: 1.12,
                        color: _ink,
                      ),
                    ),
                    if (!widget.dense) ...[
                      const SizedBox(height: 4),
                      Text(
                        t.organizador!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: orgFs, color: _muted),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatPrecio(double value) {
    if (value <= 0.0) return 'Gratis';
    final s = value.toStringAsFixed(0);
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final idx = s.length - i;
      buf.write(s[i]);
      if (idx > 1 && idx % 3 == 1) buf.write('.');
    }
    return 'Gs ${buf.toString()}';
  }
}

class _PriceTagMiniLight extends StatelessWidget {
  final String text;
  final bool dense;
  final bool hovered;
  const _PriceTagMiniLight({
    required this.text,
    this.dense = false,
    this.hovered = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = hovered ? _brandPrimary : _brandLight;
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: bg,
        shape: const StadiumBorder(),
        shadows: hovered ? _hoverShadows(true) : const [],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: dense ? 6 : 8,
          vertical: dense ? 2 : 4,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: dense ? 10.5 : 11.5,
          ),
        ),
      ),
    );
  }
}

/* ---------- VISTA: AGENDA (LISTA CRONOLÓGICA) ---------- */

class _AgendaDelDia extends StatelessWidget {
  final List<Taller> talleres;
  final DateFormat dfTime;
  final void Function(Taller) onTap;

  const _AgendaDelDia({
    required this.talleres,
    required this.dfTime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 24),
      itemCount: talleres.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final t = talleres[i];
        return InkWell(
          onTap: () => onTap(t),
          borderRadius: BorderRadius.circular(12),
          child: _HoverCardLight(
            accented: false,
            radius: BorderRadius.circular(12),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                SizedBox(
                  width: 72,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dfTime.format(t.fechaHora!),
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: const [
                          Icon(
                            Icons.meeting_room_outlined,
                            size: 14,
                            color: Colors.black45,
                          ),
                          SizedBox(width: 4),
                        ],
                      ),
                      Text(
                        t.sala!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.titulo!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15.5,
                          height: 1.12,
                          color: _ink,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        t.organizador!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => onTap(t),
                  icon: const Icon(Icons.info_outline, size: 16),
                  label: const Text('Ver'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _brandPrimary,
                    side: const BorderSide(color: _brandLight),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.w700),
                    shape: const StadiumBorder(),
                    backgroundColor: _brandLight.withOpacity(.06),
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

/* ---------- COMPONENTES AUXILIARES ---------- */
// Toggle de vista (SegmentedButton):
class _VistaToggle extends StatelessWidget {
  final _Vista value;
  final ValueChanged<_Vista> onChanged;
  const _VistaToggle({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<_Vista>(
      segments: const [
        ButtonSegment(value: _Vista.tarjetas, label: Text('Tarjetas')),
        ButtonSegment(value: _Vista.agenda, label: Text('Agenda')),
      ],
      selected: {value},
      onSelectionChanged: (set) => onChanged(set.first),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? _brandLight.withOpacity(.12)
              : _surface,
        ),
        side: WidgetStateProperty.resolveWith(
          (s) => BorderSide(
            color: s.contains(WidgetState.selected) ? _brandLight : _line,
          ),
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? _brandPrimary : _ink,
        ),
        visualDensity: VisualDensity.compact,
        shape: WidgetStateProperty.all(const StadiumBorder()),
      ),
    );
  }
}

class _PriceTagMini extends StatelessWidget {
  final String text;
  final bool dense; // <<--- NEW
  const _PriceTagMini({required this.text, this.dense = false});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: _brandLight,
        shape: StadiumBorder(),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: dense ? 6 : 8,
          vertical: dense ? 2 : 4,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: dense ? 10.5 : 11.5,
          ),
        ),
      ),
    );
  }
}

class _FlayerHero extends StatelessWidget {
  final String url;
  final String tag;
  const _FlayerHero({required this.url, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: (url.isNotEmpty && (url.startsWith('http') || kIsWeb))
            ? Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const _ImageFallback(),
                loadingBuilder: (c, w, p) =>
                    p == null ? w : const _ImageSkeleton(),
              )
            : const _ImageFallback(),
      ),
    );
  }
}

class _ImageSkeleton extends StatelessWidget {
  const _ImageSkeleton();
  @override
  Widget build(BuildContext context) => Container(
    color: Colors.black12,
    child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
  );
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();
  @override
  Widget build(BuildContext context) => Container(
    color: Colors.black12,
    child: const Center(
      child: Icon(
        Icons.image_not_supported_outlined,
        size: 40,
        color: Colors.black38,
      ),
    ),
  );
}

class _ImageSkeletonSmall extends StatelessWidget {
  const _ImageSkeletonSmall();
  @override
  Widget build(BuildContext context) => Container(
    color: Colors.black12,
    child: const Center(
      child: SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    ),
  );
}

class _ImageFallbackSmall extends StatelessWidget {
  const _ImageFallbackSmall();
  @override
  Widget build(BuildContext context) => Container(
    color: Colors.black12,
    child: const Center(
      child: Icon(
        Icons.image_not_supported_outlined,
        size: 28,
        color: Colors.black38,
      ),
    ),
  );
}

class _InfoChipRow extends StatelessWidget {
  final List<(IconData, String)> items;
  const _InfoChipRow({required this.items});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: items.map((e) {
        return Chip(
          avatar: Icon(e.$1, size: 16, color: _brandPrimary),
          label: Text(e.$2),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
          labelStyle: const TextStyle(fontSize: 12.5),
          side: const BorderSide(color: _line),
          backgroundColor: _surfaceAlt,
          shape: const StadiumBorder(),
        );
      }).toList(),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.event_busy, size: 48, color: Colors.black38),
          SizedBox(height: 12),
          Text(
            'Aún no hay talleres disponibles',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _HoverCardLight extends StatefulWidget {
  final Widget child;
  final bool accented; // para destacar o no
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry radius;

  const _HoverCardLight({
    required this.child,
    this.accented = false,
    this.padding = const EdgeInsets.all(12),
    this.radius = const BorderRadius.all(Radius.circular(14)),
  });

  @override
  State<_HoverCardLight> createState() => _HoverCardLightState();
}

class _HoverCardLightState extends State<_HoverCardLight> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final borderColor = _hover
        ? _brandLight.withOpacity(.55)
        : (widget.accented ? _brandLight.withOpacity(.35) : _line);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..translate(0.0, _hover ? -4.0 : 0.0),
        decoration: BoxDecoration(
          color: _surface,
          borderRadius: widget.radius,
          border: Border.all(
            color: borderColor,
            width: widget.accented ? 1.4 : 1.0,
          ),
          boxShadow: _hoverShadows(_hover),
          gradient: _hover
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFFFFF), Color(0xFFF9FBF9)],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFFFFF), Color(0xFFFDFEFE)],
                ),
        ),
        child: Padding(padding: widget.padding, child: widget.child),
      ),
    );
  }
}
