import 'dart:async';

import 'package:congreso_evento/core/behahavior/custom_scroll_behavior.dart';
import 'package:congreso_evento/core/empty_result.dart';
import 'package:congreso_evento/core/formater/date_formater.dart';
import 'package:congreso_evento/core/formater/number_formater.dart';
import 'package:congreso_evento/core/notifiier/default_state_notififier.dart';
import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:congreso_evento/modules/home_admin/pages/pagos/models/resumen_cobrador_turno.dart';
import 'package:congreso_evento/modules/home_admin/pages/pagos/pago_page_ctrl.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mobx/mobx.dart';

const brandPrimary = Color(0xFF387f4d); // ya lo tenés
const brandLight = Color(0xFF73c165); // ya lo tenés
const kBorder = Color(0xFFE5E7EB);
const kMuted = Color(0xFF6B7280);
const kInk = Color(0xFF111827);

class PaginatedResult<T> {
  final List<T> items;
  final int totalCount;
  PaginatedResult({required this.items, required this.totalCount});
}

// ==========================
// Página (ListView.builder + scroll vertical)
// ==========================
class PagosPage extends StatefulWidget {
  const PagosPage({super.key});

  @override
  State<PagosPage> createState() => _PagosPageState();
}

class _PagosPageState extends State<PagosPage> with DefaultStateNotifier {
  final _ctrl = Modular.get<PagoPageCtrl>();

  final _buscadorCtrl = TextEditingController();
  final _registroCtrl = TextEditingController();
  final _listCtrl = ScrollController();

  Timer? _debounce;

  late ReactionDisposer _rctDspr;

  Timer? _tick;
  Duration? _restante;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await _ctrl.init();
      _ctrl.primeraConsulta();
      _listCtrl.addListener(_onScroll);

      // Timer sutil para countdown y corte al expirar
      _tick?.cancel();
      _tick = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() {
          _restante = _ctrl.restanteCobro;
        });
        _ctrl.verificarVigenciaYCancelarSiExpira();
      });
    });

    _rctDspr = reaction((_) => _ctrl.stateClass, (s) {
      switch (s.status) {
        case StatusEnumGlobal.errorAndAction:
          hideLoader();
          Modular.to.pop(); // cierra el diálogo
          showAlertWarning(s.message);
          break;
        case StatusEnumGlobal.loading:
          showLoader();
          break;
        case StatusEnumGlobal.loaded:
          hideLoader();
          break;
        case StatusEnumGlobal.success:
          hideLoader();
          showAlert(s.message, DefaultStateNotifier.TYPE_SUCCESS);
          break;
        case StatusEnumGlobal.errorDialog:
          hideLoader();
          showAlertWarning(s.message);
        default:
      }
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    _buscadorCtrl.dispose();
    _registroCtrl.dispose();
    _listCtrl.dispose();
    _debounce?.cancel();
    _rctDspr.call();
    super.dispose();
  }

  void _onScroll() {
    if (_listCtrl.position.pixels >= _listCtrl.position.maxScrollExtent - 320) {
      _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 350), () {
        _ctrl.siguienteConsulta();
      });
    }
  }

  // ======== Búsqueda (debounce) ========
  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      _ctrl.setCondicion = _buscadorCtrl.text.trim();
    });
  }

  // ======== Acciones ========
  void _onVerUsuario(Usuario u) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Detalle del usuario'),
        content: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _kv('Nombre', u.nombreCompleto!),
              _kv('Registro', u.registroAcademico!),
              _kv('Email', u.email!),
              _kv('Estado', u.getEstado()),
              _kv(
                'Monto',
                u.montoPago != null ? newFormatNumber(u.montoPago!, 1) : '—',
              ),
              _kv(
                'Fecha',
                u.fechaPago != null ? formatDateAndTime(u.fechaPago!) : '—',
              ),
              _kv('Cobrador', u.usuarioPago ?? '—'),
            ],
          ),
        ),
        actions: [
          if (_ctrl.usuario?.isAdmin == true &&
              (u.isPago == true || u.isExonerado == true))
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                _onAnularPago(u);
              },
              child: const Text('Anular Pago'),
            ),
          if (_ctrl.usuario?.isAdmin == true && u.isPago == false)
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: brandPrimary,
              ),
              onPressed: () {
                _onConfirmarPago(u, isExonerado: true);
                Navigator.pop(context);
              },
              child: const Text('Exonerar'),
            ),

          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  void _onConfirmarPago(Usuario u, {bool isExonerado = false}) async {
    if (!mounted) return;

    if (isExonerado) {
      await Future.delayed(const Duration(milliseconds: 350));
      showAlertWarning(
        '¿Está seguro que desea exonerar el pago?',
        onPressed: () => _ctrl.confirmar(u.id!, isExonerado: isExonerado),
      );
    } else {
      showAlertWarning(
        '¿Está seguro que desea confirmar el pago?',
        onPressed: () => _ctrl.confirmar(u.id!, isExonerado: isExonerado),
      );
    }
  }

  // ======== UI ========
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Nuevo:
    // final brand = brandPrimary;
    // final onBrand = Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagos'),
        centerTitle: false,
        backgroundColor: brandLight,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => _ctrl.primeraConsulta(),
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _ctrl.onRefresh(),
        child: LayoutBuilder(
          builder: (context, c) {
            final w = c.maxWidth;
            final isMobile = w < 720;

            return ScrollConfiguration(
              behavior: CustomScrollBehavior(),
              child: CustomScrollView(
                controller: _listCtrl,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // --- BARRA DE BÚSQUEDA ---
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: kBorder),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: _SearchBar(
                          buscadorCtrl: _buscadorCtrl,
                          onChanged: _onSearchChanged,
                        ),
                      ),
                    ),
                  ),

                  // --- COUNTDOWN (ventana de cobro) ---
                  Observer(
                    builder: (_) {
                      if (!_ctrl.puedeCobrar) {
                        return const SliverToBoxAdapter(
                          child: SizedBox.shrink(),
                        );
                      }
                      final d = _restante ?? _ctrl.restanteCobro;
                      final texto = _fmtCountdown(d);
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Container(
                            decoration: BoxDecoration(
                              color: brandPrimary.withOpacity(.06),
                              border: Border.all(
                                color: brandPrimary.withOpacity(.20),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.timer_outlined, color: brandPrimary),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Ventana de cobros activa • Tiempo restante: $texto',
                                    style: const TextStyle(
                                      color: kInk,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  tooltip: 'Refrescar',
                                  onPressed: () => _ctrl.primeraConsulta(),
                                  icon: const Icon(Icons.refresh),
                                  color: brandPrimary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // --- FILTROS: ESTADO ---
                  Observer(
                    builder: (_) {
                      if (!_ctrl.isAdmin) {
                        return const SliverToBoxAdapter(
                          child: SizedBox(height: 8),
                        );
                      }
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _ChoiceChipX(
                                label: 'Todos',
                                selected:
                                    _ctrl.filtroEstado == FiltroEstado.todos,
                                onSelected: (_) {
                                  _ctrl.filtroEstado = FiltroEstado.todos;
                                  _ctrl.primeraConsulta();
                                },
                              ),
                              _ChoiceChipX(
                                label: 'Pagos',
                                selected:
                                    _ctrl.filtroEstado == FiltroEstado.pagos,
                                onSelected: (_) {
                                  _ctrl.filtroEstado = FiltroEstado.pagos;
                                  _ctrl.primeraConsulta();
                                },
                              ),
                              _ChoiceChipX(
                                label: 'Exonerados',
                                selected:
                                    _ctrl.filtroEstado ==
                                    FiltroEstado.exonerados,
                                onSelected: (_) {
                                  _ctrl.filtroEstado = FiltroEstado.exonerados;
                                  _ctrl.primeraConsulta();
                                },
                              ),
                              _ChoiceChipX(
                                label: 'Pendientes',
                                selected:
                                    _ctrl.filtroEstado ==
                                    FiltroEstado.pendientes,
                                onSelected: (_) {
                                  _ctrl.filtroEstado = FiltroEstado.pendientes;
                                  _ctrl.primeraConsulta();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // --- FILTROS: PERIODO ---
                  Observer(
                    builder: (_) {
                      if (!_ctrl.isAdmin) {
                        return const SliverToBoxAdapter(
                          child: SizedBox(height: 8),
                        );
                      }
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _ChoiceChipX(
                                label: 'Hoy',
                                selected:
                                    _ctrl.filtroPeriodo == FiltroPeriodo.hoy,
                                onSelected: (_) {
                                  _ctrl.filtroPeriodo = FiltroPeriodo.hoy;
                                  _ctrl.primeraConsulta();
                                  _ctrl.cargarResumenTurno();
                                },
                              ),
                              _ChoiceChipX(
                                label: 'Ayer',
                                selected:
                                    _ctrl.filtroPeriodo == FiltroPeriodo.ayer,
                                onSelected: (_) {
                                  _ctrl.filtroPeriodo = FiltroPeriodo.ayer;
                                  _ctrl.primeraConsulta();
                                  _ctrl.cargarResumenTurno();
                                },
                              ),
                              _ChoiceChipX(
                                label: 'Este mes',
                                selected:
                                    _ctrl.filtroPeriodo == FiltroPeriodo.mes,
                                onSelected: (_) {
                                  _ctrl.filtroPeriodo = FiltroPeriodo.mes;
                                  _ctrl.primeraConsulta();
                                  _ctrl.cargarResumenTurno();
                                },
                              ),
                              _ChoiceChipX(
                                label:
                                    _ctrl.filtroPeriodo == FiltroPeriodo.rango
                                    ? 'Rango (${_fmtShortRange(_ctrl.rangoPersonalizado)})'
                                    : 'Rango...',
                                selected:
                                    _ctrl.filtroPeriodo == FiltroPeriodo.rango,
                                onSelected: (_) async {
                                  final picked = await showDateRangePicker(
                                    context: context,
                                    firstDate: DateTime.now().subtract(
                                      const Duration(days: 365),
                                    ),
                                    lastDate: DateTime.now().add(
                                      const Duration(days: 365),
                                    ),
                                    saveText: 'Aplicar',
                                    builder: (ctx, child) => Theme(
                                      data: Theme.of(ctx).copyWith(
                                        colorScheme: ColorScheme.fromSeed(
                                          seedColor: brandPrimary,
                                        ),
                                      ),
                                      child: child!,
                                    ),
                                  );
                                  if (picked != null) {
                                    _ctrl.rangoPersonalizado = picked;
                                    _ctrl.filtroPeriodo = FiltroPeriodo.rango;
                                    _ctrl.primeraConsulta();
                                    _ctrl.cargarResumenTurno();
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // --- AGRUPACIÓN Y RESUMEN ---
                  Observer(
                    builder: (_) {
                      if (!_ctrl.isAdmin) {
                        return const SliverToBoxAdapter(
                          child: SizedBox.shrink(),
                        );
                      }
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(12, 6, 16, 0),
                          child: Row(
                            children: [
                              const SizedBox(width: 4),
                              Switch(
                                value: _ctrl.agruparPorCobrador,
                                onChanged: (v) async {
                                  _ctrl.agruparPorCobrador = v;
                                  if (v) {
                                    await _ctrl.cargarResumenTurno();
                                  } else {
                                    _ctrl.primeraConsulta();
                                  }
                                },
                                activeColor: brandPrimary,
                              ),
                              const SizedBox(width: 6),
                              const Text('Agrupar por cobrador'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // --- TARJETA DE RESUMEN (agrupado) ---
                  Observer(
                    builder: (_) {
                      if (!_ctrl.agruparPorCobrador) {
                        return const SliverToBoxAdapter(
                          child: SizedBox.shrink(),
                        );
                      }
                      final lista = _ctrl.resumenTurno;

                      return SliverToBoxAdapter(
                        child: Card(
                          margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: kBorder),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              ...lista.map(
                                (r) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 4,
                                    ),
                                    leading: const Icon(Icons.badge_outlined),
                                    title: Text(
                                      r.usuarioPagoNombre ?? '—',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),

                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // --- Bloque PAGOS ---
                                        const SizedBox(height: 6),
                                        const Text(
                                          'Pagos',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        _filaTurno(
                                          'Día (06–12)',
                                          r.cantDiaPagos,
                                          newFormatNumber(r.montoDiaPagos, 1),
                                        ),
                                        _filaTurno(
                                          'Tarde (13–18)',
                                          r.cantTardePagos,
                                          newFormatNumber(r.montoTardePagos, 1),
                                        ),
                                        _filaTurno(
                                          'Noche (19–05)',
                                          r.cantNochePagos,
                                          newFormatNumber(r.montoNochePagos, 1),
                                        ),

                                        // --- Bloque EXONERADOS ---
                                        const SizedBox(height: 8),
                                        const Text(
                                          'Exonerados',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        _filaTurno(
                                          'Día (06–12)',
                                          r.cantDiaEx,
                                          '—',
                                        ),
                                        _filaTurno(
                                          'Tarde (13–18)',
                                          r.cantTardeEx,
                                          '—',
                                        ),
                                        _filaTurno(
                                          'Noche (19–05)',
                                          r.cantNocheEx,
                                          '—',
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              const Divider(height: 12),

                              // Totales generales (pagos + exonerados)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  0,
                                  16,
                                  12,
                                ),
                                child: _totalesGeneralesEx(lista),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  // --- CONTADOR DE RESULTADOS ---
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      child: Observer(
                        builder: (_) => Text(
                          _ctrl.isAdmin
                              ? 'Resultados: ${_ctrl.congresistas.length} / ${_ctrl.totalRegistros}'
                              : 'Resultados: ${_ctrl.congresistas.length}',
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: brandPrimary),
                        ),
                      ),
                    ),
                  ),

                  // --- LISTA DE ÍTEMS ---
                  Observer(
                    builder: (_) {
                      final isEmpty = _ctrl.congresistas.isEmpty;
                      final finished = !_ctrl.isLoading; // consulta ya finalizó

                      if (isEmpty && finished) {
                        return SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                            child: const EmptyResult(
                              title: 'La consulta no retornó registros',
                            ),
                          ),
                        );
                      }

                      return SliverList.builder(
                        itemCount: _ctrl.congresistas.length,
                        itemBuilder: (context, index) {
                          final u = _ctrl.congresistas[index];
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                            child: _PagoItem(
                              usuario: u,
                              isMobile: isMobile,
                              onVer: () => _onVerUsuario(u),
                              isAdmin: _ctrl.isAdmin,
                              onConfirmar:
                                  (!_ctrl.isAdmin && !_ctrl.puedeCobrar)
                                  ? null
                                  : (u.isPago == true
                                        ? null
                                        : () => _onConfirmarPago(u)),
                            ),
                          );
                        },
                      );
                    },
                  ),

                  // --- LOADER / “CARGANDO MÁS” AL FINAL ---
                  Observer(
                    builder: (_) {
                      if (!_ctrl.isLoading || !_ctrl.isLastPage) {
                        return const SliverToBoxAdapter(
                          child: SizedBox(height: 16),
                        );
                      }
                      return const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(brandPrimary),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _fmtCountdown(Duration? d) {
    if (d == null) return '—';
    var secs = d.inSeconds;
    if (secs < 0) secs = 0;
    final days = secs ~/ 86400;
    secs %= 86400;
    final hh = secs ~/ 3600;
    secs %= 3600;
    final mm = secs ~/ 60;
    final ss = secs % 60;

    if (days > 0) {
      return '${days}d ${hh.toString().padLeft(2, '0')}:${mm.toString().padLeft(2, '0')}:${ss.toString().padLeft(2, '0')}';
    }
    return '${hh.toString().padLeft(2, '0')}:${mm.toString().padLeft(2, '0')}:${ss.toString().padLeft(2, '0')}';
  }

  // Helpers UI
  Widget _kv(String k, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(
            '$k:',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(child: Text(v)),
      ],
    ),
  );

  void _onAnularPago(Usuario u) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Anular Pago'),
        content: const Text('¿Estás seguro de que deseas anular este pago?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              _ctrl.anularPago(u);
              Navigator.pop(context);
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  // helpers UI nuevos:
  Widget _filaTurno(String label, int cantidad, String montoFmt) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: brandPrimary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('x$cantidad'),
          ),
          const Spacer(),
          Text(montoFmt),
        ],
      ),
    );
  }

  Widget _totalesGeneralesEx(List<ResumenCobradorTurno> xs) {
    // PAGOS
    final cantDiaPagos = xs.fold<int>(0, (a, e) => a + e.cantDiaPagos);
    final cantTardePagos = xs.fold<int>(0, (a, e) => a + e.cantTardePagos);
    final cantNochePagos = xs.fold<int>(0, (a, e) => a + e.cantNochePagos);
    final montoDiaPagos = xs.fold<double>(0, (a, e) => a + e.montoDiaPagos);
    final montoTardePagos = xs.fold<double>(0, (a, e) => a + e.montoTardePagos);
    final montoNochePagos = xs.fold<double>(0, (a, e) => a + e.montoNochePagos);
    final montoTotalPagos = montoDiaPagos + montoTardePagos + montoNochePagos;
    final cantTotalPagos = cantDiaPagos + cantTardePagos + cantNochePagos;

    // EXONERADOS
    final cantDiaEx = xs.fold<int>(0, (a, e) => a + e.cantDiaEx);
    final cantTardeEx = xs.fold<int>(0, (a, e) => a + e.cantTardeEx);
    final cantNocheEx = xs.fold<int>(0, (a, e) => a + e.cantNocheEx);
    final cantTotalEx = cantDiaEx + cantTardeEx + cantNocheEx;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('Totales', style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),

        const Text('Pagos', style: TextStyle(fontWeight: FontWeight.w600)),
        _filaTurno(
          'Día (06–12)',
          cantDiaPagos,
          newFormatNumber(montoDiaPagos, 1),
        ),
        _filaTurno(
          'Tarde (13–18)',
          cantTardePagos,
          newFormatNumber(montoTardePagos, 1),
        ),
        _filaTurno(
          'Noche (19–05)',
          cantNochePagos,
          newFormatNumber(montoNochePagos, 1),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Text(
              'Cobros totales:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Text('$cantTotalPagos'),
          ],
        ),
        Row(
          children: [
            const Text(
              'Monto total pagos:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Text(
              newFormatNumber(montoTotalPagos, 1),
              style: const TextStyle(
                color: brandPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),
        const Text('Exonerados', style: TextStyle(fontWeight: FontWeight.w600)),
        _filaTurno('Día (06–12)', cantDiaEx, '—'),
        _filaTurno('Tarde (13–18)', cantTardeEx, '—'),
        _filaTurno('Noche (19–05)', cantNocheEx, '—'),
        Row(
          children: [
            const Text(
              'Total exonerados:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const Spacer(),
            Text('$cantTotalEx'),
          ],
        ),
      ],
    );
  }
}

class _ChoiceChipX extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  const _ChoiceChipX({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      shape: StadiumBorder(
        side: BorderSide(color: brandPrimary.withOpacity(.25)),
      ),
      backgroundColor: Colors.white,
      selectedColor: brandPrimary.withOpacity(.12),
      labelStyle: TextStyle(color: selected ? brandPrimary : kInk),
      side: BorderSide(
        color: selected ? brandPrimary.withOpacity(.45) : kBorder,
      ),
    );
  }
}

String _fmtShortRange(DateTimeRange? r) {
  if (r == null) return '';
  String dd(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}';
  return '${dd(r.start)}–${dd(r.end)}';
}

// ==========================
// Barra de búsqueda responsiva (Wrap)
// ==========================
class _SearchBar extends StatelessWidget {
  final TextEditingController buscadorCtrl;
  final VoidCallback onChanged;

  const _SearchBar({required this.buscadorCtrl, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, c) {
        final w = c.maxWidth;

        final isXS = w < 576;
        final isSM = w >= 576 && w < 768;
        final isMD = w >= 768 && w < 992;

        double inputNombreW;
        if (isXS) {
          inputNombreW = w - 80;
        } else if (isSM) {
          inputNombreW = w * 0.58;
        } else if (isMD) {
          inputNombreW = 420;
        } else {
          inputNombreW = 520;
        }

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: inputNombreW.clamp(240, w),
              child: TextField(
                controller: buscadorCtrl,
                onChanged: (_) => onChanged(),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.person_search_outlined),
                  prefixIconColor: brandPrimary,
                  hintText: 'Buscar por nombre o registro académico...',
                  hintStyle: const TextStyle(color: kMuted),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: kBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: kBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: brandPrimary,
                      width: 1.4,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            Tooltip(
              message: 'Limpiar filtros',
              child: IconButton.filledTonal(
                onPressed: () {
                  buscadorCtrl.clear();
                  onChanged();
                },
                icon: const Icon(Icons.clear_all),
                style: IconButton.styleFrom(
                  backgroundColor: brandPrimary.withOpacity(0.12), // <—
                  foregroundColor: brandPrimary, // <—
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ==========================
// Ítem de lista (responsive)
// ==========================
class _PagoItem extends StatelessWidget {
  final Usuario usuario;
  final bool isMobile;
  final VoidCallback onVer;
  final VoidCallback? onConfirmar;
  final bool isAdmin;

  const _PagoItem({
    required this.usuario,
    required this.isMobile,
    required this.onVer,
    required this.onConfirmar,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: kBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: isMobile ? _buildMobile(context) : _buildDesktop(context),
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    final chip = _statusChip();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Nombre (flex grande)
        Expanded(
          flex: 3,
          child: Text(
            '${isAdmin ? usuario.id : ''} -  ${usuario.nombreCompleto ?? ''}',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),

        // Registro
        Expanded(
          flex: 2,
          child: Text(
            usuario.registroAcademico ?? '',
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 12),

        // Email
        Expanded(
          flex: 3,
          child: Text(usuario.email ?? '', overflow: TextOverflow.ellipsis),
        ),
        const SizedBox(width: 12),

        // Estado
        SizedBox(
          width: 140,
          child: Align(alignment: Alignment.centerLeft, child: chip),
        ),
        const SizedBox(width: 12),

        // Monto
        if (isAdmin) ...[
          SizedBox(
            width: 150,
            child: Text(
              usuario.isPago ? newFormatNumber(usuario.montoPago, 1) : '—',
            ),
          ),
          const SizedBox(width: 12),
        ],

        // Fecha
        SizedBox(
          width: 110,
          child: Text(
            usuario.fechaPago != null
                ? formatDateAndTime(usuario.fechaPago!)
                : '—',
          ),
        ),
        const SizedBox(width: 8),
        // Cobrador
        SizedBox(
          width: 180,
          child: Text(
            (usuario.isPago || usuario.isExonerado == true)
                ? (usuario.usuarioPago ?? '—')
                : '—',
            overflow: TextOverflow.clip,
          ),
        ),
        const SizedBox(width: 12),

        // Acciones
        Wrap(
          spacing: 4,
          children: [
            IconButton(
              tooltip: 'Ver',
              icon: Icon(Icons.visibility_outlined, color: brandPrimary), // <—
              onPressed: onVer,
            ),
            IconButton(
              tooltip: 'Confirmar pago',
              icon: Icon(Icons.check_circle_outline, color: brandPrimary), // <—
              onPressed: onConfirmar,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    final chip = _statusChip();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cabecera: nombre + estado
        Row(
          children: [
            Expanded(
              child: Text(
                '${isAdmin ? usuario.id : ''} -  ${usuario.nombreCompleto ?? ''}',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            chip,
          ],
        ),
        const SizedBox(height: 6),
        // Registro y email
        Text(
          'Reg.: ${usuario.registroAcademico}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          'Email: ${usuario.email}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 6),
        // Monto y Fecha
        if (isAdmin)
          Row(
            children: [
              Expanded(
                child: Text(
                  usuario.isPago ? newFormatNumber(usuario.montoPago, 1) : '—',
                  style: TextStyle(
                    color: (usuario.isPago) ? brandPrimary : null,
                  ), // <—
                ),
              ),
              Text(
                'Fecha: ${usuario.fechaPago != null ? formatDateAndTime(usuario.fechaPago!) : '—'}',
              ),
            ],
          ),
        const SizedBox(height: 8),
        Text(
          'Cobrador: ${(usuario.isPago || usuario.isExonerado == true) ? (usuario.usuarioPago ?? '—') : '—'}',
        ),

        // Acciones
        Row(
          spacing: 5,
          children: [
            OutlinedButton.icon(
              onPressed: onVer,
              icon: const Icon(Icons.visibility_outlined, size: 18),
              label: const Text('Ver'),
              style: OutlinedButton.styleFrom(
                foregroundColor: brandPrimary,
                side: BorderSide(color: brandPrimary.withOpacity(0.6)),
              ),
            ),
            FilledButton.icon(
              onPressed: onConfirmar,
              icon: const Icon(Icons.check_circle_outline, size: 18),
              label: const Text('Confirmar'),
              style: FilledButton.styleFrom(
                backgroundColor: brandPrimary,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statusChip() {
    final isOk = usuario.isPago;
    final chipColor = isOk ? brandPrimary : Colors.orange;
    return Chip(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
      avatar: Icon(
        isOk ? Icons.verified_rounded : Icons.pending_actions_rounded,
        size: 16,
        color: chipColor, // <—
      ),
      label: Text(usuario.getEstado()),
      side: BorderSide(color: chipColor.withOpacity(0.5)), // <—
      backgroundColor: chipColor.withOpacity(0.12), // <—
      labelStyle: TextStyle(color: chipColor), // <—
    );
  }
}

// ==========================
// Diálogo de QR (MobileScanner)
// ==========================
class _QRScannerDialog extends StatefulWidget {
  final void Function(String code) onCode;

  const _QRScannerDialog({required this.onCode});

  @override
  State<_QRScannerDialog> createState() => _QRScannerDialogState();
}

class _QRScannerDialogState extends State<_QRScannerDialog> {
  bool _handled = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    final canUseCameraOnWeb = kIsWeb;
    return AlertDialog(
      title: const Text('Escanear QR'),
      content: SizedBox(
        width: 480,
        height: 360,
        child: _error != null
            ? Center(child: Text('No se pudo iniciar la cámara:\n$_error'))
            : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: MobileScanner(
                  fit: BoxFit.cover,
                  onDetect: (capture) {
                    if (_handled) return;
                    final barcodes = capture.barcodes;
                    if (barcodes.isEmpty) return;
                    final value = barcodes.first.rawValue ?? '';
                    if (value.isEmpty) return;
                    _handled = true;
                    widget.onCode(value);
                  },
                  errorBuilder: (ctx, err) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Error con la cámara o permisos.\n'
                          'En Web, probá en Chrome/Edge y autorizá el acceso.\n'
                          'En producción usá HTTPS.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
      actions: [
        if (!canUseCameraOnWeb)
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}
