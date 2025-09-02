import 'dart:async';

import 'package:congreso_evento/core/formater/date_formater.dart';
import 'package:congreso_evento/core/formater/number_formater.dart';
import 'package:congreso_evento/core/notifiier/default_state_notififier.dart';
import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/congresista_ctrl.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/utils/carnet_pdf.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/widgets/congresista_end_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

import '../habilitar_para_pagos/congresista_habilitar_para_pagos_page.dart';
import 'widgets/congresistra_datos.dart';

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
class CongresistaPage extends StatefulWidget {
  const CongresistaPage({super.key});

  @override
  State<CongresistaPage> createState() => _CongresistaPageState();
}

class _CongresistaPageState extends State<CongresistaPage>
    with DefaultStateNotifier {
  final _ctrl = Modular.get<CongresistaCtrl>();

  final _buscadorCtrl = TextEditingController();
  final _registroCtrl = TextEditingController();
  final _listCtrl = ScrollController();

  Timer? _debounce;

  late ReactionDisposer _rctDspr;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _ctrl.primeraConsulta();
      _listCtrl.addListener(_onScroll);
    });
    _rctDspr = reaction((_) => _ctrl.stateClass, (s) {
      switch (s.status) {
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
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  // ======== UI ========
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      endDrawer: CongresistaEndDrawer(),
      appBar: AppBar(
        title: const Text('Congresista'),
        centerTitle: false,
        backgroundColor: brandLight,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [],
      ),
      body: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth;
          final isMobile = w < 720;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
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
                  child: _SearchBar(
                    buscadorCtrl: _buscadorCtrl,
                    onChanged: _onSearchChanged,
                  ),
                ),
              ),

              // Resumen
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Observer(
                    builder: (_) => Text(
                      'Resultados: ${_ctrl.congresistas.length} / ${_ctrl.totalRegistros}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color:
                            brandPrimary, // o onSurface.withOpacity(0.7) si preferís sutil
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
              Expanded(
                child: Scrollbar(
                  controller: _listCtrl,
                  thumbVisibility: true,
                  child: Observer(
                    builder: (_) => RefreshIndicator(
                      onRefresh: () async {
                        await _ctrl.onRefresh();
                      },
                      child: ListView.builder(
                        controller: _listCtrl,
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount:
                            _ctrl.congresistas.length +
                            (_ctrl.isLoading || !_ctrl.isLastPage ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index >= _ctrl.congresistas.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation(
                                    brandPrimary,
                                  ),
                                ),
                              ),
                            );
                          }

                          final u = _ctrl.congresistas[index];
                          return _CongresistaItem(
                            usuario: u,
                            isMobile: isMobile,
                            generarCarnet: () => _generarCarnet(u),
                            onVer: () => _onVerUsuario(u),
                            onEditar: () => _openEditar(u), // <— NUEVO
                            onHabilitarPago: () =>
                                _openHabilitarPago(u), // <— NUEVO
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _openEditar(Usuario? original) async {
    Modular.to.push(
      MaterialPageRoute(
        builder: (_) =>
            Scaffold(body: CongresistraDatos(data: original, isPage: true)),
      ),
    );
    return;
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

  void _openHabilitarPago(Usuario u) {
    Modular.to.push(
      MaterialPageRoute(
        builder: (_) => CongresistaHabilitarParaPagosPage(usuario: u),
      ),
    );
  }

  void _generarCarnet(Usuario u) async {
    await printOrShareCarnet(u);
  }
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
class _CongresistaItem extends StatelessWidget {
  final Usuario usuario;
  final bool isMobile;
  final VoidCallback onVer;
  final VoidCallback onEditar;
  final VoidCallback onHabilitarPago;
  final VoidCallback generarCarnet;

  const _CongresistaItem({
    required this.usuario,
    required this.isMobile,
    required this.onVer,
    required this.onEditar,
    required this.onHabilitarPago,
    required this.generarCarnet,
  });

  @override
  Widget build(BuildContext context) {
    return SelectableRegion(
      selectionControls: MaterialTextSelectionControls(),
      child: Card(
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
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Nombre (flex grande)
        Expanded(
          flex: 3,
          child: Text(
            '${usuario.id} -  ${usuario.nombreCompleto ?? ''}',
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

        IconButton(
          tooltip: 'Generar carnet',
          onPressed: generarCarnet,
          icon: const Icon(Icons.qr_code, color: brandPrimary),
        ),

        IconButton(
          tooltip: 'Habilitar para Pago',
          icon: Icon(Icons.payments, color: brandPrimary),
          onPressed: onHabilitarPago, // <— NUEVO
        ),
        IconButton(
          tooltip: 'Editar',
          icon: Icon(Icons.edit_outlined, color: brandPrimary),
          onPressed: onEditar, // <— NUEVO
        ),
      ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cabecera: nombre + estado
        Row(
          children: [
            Expanded(
              child: Text(
                '${usuario.id} -  ${usuario.nombreCompleto ?? ''}',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
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
        // Acciones
        Row(
          spacing: 5,
          children: [
            OutlinedButton.icon(
              onPressed: generarCarnet,
              icon: const Icon(Icons.qr_code, size: 18),
              label: const Text('Generar carnet'),
              style: OutlinedButton.styleFrom(
                foregroundColor: brandPrimary,
                side: BorderSide(color: brandPrimary.withOpacity(0.6)),
              ),
            ),
            OutlinedButton.icon(
              onPressed: onHabilitarPago,
              icon: const Icon(Icons.payments, size: 18),
              label: const Text('Habilitar para Pago'),
              style: OutlinedButton.styleFrom(
                foregroundColor: brandPrimary,
                side: BorderSide(color: brandPrimary.withOpacity(0.6)),
              ),
            ),
            OutlinedButton.icon(
              onPressed: onEditar,
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Editar'),
              style: OutlinedButton.styleFrom(
                foregroundColor: brandPrimary,
                side: BorderSide(color: brandPrimary.withOpacity(0.6)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
