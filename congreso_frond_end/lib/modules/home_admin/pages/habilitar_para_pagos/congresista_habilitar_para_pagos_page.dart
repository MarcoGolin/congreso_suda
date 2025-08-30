import 'package:congreso_evento/core/loader_overlau.dart';
import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:congreso_evento/modules/home_admin/pages/habilitar_para_pagos/habilitacion_pagos_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../congresista/models/habilitacion_pagos.dart';

class CongresistaHabilitarParaPagosPage extends StatefulWidget {
  final Usuario usuario;

  const CongresistaHabilitarParaPagosPage({super.key, required this.usuario});

  @override
  State<CongresistaHabilitarParaPagosPage> createState() =>
      _CongresistaHabilitarParaPagosPageState();
}

const brandPrimary = Color(0xFF387f4d);
const brandLight = Color(0xFF73c165);
const kBorder = Color(0xFFE5E7EB);
const kMuted = Color(0xFF6B7280);
const kInk = Color(0xFF111827);

class _CongresistaHabilitarParaPagosPageState
    extends State<CongresistaHabilitarParaPagosPage> {
  DateTime? _inicio;
  DateTime? _fin;
  final _formKey = GlobalKey<FormState>();
  final _obsCtrl = TextEditingController();

  final _ctrl = Modular.get<HabilitacionPagosCtrl>();

  final LoadingOverlay _loadingOverlay =
      LoadingOverlay(); // Instancia del overlay

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _ctrl.consultaHorarios(idUsuario: widget.usuario.id!);
    });
  }

  @override
  void dispose() {
    _obsCtrl.dispose();
    super.dispose();
  }

  String _fmtFechaHora(BuildContext context, DateTime? dt) {
    if (dt == null) return '—';
    final loc = MaterialLocalizations.of(context);
    final fDate = loc.formatFullDate(dt);
    final fTime = loc.formatTimeOfDay(
      TimeOfDay.fromDateTime(dt),
      alwaysUse24HourFormat: true,
    );
    return '$fDate • $fTime';
    // Ej.: "miércoles, 27 de agosto de 2025 • 14:30"
  }

  Future<DateTime?> _pickDateTime({required DateTime initial}) async {
    final now = DateTime.now();
    final first = DateTime(now.year - 1);
    final last = DateTime(now.year + 2);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
      helpText: 'Seleccioná la fecha',
      cancelText: 'Cancelar',
      confirmText: 'Continuar',
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: ColorScheme.fromSeed(seedColor: brandPrimary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate == null) return null;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
      helpText: 'Seleccioná la hora',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
      builder: (ctx, child) {
        return Theme(
          data: Theme.of(ctx).copyWith(
            colorScheme: ColorScheme.fromSeed(seedColor: brandPrimary),
          ),
          child: child!,
        );
      },
    );

    if (pickedTime == null) return null;

    return DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );
  }

  void _setRangoRapido(Duration dur) {
    final now = DateTime.now();
    setState(() {
      _inicio = now;
      _fin = now.add(dur);
    });
  }

  String? _validar() {
    if (_inicio == null) return 'Seleccioná fecha y hora de inicio.';
    if (_fin == null) return 'Seleccioná fecha y hora de fin.';
    if (!_fin!.isAfter(_inicio!)) {
      return 'La hora fin debe ser posterior al inicio.';
    }
    return null;
  }

  void _guardar() {
    final err = _validar();
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }
    final dto = HabilitacionPagos(
      usuario: widget.usuario,
      inicio: _inicio!,
      fin: _fin!,
      observacion: _obsCtrl.text.trim().isEmpty ? null : _obsCtrl.text.trim(),
    );

    final registrationFuture = _ctrl.habilitar(habilitar: dto);
    _loadingOverlay.show(context, registrationFuture);
    _limpiarCampos();

    // Navigator.pop(context, dto);
  }

  @override
  Widget build(BuildContext context) {
    final usuario = widget.usuario.nombreCompleto ?? 'Usuario no especificado';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Habilitar para pagos'),
        centerTitle: false,
        backgroundColor: brandLight,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 860),
          child: CustomScrollView(
            slivers: [
              // Padding global
              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // Card: encabezado usuario
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: kBorder),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: brandPrimary.withOpacity(.1),
                            foregroundColor: brandPrimary,
                            child: const Icon(Icons.person),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  usuario,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: kInk,
                                  ),
                                ),
                                if (widget.usuario.id != null)
                                  const SizedBox(height: 2),
                                if (widget.usuario.id != null)
                                  Text(
                                    'ID: ${widget.usuario.id}',
                                    style: const TextStyle(
                                      color: kMuted,
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: brandPrimary.withOpacity(.08),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: brandPrimary.withOpacity(.2),
                              ),
                            ),
                            child: const Text(
                              'Habilitar la Ventana de cobros',
                              style: TextStyle(
                                color: kInk,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // Form fechas/horas
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: Form(
                    key: _formKey,
                    child: Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: kBorder),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _FechaHoraField(
                                    label: 'Inicio',
                                    valueText: _fmtFechaHora(context, _inicio),
                                    onTap: () async {
                                      final base = _inicio ?? DateTime.now();
                                      final picked = await _pickDateTime(
                                        initial: base,
                                      );
                                      if (picked != null) {
                                        setState(() => _inicio = picked);
                                      }
                                    },
                                    onClear: _inicio == null
                                        ? null
                                        : () => setState(() => _inicio = null),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _FechaHoraField(
                                    label: 'Fin',
                                    valueText: _fmtFechaHora(context, _fin),
                                    onTap: () async {
                                      final base =
                                          _fin ??
                                          (_inicio != null
                                              ? _inicio!.add(
                                                  const Duration(hours: 2),
                                                )
                                              : DateTime.now().add(
                                                  const Duration(hours: 2),
                                                ));
                                      final picked = await _pickDateTime(
                                        initial: base,
                                      );
                                      if (picked != null) {
                                        setState(() => _fin = picked);
                                      }
                                    },
                                    onClear: _fin == null
                                        ? null
                                        : () => setState(() => _fin = null),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Acciones rápidas
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _QuickChip(
                                    label: 'Ahora + 2 h',
                                    onTap: () => _setRangoRapido(
                                      const Duration(hours: 2),
                                    ),
                                  ),
                                  _QuickChip(
                                    label: 'Ahora + 4 h',
                                    onTap: () => _setRangoRapido(
                                      const Duration(hours: 4),
                                    ),
                                  ),
                                  _QuickChip(
                                    label: 'Hoy 08:00–18:00',
                                    onTap: () {
                                      final now = DateTime.now();
                                      final start = DateTime(
                                        now.year,
                                        now.month,
                                        now.day,
                                        8,
                                        0,
                                      );
                                      final end = DateTime(
                                        now.year,
                                        now.month,
                                        now.day,
                                        18,
                                        0,
                                      );
                                      setState(() {
                                        _inicio = start.isAfter(now)
                                            ? start
                                            : now;
                                        _fin = end;
                                      });
                                    },
                                  ),
                                  _QuickChip(
                                    label: 'Mañana 08:00–18:00',
                                    onTap: () {
                                      final now = DateTime.now();
                                      final t = now.add(
                                        const Duration(days: 1),
                                      );
                                      final start = DateTime(
                                        t.year,
                                        t.month,
                                        t.day,
                                        8,
                                        0,
                                      );
                                      final end = DateTime(
                                        t.year,
                                        t.month,
                                        t.day,
                                        18,
                                        0,
                                      );
                                      setState(() {
                                        _inicio = start;
                                        _fin = end;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Observación
                            TextFormField(
                              controller: _obsCtrl,
                              maxLines: 2,
                              decoration: InputDecoration(
                                labelText: 'Observación (opcional)',
                                hintText: 'Ej.: Responsable del turno, caja 2…',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 12)),

              // Resumen previo
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: kBorder),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      title: const Text('Resumen'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.play_arrow,
                                size: 18,
                                color: kMuted,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Inicio: ${_fmtFechaHora(context, _inicio)}',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.stop, size: 18, color: kMuted),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Fin: ${_fmtFechaHora(context, _fin)}',
                                ),
                              ),
                            ],
                          ),
                          if (_obsCtrl.text.trim().isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.notes,
                                  size: 18,
                                  color: kMuted,
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text('Obs.: ${_obsCtrl.text.trim()}'),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 16)),

              // Botonera
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: kInk,
                          side: const BorderSide(color: kBorder),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.close),
                        label: const Text('Cancelar'),
                      ),
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: _guardar,
                        style: FilledButton.styleFrom(
                          backgroundColor: brandPrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.save),
                        label: const Text('Guardar'),
                      ),
                    ],
                  ),
                ),
              ),

              // Loading barra
              Observer(
                builder: (_) {
                  if (_ctrl.isLoading) {
                    return SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      sliver: SliverToBoxAdapter(
                        child: LinearProgressIndicator(
                          color: brandPrimary,
                          backgroundColor: brandPrimary.withOpacity(.2),
                        ),
                      ),
                    );
                  }
                  return const SliverToBoxAdapter(child: SizedBox.shrink());
                },
              ),

              // Título historial
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: const SliverToBoxAdapter(
                  child: Text(
                    "Historial de habilitaciones",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: kInk,
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),

              // Historial como SliverList (sin ListView anidado)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: _buildHistorialSliver(),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistorialSliver() {
    return Observer(
      builder: (_) {
        final lista = _ctrl.listaHabilitacionPagos.toList();
        if (lista.isEmpty) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("No hay habilitaciones registradas."),
            ),
          );
        }

        final now = DateTime.now();

        int rank(DateTime n, HabilitacionPagos h) {
          if (h.fin.isBefore(n)) return 2; // expirada
          if (h.inicio.isAfter(n)) return 1; // próxima
          return 0; // vigente
        }

        lista.sort((a, b) {
          final r = rank(now, a).compareTo(rank(now, b));
          if (r != 0) return r;
          return a.inicio.compareTo(b.inicio);
        });

        // Construimos children intercalando separadores
        final children = <Widget>[];
        for (var i = 0; i < lista.length; i++) {
          children.add(
            _HabilitacionItemTile(
              item: lista[i],
              fmtFechaHora: (dt) => _fmtFechaHora(context, dt),
            ),
          );
          if (i != lista.length - 1) {
            children.add(const SizedBox(height: 8));
          }
        }

        return SliverList(delegate: SliverChildListDelegate(children));
      },
    );
  }

  void _limpiarCampos() {
    _inicio = null;
    _fin = null;
    _obsCtrl.clear();
    if (mounted) setState(() {});
  }
}

class _HabilitacionItemTile extends StatefulWidget {
  final HabilitacionPagos item;
  final String Function(DateTime?) fmtFechaHora;

  const _HabilitacionItemTile({required this.item, required this.fmtFechaHora});

  @override
  State<_HabilitacionItemTile> createState() => _HabilitacionItemTileState();
}

class _HabilitacionItemTileState extends State<_HabilitacionItemTile> {
  late Duration _delta; // tiempo hasta inicio o hasta fin
  late bool _isVigente;
  late bool _isProxima;
  late double _progress; // 0..1 para vigentes
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _recalcular();
    _ticker = Ticker((_) {
      if (!mounted) return;
      _recalcular();
    })..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _recalcular() {
    final now = DateTime.now();
    final inicio = widget.item.inicio;
    final fin = widget.item.fin;

    _isVigente = now.isAfter(inicio) && now.isBefore(fin);
    _isProxima = now.isBefore(inicio);

    if (_isVigente) {
      _delta = fin.difference(now); // tiempo restante
      final total = fin.difference(inicio).inMilliseconds;
      final curr = now.difference(inicio).inMilliseconds;
      _progress = total == 0 ? 1 : (curr / total).clamp(0.0, 1.0);
    } else if (_isProxima) {
      _delta = inicio.difference(now); // falta para iniciar
      _progress = 0;
    } else {
      _delta = now.difference(fin); // hace cuánto terminó
      _progress = 1;
    }
    setState(() {});
  }

  String _human(Duration d) {
    // salida compacta: 2d 05:04:03 | 05:04:03 | 14:07
    final isNeg = d.isNegative;
    var secs = d.inSeconds.abs();
    final days = secs ~/ (24 * 3600);
    secs -= days * 24 * 3600;
    final hours = secs ~/ 3600;
    secs -= hours * 3600;
    final mins = secs ~/ 60;
    secs -= mins * 60;

    String hhmmss() => [
      if (days > 0) '${days}d',
      hours.toString().padLeft(2, '0'),
      mins.toString().padLeft(2, '0'),
      secs.toString().padLeft(2, '0'),
    ].join(days > 0 ? ' ' : ':');

    return isNeg ? '-${hhmmss()}' : hhmmss();
  }

  Color _statusColorBg() {
    if (_isVigente) return Colors.green.shade50;
    if (_isProxima) return Colors.blue.shade50;
    return Colors.grey.shade200;
  }

  Color _statusColorFg() {
    if (_isVigente) return Colors.green.shade800;
    if (_isProxima) return Colors.blue.shade700;
    return Colors.grey.shade700;
  }

  Color _statusPillBg() {
    if (_isVigente) return brandPrimary.withOpacity(.12);
    if (_isProxima) return Colors.blue.withOpacity(.12);
    return Colors.grey.withOpacity(.2);
  }

  Color _statusPillFg() {
    if (_isVigente) return brandPrimary;
    if (_isProxima) return Colors.blue.shade700;
    return Colors.grey.shade700;
  }

  String _statusLabel() {
    if (_isVigente) return 'VIGENTE';
    if (_isProxima) return 'PRÓXIMA';
    return 'EXPIRADA';
  }

  @override
  Widget build(BuildContext context) {
    final h = widget.item;

    return Container(
      decoration: BoxDecoration(
        color: _statusColorBg(),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder),
      ),
      child: IntrinsicHeight(
        // 👈 asegura altura finita para el Row
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch, // ahora sí
          children: [
            // Borde lateral según estado
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: _isVigente
                    ? brandPrimary
                    : _isProxima
                    ? Colors.blue.shade400
                    : Colors.grey.shade400,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // 👈 importante
                  children: [
                    // Encabezado: estado + observación
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _statusPillBg(),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: _statusPillFg().withOpacity(.25),
                            ),
                          ),
                          child: Text(
                            _statusLabel(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: _statusPillFg(),
                              letterSpacing: .3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            h.observacion?.trim().isNotEmpty == true
                                ? h.observacion!.trim()
                                : '—',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: _statusColorFg().withOpacity(.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Rango
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 18,
                          color: _statusColorFg(),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            "${widget.fmtFechaHora(h.inicio)} → ${widget.fmtFechaHora(h.fin)}",
                            style: TextStyle(
                              color: _statusColorFg(),
                              fontWeight: _isVigente
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    if (_isVigente) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: _progress,
                          minHeight: 6,
                          color: brandPrimary,
                          backgroundColor: brandPrimary.withOpacity(.2),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.timer, size: 16, color: _statusColorFg()),
                          const SizedBox(width: 6),
                          Text(
                            "Tiempo restante: ${_human(_delta)}",
                            style: TextStyle(
                              color: _statusColorFg(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],

                    if (_isProxima) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.hourglass_bottom,
                            size: 16,
                            color: _statusColorFg(),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Comienza en: ${_human(_delta)}",
                            style: TextStyle(
                              color: _statusColorFg(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],

                    if (!_isVigente && !_isProxima) ...[
                      Row(
                        children: [
                          Icon(
                            Icons.history,
                            size: 16,
                            color: _statusColorFg(),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Finalizó hace: ${_human(_delta)}",
                            style: TextStyle(
                              color: _statusColorFg(),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ticker simple para 60 FPS; podés bajar la frecuencia si querés cada 1s.
class Ticker {
  final void Function(Duration) onTick;
  final Duration interval;
  bool _running = false;
  late final Stopwatch _sw;

  Ticker(this.onTick, {this.interval = const Duration(seconds: 1)})
    : _sw = Stopwatch();

  void start() {
    if (_running) return;
    _running = true;
    _sw.start();
    _loop();
  }

  void _loop() async {
    while (_running) {
      await Future.delayed(interval);
      onTick(_sw.elapsed);
    }
  }

  void dispose() {
    _running = false;
    _sw.stop();
  }
}

class _FechaHoraField extends StatelessWidget {
  final String label;
  final String valueText;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  const _FechaHoraField({
    required this.label,
    required this.valueText,
    required this.onTap,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onClear != null)
              IconButton(
                tooltip: 'Limpiar',
                onPressed: onClear,
                icon: const Icon(Icons.clear),
              ),
            IconButton(
              tooltip: 'Elegir fecha y hora',
              onPressed: onTap,
              icon: const Icon(Icons.event),
            ),
          ],
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            valueText,
            style: TextStyle(
              color: valueText == '—' ? kMuted : kInk,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _QuickChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      shape: StadiumBorder(
        side: BorderSide(color: brandPrimary.withOpacity(.25)),
      ),
      backgroundColor: brandPrimary.withOpacity(.06),
    );
  }
}
