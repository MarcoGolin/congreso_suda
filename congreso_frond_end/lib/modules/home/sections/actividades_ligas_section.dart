import 'package:animate_do/animate_do.dart';
import 'package:congreso_evento/modules/home/widgets/flayer_ligth_box.dart';
import 'package:flutter/material.dart';

void _openFlyerLightbox(
  BuildContext context, {
  required String title,
  required List<String> images,
  required String heroTag,
}) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(.8),
    builder: (_) =>
        FlyerLightbox(heroTag: heroTag, images: images, title: title),
  );
}

String _heroTagForActividad(LigaActividad a) =>
    'flyer_${a.ligaAcronimo}_${a.actividad.hashCode}';

const _brandPrimary = Color(0xFF387f4d);
const _brandPrimaryLight = Color(0xFF73c165);

// Base pública de Supabase para flyers (termina SIN slash)
const _supabaseBase =
    'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public/congreso/actividades_ligas';

enum TurnoDia { juevesTarde, viernesManana, viernesTarde, sabadoTarde }

enum _Vista { porDia, general }

class LigaActividad {
  final TurnoDia turno;
  final String horario; // "14:00 – 16:00"
  final String sala; // "Sala 01" | "Sala 02" | "Sala 03"
  final String actividad; // título visible
  final List<String> disertantes;
  final String organizeShort; // acrónimo corto (ej: LANTUS)
  final String ligaAcronimo; // puede venir con sufijos (ej: LAOH-US)
  final String? flyerOverride; // si el nombre del archivo difiere

  const LigaActividad({
    required this.turno,
    required this.horario,
    required this.sala,
    required this.actividad,
    required this.disertantes,
    required this.organizeShort,
    required this.ligaAcronimo,
    this.flyerOverride,
  });

  String get flyerUrl {
    final file = (flyerOverride ?? ligaAcronimo).toUpperCase();
    return '$_supabaseBase/$file.jpg';
  }
}

class ActividadesLigasSection extends StatefulWidget {
  const ActividadesLigasSection({super.key});

  @override
  State<ActividadesLigasSection> createState() =>
      _ActividadesLigasSectionState();
}

class _ActividadesLigasSectionState extends State<ActividadesLigasSection>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  TurnoDia _turno = TurnoDia.juevesTarde;
  _Vista _vista = _Vista.porDia;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final data = _cronograma;

    final turnos = {
      TurnoDia.juevesTarde: 'JUEVES 09/OCT · TARDE',
      TurnoDia.viernesManana: 'VIERNES 10/OCT · MAÑANA',
      TurnoDia.viernesTarde: 'VIERNES 10/OCT · TARDE',
      TurnoDia.sabadoTarde: 'SÁBADO 11/OCT · TARDE',
    };

    // ===== Vista "por día" =====
    final actividadesTurno = data.where((a) => a.turno == _turno).toList()
      ..sort((a, b) {
        final h = a.horario.compareTo(b.horario);
        if (h != 0) return h;
        return a.sala.compareTo(b.sala);
      });
    final horarios = actividadesTurno.map((e) => e.horario).toSet().toList()
      ..sort();

    // ===== Vista "general" =====
    final turnosOrdenados = TurnoDia.values;
    final porTurno = {
      for (final t in turnosOrdenados)
        t: (data.where((e) => e.turno == t).toList()
          ..sort((a, b) {
            final h = a.horario.compareTo(b.horario);
            if (h != 0) return h;
            return a.sala.compareTo(b.sala);
          })),
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final _GridSetup grid = _gridFor(maxW); // columnas y ancho fijo de card

        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1180),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FadeInDown(
                    duration: const Duration(milliseconds: 260),
                    child: Text(
                      'Actividades de Ligas Académicas',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: _brandPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Selector de vista
                  FadeInDown(
                    delay: const Duration(milliseconds: 60),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _vistaChip(
                          title: 'Por día',
                          selected: _vista == _Vista.porDia,
                          onTap: () => setState(() => _vista = _Vista.porDia),
                        ),
                        _vistaChip(
                          title: 'General',
                          selected: _vista == _Vista.general,
                          onTap: () => setState(() => _vista = _Vista.general),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (_vista == _Vista.porDia) ...[
                    // Chips de turnos
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: TurnoDia.values.map((t) {
                        final selected = _turno == t;
                        return ChoiceChip(
                          checkmarkColor: Colors.white,
                          label: Text(
                            turnos[t]!,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: selected ? Colors.white : _brandPrimary,
                            ),
                          ),
                          selected: selected,
                          selectedColor: _brandPrimary,
                          backgroundColor: const Color(0xFFE9F5EE),
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: selected
                                  ? _brandPrimary
                                  : _brandPrimaryLight,
                              width: 1,
                            ),
                          ),
                          onSelected: (_) => setState(() => _turno = t),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    for (final h in horarios) ...[
                      _HorarioHeader(horario: h),
                      const SizedBox(height: 12),
                      _CardsWrapActividades(
                        actividades: actividadesTurno
                            .where((a) => a.horario == h)
                            .toList(growable: false),
                        showImage: true,
                        cardWidth: grid.cardWidth,
                        spacing: 16,
                        runSpacing: 16,
                      ),
                      const SizedBox(height: 28),
                    ],
                    if (horarios.isEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: Text(
                          'No hay actividades en este turno.',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.black54),
                        ),
                      ),
                  ],

                  // ======= Vista GENERAL (compacta, sin flyers) =======
                  if (_vista == _Vista.general) ...[
                    const SizedBox(height: 4),
                    for (final t in turnosOrdenados) ...[
                      _TurnoHeader(texto: turnos[t]!),
                      const SizedBox(height: 10),
                      for (final h
                          in (porTurno[t]!
                              .map((e) => e.horario)
                              .toSet()
                              .toList()
                            ..sort())) ...[
                        _HorarioHeader(horario: h),
                        const SizedBox(height: 8),
                        _ListaCompactaTurno(
                          actividades: porTurno[t]!
                              .where((a) => a.horario == h)
                              .toList(growable: false),
                        ),
                        const SizedBox(height: 18),
                      ],
                      const SizedBox(height: 10),
                    ],
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ChoiceChip _vistaChip({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return ChoiceChip(
      checkmarkColor: Colors.white,
      label: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: selected ? Colors.white : _brandPrimary,
        ),
      ),
      iconTheme: IconThemeData(color: selected ? Colors.white : _brandPrimary),
      selected: selected,
      selectedColor: _brandPrimary,
      backgroundColor: const Color(0xFFE9F5EE),
      shape: StadiumBorder(
        side: BorderSide(color: selected ? _brandPrimary : _brandPrimaryLight),
      ),
      onSelected: (_) => onTap(),
    );
  }
}

class _TurnoHeader extends StatelessWidget {
  final String texto;
  const _TurnoHeader({required this.texto});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 8, height: 26, color: _brandPrimary),
        const SizedBox(width: 10),
        Text(
          texto,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: _brandPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _HorarioHeader extends StatelessWidget {
  final String horario;
  const _HorarioHeader({required this.horario});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 6, height: 22, color: _brandPrimary),
        const SizedBox(width: 10),
        Text(
          horario,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: _brandPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

/* ═══════════════════════════════════════════════════════════════
   Vista GENERAL: lista compacta sin imágenes (con wraps)
   ═══════════════════════════════════════════════════════════════ */
class _ListaCompactaTurno extends StatelessWidget {
  final List<LigaActividad> actividades;
  const _ListaCompactaTurno({required this.actividades});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Material(
      color: Colors.white,
      elevation: 0,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          for (int i = 0; i < actividades.length; i++) ...[
            _CompactRow(item: actividades[i], text: text),
            if (i < actividades.length - 1)
              const Divider(height: 1, color: Color(0xFFE8EBEE)),
          ],
        ],
      ),
    );
  }
}

class _CompactRow extends StatelessWidget {
  final LigaActividad item;
  final TextTheme? text;
  const _CompactRow({required this.item, required this.text});

  @override
  Widget build(BuildContext context) {
    final nombreLiga = _fullNameLiga(item.organizeShort, item.ligaAcronimo);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SalaPill(text: item.sala),
          const SizedBox(width: 10),
          // Contenido flexible
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título actividad
                Text(
                  item.actividad,
                  style: text?.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                // Acrónimo
                Text(
                  item.organizeShort,
                  style: text?.labelMedium?.copyWith(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // Nombre largo de liga (WRAP sin límite)
                if (nombreLiga != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    nombreLiga,
                    softWrap: true,
                    style: text?.labelSmall?.copyWith(
                      color: Colors.black45,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                // Disertantes (WRAP como párrafo con puntos medios)
                if (item.disertantes.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.disertantes.join(' · '),
                    softWrap: true,
                    style: text?.labelSmall?.copyWith(color: Colors.black54),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Columna lateral: horario + acción
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.horario,
                style: text?.labelSmall?.copyWith(
                  color: _brandPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                tooltip: 'Ver flyer',
                onPressed: () => _openFlyerLightbox(
                  context,
                  title: item.actividad,
                  images: [item.flyerUrl],
                  heroTag: _heroTagForActividad(item),
                ),
                icon: const Icon(Icons.slideshow_outlined),
                color: _brandPrimary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/* ═══════════════════════════════════════════════════════════════
   Vista POR DÍA: Wrap de cards de ancho fijo (alto variable)
   ═══════════════════════════════════════════════════════════════ */
class _CardsWrapActividades extends StatelessWidget {
  final List<LigaActividad> actividades;
  final bool showImage;
  final double cardWidth;
  final double spacing;
  final double runSpacing;

  const _CardsWrapActividades({
    required this.actividades,
    required this.showImage,
    required this.cardWidth,
    this.spacing = 16,
    this.runSpacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    // Ordenar por sala
    final ordenSala = {'Sala 01': 1, 'Sala 02': 2, 'Sala 03': 3};
    final list = [...actividades]
      ..sort((a, b) {
        final ia = ordenSala[a.sala] ?? 99;
        final ib = ordenSala[b.sala] ?? 99;
        return ia.compareTo(ib);
      });

    return LayoutBuilder(
      builder: (context, constraints) {
        // Usamos Wrap para permitir alturas variables por tarjeta
        return Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.start,
          runAlignment: WrapAlignment.center,
          spacing: spacing,
          runSpacing: runSpacing,
          children: list
              .map(
                (item) => FadeInUp(
                  delay: Duration(milliseconds: 60 * (list.indexOf(item) + 1)),
                  child: SizedBox(
                    width: cardWidth, // ancho fijo, alto se adapta al contenido
                    child: _ActividadCard(item: item, showImage: showImage),
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _ActividadCard extends StatelessWidget {
  final LigaActividad item;
  final bool showImage;
  const _ActividadCard({required this.item, required this.showImage});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final nombreLiga = _fullNameLiga(item.organizeShort, item.ligaAcronimo);

    const double _thumbW = 110; // ancho fijo para flyer
    const double _thumbRatio = 3 / 4;

    return Material(
      color: Colors.white,
      elevation: 1.5,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openFlyerLightbox(
          context,
          title: item.actividad,
          images: [item.flyerUrl],
          heroTag: _heroTagForActividad(item),
        ),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE8EBEE)),
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumb del flyer (solo en vista por día)
              if (showImage) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: _thumbW,
                    child: AspectRatio(
                      aspectRatio: _thumbRatio,
                      child: Image.network(
                        item.flyerUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFFF4F6F8),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.black38,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
              ],

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fila superior: sala + horario alineado a la derecha
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SalaPill(text: item.sala),
                        const Spacer(),
                        Text(
                          item.horario,
                          style: text.labelSmall?.copyWith(
                            color: _brandPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),
                    // Acrónimo en gris
                    Text(
                      item.organizeShort,
                      style: text.labelMedium?.copyWith(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    // Nombre largo de la liga (WRAP, sin maxLines)
                    if (nombreLiga != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        nombreLiga,
                        softWrap: true,
                        style: text.labelSmall?.copyWith(
                          color: Colors.black45,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],

                    const SizedBox(height: 8),
                    // Título de la actividad
                    Text(
                      item.actividad,
                      softWrap: true,
                      style: text.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Disertantes: chips sin scroll, se rompen en múltiples líneas
                    _DisertantesChips(disertantes: item.disertantes),

                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: () => _openFlyerLightbox(
                        context,
                        title: item.actividad,
                        images: [item.flyerUrl],
                        heroTag: _heroTagForActividad(item),
                      ),
                      icon: const Icon(Icons.open_in_new),
                      label: const Text('Ver flyer'),
                      style: TextButton.styleFrom(
                        foregroundColor: _brandPrimary,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        minimumSize: const Size(0, 36),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SalaPill extends StatelessWidget {
  final String text;
  const _SalaPill({required this.text});

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F5EE),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _brandPrimaryLight),
      ),
      child: Text(
        text,
        style: t.labelMedium?.copyWith(
          color: _brandPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// Chips sin scroll: el contenedor crece según contenido
class _DisertantesChips extends StatelessWidget {
  final List<String> disertantes;
  const _DisertantesChips({required this.disertantes});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    if (disertantes.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: 6,
      runSpacing: 2,
      children: disertantes
          .map(
            (d) => Chip(
              label: Text(d, style: text.labelSmall),
              side: const BorderSide(color: Color(0xFFE0E6EA)),
              backgroundColor: const Color(0xFFF8FAFB),
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          )
          .toList(),
    );
  }
}

/* ═══════════════════════════════════════════════════════════════
   Utilidades: nombres largos de ligas
   ═══════════════════════════════════════════════════════════════ */
final Map<String, String> _ligaNombres = {
  'LACIS':
      'Liga Académica de Cirugía de la Universidad Sudamericana, sede Saltos del Guairá (LACIS-SDG)',
  'LACIS-SDG':
      'Liga Académica de Cirugía de la Universidad Sudamericana, sede Saltos del Guairá (LACIS-SDG)',
  'LACARDIUS':
      'Liga Académica de Cardiología de la Universidad Sudamericana sede Saltos del Guairá (LACARDIUS-SDG)',
  'LACARDIUS-SDG':
      'Liga Académica de Cardiología de la Universidad Sudamericana sede Saltos del Guairá (LACARDIUS-SDG)',
  'LAGOUS':
      'Liga Académica de Ginecología de la Universidad Sudamericana sede Saltos del Guairá (LAGOUS-SDG)',
  'LAGOUS-SDG':
      'Liga Académica de Ginecología de la Universidad Sudamericana sede Saltos del Guairá (LAGOUS-SDG)',
  'LADERMUS':
      'Liga Académica de Dermatología de la Universidad Sudamericana sede Saltos del Guairá (LADERMUS-SDG)',
  'LADERMUS-SDG':
      'Liga Académica de Dermatología de la Universidad Sudamericana sede Saltos del Guairá (LADERMUS-SDG)',
  'LIGAME':
      'Liga Académica de Metabología y Endocrinología de la Universidad Sudamericana sede Saltos del Guairá (LIGAME-SDG)',
  'LIGAME-SDG':
      'Liga Académica de Metabología y Endocrinología de la Universidad Sudamericana sede Saltos del Guairá (LIGAME-SDG)',
  'LAEME':
      'Liga Académica de Medicina de Emergencia de la Universidad Sudamericana sede Saltos del Guairá (LAEME-SDG)',
  'LAEME-SDG':
      'Liga Académica de Medicina de Emergencia de la Universidad Sudamericana sede Saltos del Guairá (LAEME-SDG)',
  'LAPED':
      'Liga Académica de Pediatría de la Universidad Sudamericana sede Saltos del Guairá (LAPED-US-SDG)',
  'LAPED-US-SDG':
      'Liga Académica de Pediatría de la Universidad Sudamericana sede Saltos del Guairá (LAPED-US-SDG)',
  'LACMUS':
      'Liga Académica de Clínica Médica de la Universidad Sudamericana sede Saltos del Guairá (LACMUS-SDG)',
  'LACMUS-SDG':
      'Liga Académica de Clínica Médica de la Universidad Sudamericana sede Saltos del Guairá (LACMUS-SDG)',
  'LANEURUS':
      'Liga Académica de Neurología de la Universidad Sudamericana sede Saltos del Guairá (LANEURUS-SDG)',
  'LANEURUS-SDG':
      'Liga Académica de Neurología de la Universidad Sudamericana sede Saltos del Guairá (LANEURUS-SDG)',
  'LANTUS':
      'Liga Académica de Neumología y Tisiología de la Universidad Sudamericana sede Saltos del Guairá (LANTUS-SDG)',
  'LANTUS-SDG':
      'Liga Académica de Neumología y Tisiología de la Universidad Sudamericana sede Saltos del Guairá (LANTUS-SDG)',
  'LAPSUS':
      'Liga Académica de Psiquiatría de la Universidad Sudamericana sede Saltos del Guairá (LAPSUSS-SDG)',
  'LAPSUSS':
      'Liga Académica de Psiquiatría de la Universidad Sudamericana sede Saltos del Guairá (LAPSUSS-SDG)',
  'LAPSUSS-SDG':
      'Liga Académica de Psiquiatría de la Universidad Sudamericana sede Saltos del Guairá (LAPSUSS-SDG)',
  'LAETUS':
      'Liga Académica de Emergencia de Trauma de la Universidad Sudamericana sede Saltos del Guairá (LAETUS-SDG)',
  'LAETUS-SDG':
      'Liga Académica de Emergencia de Trauma de la Universidad Sudamericana sede Saltos del Guairá (LAETUS-SDG)',
  'LADAUS':
      'Liga Académica de Anatomía Humana de la Universidad Sudamericana sede Saltos del Guairá (LADAUS-SDG)',
  'LADAUS-SDG':
      'Liga Académica de Anatomía Humana de la Universidad Sudamericana sede Saltos del Guairá (LADAUS-SDG)',
  'LADTOUS':
      'Liga Académica de Donación y Trasplante de Órganos de la Universidad Sudamericana sede Saltos del Guairá (LADTOUS-SDG)',
  'LADTOUS-SDG':
      'Liga Académica de Donación y Trasplante de Órganos de la Universidad Sudamericana sede Saltos del Guairá (LADTOUS-SDG)',
  'LAMICROUS':
      'Liga Académica de Microbiología y Parasitología Clínica de la Universidad Sudamericana sede Saltos del Guairá (LAMICROUS-SDG)',
  'LAMICROUS-SDG':
      'Liga Académica de Microbiología y Parasitología Clínica de la Universidad Sudamericana sede Saltos del Guairá (LAMICROUS-SDG)',
  'LAIIUS':
      'Liga Académica de Infectología e Inmunología de la Universidad Sudamericana sede Saltos del Guairá (LAIIUS-SDG)',
  'LAIIUS-SDG':
      'Liga Académica de Infectología e Inmunología de la Universidad Sudamericana sede Saltos del Guairá (LAIIUS-SDG)',
  'LAOH':
      'Liga Académica de Oncología y Hematología de la Universidad Sudamericana sede Saltos del Guairá (LAOH-US-SDG)',
  'LAOH-US':
      'Liga Académica de Oncología y Hematología de la Universidad Sudamericana sede Saltos del Guairá (LAOH-US-SDG)',
  'LAOH-US-SDG':
      'Liga Académica de Oncología y Hematología de la Universidad Sudamericana sede Saltos del Guairá (LAOH-US-SDG)',
  'LAFISIO':
      'Liga Académica de Fisiología y Fisiopatología de la Universidad Sudamericana, sede Saltos del Guairá (LAFISIO-US-SDG)',
  'LAFISIO-US-SDG':
      'Liga Académica de Fisiología y Fisiopatología de la Universidad Sudamericana, sede Saltos del Guairá (LAFISIO-US-SDG)',
  'LAOT':
      'Liga Académica de Ortopedia y Traumatología de la Universidad Sudamericana, sede Saltos del Guairá (LAOT-US-SDG)',
  'LAOT-US':
      'Liga Académica de Ortopedia y Traumatología de la Universidad Sudamericana, sede Saltos del Guairá (LAOT-US-SDG)',
  'LAOT-US-SDG':
      'Liga Académica de Ortopedia y Traumatología de la Universidad Sudamericana, sede Saltos del Guairá (LAOT-US-SDG)',
  'NUTRILAUS':
      'Liga Académica de Nutrición de la Universidad Sudamericana, sede Saltos del Guairá (NUTRILAUS-SDG)',
  'NUTRILAUS-SDG':
      'Liga Académica de Nutrición de la Universidad Sudamericana, sede Saltos del Guairá (NUTRILAUS-SDG)',
  'LAMEFUS':
      'Liga Académica de Medicina Familiar de la Universidad Sudamericana, sede Saltos del Guairá (LAMEFUS-SDG)',
  'LAMEFUS-SDG':
      'Liga Académica de Medicina Familiar de la Universidad Sudamericana, sede Saltos del Guairá (LAMEFUS-SDG)',
  'LAMPREV':
      'Liga Académica de Medicina Preventiva de la Universidad Sudamericana, sede Saltos del Guairá (LAMPREV-US-SDG)',
  'LAMPREV-US-SDG':
      'Liga Académica de Medicina Preventiva de la Universidad Sudamericana, sede Saltos del Guairá (LAMPREV-US-SDG)',
  'LAPMUS':
      'Liga Académica de Psicología Médica de la Universidad Sudamericana, sede Saltos del Guairá (LAPMUS-SDG)',
  'LAPMUS-SDG':
      'Liga Académica de Psicología Médica de la Universidad Sudamericana, sede Saltos del Guairá (LAPMUS-SDG)',
};

String? _fullNameLiga(String organizeShort, String acronimo) {
  final key1 = organizeShort.toUpperCase(); // ej: LANTUS
  final key2 = acronimo.toUpperCase(); // ej: LAOH-US
  final key3 = '$key1-SDG'; // fallback común
  return _ligaNombres[key1] ?? _ligaNombres[key2] ?? _ligaNombres[key3];
}

/* ═══════════════════════════════════════════════════════════════
   GRID CONFIG: breakpoints → columnas y ancho fijo del card
   ═══════════════════════════════════════════════════════════════ */
class _GridSetup {
  final int cross; // (no lo usamos ahora, pero lo dejamos por si volvés a grid)
  final double cardWidth;
  const _GridSetup(this.cross, this.cardWidth);
}

_GridSetup _gridFor(double width) {
  // Pensado para container máx 1180
  if (width >= 1180) return const _GridSetup(3, 350); // 3 cols aprox
  if (width >= 980) return const _GridSetup(3, 320);
  if (width >= 760) return const _GridSetup(2, 360);
  if (width >= 540) return const _GridSetup(2, 320);
  return const _GridSetup(1, 420); // 1 col
}

/* ═══════════════════════════════════════════════════════════════
   =======================  DATA  ================================
   ═══════════════════════════════════════════════════════════════ */

// Helper cortos
List<String> ds(List<String> v) => v;

final List<LigaActividad> _cronograma = [
  // =========================
  // DÍA 1 – JUEVES 09/OCT · TARDE (14–16 / 16–18)
  // =========================
  LigaActividad(
    turno: TurnoDia.juevesTarde,
    horario: '14:00 – 16:00',
    sala: 'Sala 01',
    actividad: 'III Simposio LADERMUS',
    disertantes: ds(['Dr. Alejandro Ferreira', 'Dra. Vivian Fleitas']),
    organizeShort: 'LADERMUS',
    ligaAcronimo: 'LADERMUS',
  ),
  LigaActividad(
    turno: TurnoDia.juevesTarde,
    horario: '14:00 – 16:00',
    sala: 'Sala 02',
    actividad: 'Workshop: Dolor en neurología, fibromialgia y cefalea',
    disertantes: ds(['Dr. Bruno Cabañas', 'Dr. Fernando Domínguez']),
    organizeShort: 'LANEURUS',
    ligaAcronimo: 'LANEURUS',
  ),
  LigaActividad(
    turno: TurnoDia.juevesTarde,
    horario: '14:00 – 16:00',
    sala: 'Sala 03',
    actividad: 'Taller de Emergencias Críticas: RCP Avanzado',
    disertantes: ds(['Dra. Camila Rolón']),
    organizeShort: 'LACARDIUS',
    ligaAcronimo: 'LACARDIUS',
  ),
  LigaActividad(
    turno: TurnoDia.juevesTarde,
    horario: '16:00 – 18:00',
    sala: 'Sala 01',
    actividad:
        'Workshop: Esporotricosis: Salud pública y enfoque multidisciplinario para una zoonosis emergente',
    disertantes: ds([
      'Dra. Mirtha Fabiola Calderini López',
      'Dr. Sergio Darío Escobar Vega',
      'Dra. Sady Haitter',
      'Dra. Olga Rivarola',
    ]),
    organizeShort: 'LAMICROUS',
    ligaAcronimo: 'LAMICROUS',
  ),
  LigaActividad(
    turno: TurnoDia.juevesTarde,
    horario: '16:00 – 18:00',
    sala: 'Sala 02',
    actividad:
        'Conferencia: Fármacos inmunosupresores en pacientes trasplantados: de la teoría a la práctica clínica',
    disertantes: ds(['Dra. Alicia Fleitas']),
    organizeShort: 'LADTOUS',
    ligaAcronimo: 'LADTOUS',
  ),
  LigaActividad(
    turno: TurnoDia.juevesTarde,
    horario: '16:00 – 18:00',
    sala: 'Sala 03',
    actividad: 'Taller de Emergencias Críticas: Intubación orotraqueal',
    disertantes: ds(['Dra. Camila Rolón']),
    organizeShort: 'LAEME',
    ligaAcronimo: 'LAEME',
  ),

  // =========================
  // DÍA 2 – VIERNES 10/OCT · MAÑANA (08–10 / 10–12)
  // =========================
  LigaActividad(
    turno: TurnoDia.viernesManana,
    horario: '08:00 – 10:00',
    sala: 'Sala 01',
    actividad:
        'Conferencia: Manejo de intoxicaciones por drogas ilícitas y benzodiazepinas',
    disertantes: ds(['Dra. Alicia Fleitas']),
    organizeShort: 'LACMUS',
    ligaAcronimo: 'LACMUS',
  ),
  LigaActividad(
    turno: TurnoDia.viernesManana,
    horario: '08:00 – 10:00',
    sala: 'Sala 02',
    actividad: 'Suicidio: La prevención empieza con la aceptación',
    disertantes: ds(['Psic. Sabrina dos Santos Silva']),
    organizeShort: 'LAPMUS',
    ligaAcronimo: 'LAPMUS',
  ),
  LigaActividad(
    turno: TurnoDia.viernesManana,
    horario: '08:00 – 10:00',
    sala: 'Sala 03',
    actividad:
        'Sedentarismo y Mala alimentación en la vida académica. Practicidad vs Cotidiano en el área Estudiantil.',
    disertantes: ds([
      'Dra. Adriana Costa Araújo',
      'Dr. João Paulo Casari Romualdo',
    ]),
    organizeShort: 'NUTRILAUS',
    ligaAcronimo: 'NUTRILAUS',
  ),
  LigaActividad(
    turno: TurnoDia.viernesManana,
    horario: '10:00 – 12:00',
    sala: 'Sala 01',
    actividad:
        'Primeros auxilios y atención de emergencia para mujeres embarazadas',
    disertantes: ds(['Bombero militar Eber Rodrigues Barbosa']),
    organizeShort: 'LAGOUS',
    ligaAcronimo: 'LAGOUS',
  ),
  LigaActividad(
    turno: TurnoDia.viernesManana,
    horario: '10:00 – 12:00',
    sala: 'Sala 02',
    actividad: 'Workshop: Semiologia respiratória',
    disertantes: ds(['Dra. Erika Montalvo']),
    organizeShort: 'LANTUS',
    ligaAcronimo: 'LANTUS',
  ),
  LigaActividad(
    turno: TurnoDia.viernesManana,
    horario: '10:00 – 12:00',
    sala: 'Sala 03',
    actividad: 'Chara sobre Fracturas: de la teoría al paciente.',
    disertantes: ds(['Dra. Patricia Gonzales Rojas']),
    organizeShort: 'LAOTUS',
    ligaAcronimo: 'LAOTUS',
  ),

  // =========================
  // DÍA 2 – VIERNES 10/OCT · TARDE (14–16 / 16–18)
  // =========================
  LigaActividad(
    turno: TurnoDia.viernesTarde,
    horario: '14:00 – 16:00',
    sala: 'Sala 01',
    actividad: 'Taller teórico-práctico: TEP',
    disertantes: ds(['Dra. Sonia Bogado', 'Dr. Alejandro Ferreira']),
    organizeShort: 'LAPED',
    ligaAcronimo: 'LAPED',
  ),
  LigaActividad(
    turno: TurnoDia.viernesTarde,
    horario: '14:00 – 16:00',
    sala: 'Sala 02',
    actividad:
        'Workshop: Del trazado al diagnóstico, ECG fundamentos, correlaciones clínicas y práctica aplicada.',
    disertantes: ds(['Dr. Jonathan Salinas']),
    organizeShort: 'LAFISIO',
    ligaAcronimo: 'LAFISIO-US-SDG',
    flyerOverride: 'LAFISIOUS',
  ),
  LigaActividad(
    turno: TurnoDia.viernesTarde,
    horario: '16:00 – 18:00',
    sala: 'Sala 01',
    actividad:
        'Avances en el Tratamiento de la Diabetes Tipo 2: Nuevos Fármacos',
    disertantes: ds(['Guillermo Ferreira']),
    organizeShort: 'LIGAME',
    ligaAcronimo: 'LIGAME',
  ),
  LigaActividad(
    turno: TurnoDia.viernesTarde,
    horario: '16:00 – 18:00',
    sala: 'Sala 02',
    actividad: 'Taller Octubre Rosa y Salud de la Mujer',
    disertantes: ds(['Dra. Erica Lourenço']),
    organizeShort: 'LAMPREV',
    ligaAcronimo: 'LAMPREV',
  ),
  LigaActividad(
    turno: TurnoDia.viernesTarde,
    horario: '16:00 – 18:00',
    sala: 'Sala 03',
    actividad:
        'Mesa redonda: Infectología interdisciplinaria, conexiones de la medicina',
    disertantes: ds([
      'Dr. Carlos García',
      'Dr. Marcos Coronel',
      'Dra. Alicia FleitaS',
      'Dra. Sady Hatter',
      'Dr. Jonatan Salinas',
      'Dra. Laura López',
      'Dr. José Emmanuel Hauron Troche',
    ]),
    organizeShort: 'LAIIUS-SDG',
    ligaAcronimo: 'LAIIUS',
  ),

  // =========================
  // DÍA 3 – SÁBADO 11/OCT · TARDE (14–16 / 16–18)
  // =========================
  LigaActividad(
    turno: TurnoDia.sabadoTarde,
    horario: '14:00 – 16:00',
    sala: 'Sala 01',
    actividad:
        'Taller Teórico – Práctico: Administración Segura de Inyectables en la Atención Primaria',
    disertantes: ds(['Dra. Laura Ramírez']),
    organizeShort: 'LAMEFUS-SDG',
    ligaAcronimo: 'LAMEFUS',
  ),
  LigaActividad(
    turno: TurnoDia.sabadoTarde,
    horario: '14:00 – 16:00',
    sala: 'Sala 02',
    actividad:
        'Signos Vitales en la Práctica: Localización Anatómica y Técnica de Toma',
    disertantes: ds(['Dr. Guillermo Ferreira']),
    organizeShort: 'LADAUS-SDG',
    ligaAcronimo: 'LADAUS',
  ),
  LigaActividad(
    turno: TurnoDia.sabadoTarde,
    horario: '14:00 – 16:00',
    sala: 'Sala 03',
    actividad: 'Taller: Sutura',
    disertantes: ds(['Dr. Elvio Rojas']),
    organizeShort: 'LACIS-SDG',
    ligaAcronimo: 'LACIS',
  ),
  LigaActividad(
    turno: TurnoDia.sabadoTarde,
    horario: '16:00 – 18:00',
    sala: 'Sala 01',
    actividad:
        'Charla - Trastorno de Ansiedad Generalizada y Estrés post Traumático',
    disertantes: ds(['Dra. Andressa Krug']),
    organizeShort: 'LAPSUSS-SDG',
    ligaAcronimo: 'LAPSUSS',
  ),
  LigaActividad(
    turno: TurnoDia.sabadoTarde,
    horario: '16:00 – 18:00',
    sala: 'Sala 02',
    actividad:
        'Conferencia: Trauma cerrado de abdomen y su manejo, con presentación de caso clínico + Workshop de manejo respiratorio y ABC del trauma',
    disertantes: ds(['Dr. Augusto Rolón']),
    organizeShort: 'LAETUS-SDG',
    ligaAcronimo: 'LAETUS',
  ),
  LigaActividad(
    turno: TurnoDia.sabadoTarde,
    horario: '16:00 – 18:00',
    sala: 'Sala 03',
    actividad: 'Conferencia: Conductas a seguir ante un nódulo tiroideo',
    disertantes: ds(['Dr. Elvio Rojas']),
    organizeShort: 'LAOH',
    ligaAcronimo: 'LAOH',
    flyerOverride: 'LAOH-US',
  ),
];
