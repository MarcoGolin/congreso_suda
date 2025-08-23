import 'dart:async';

import 'package:congreso_evento/core/formater/date_formater.dart';
import 'package:congreso_evento/core/formater/number_formater.dart';
import 'package:congreso_evento/core/notifiier/default_state_notififier.dart';
import 'package:congreso_evento/modules/auth/models/usuario.dart';
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

  @override
  void initState() {
    super.initState();
    _ctrl.primeraConsulta();
    _listCtrl.addListener(_onScroll);
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
          if (_ctrl.usuario?.isAdmin == true)
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

  Future<void> _openQRScanner() async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => _QRScannerDialog(
        onCode: (code) {
          Navigator.of(ctx).pop();
          _registroCtrl.text = code;
          _onSearchChanged();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('QR detectado: $code')));
        },
      ),
    );
  }

  // ======== UI ========
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;

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
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _openQRScanner,
      //   icon: const Icon(Icons.qr_code_scanner),
      //   label: const Text('Escanear QR'),
      //   backgroundColor: brand,
      //   foregroundColor: onBrand,
      // ),
      body: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth;
          final isMobile = w < 720;

          return Column(
            children: [
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              //   child: _SectionHeaderChip(title: 'Gestión de pagos'),
              // ),
              // Barra de búsqueda (estilo HomeAdmin)
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

              // Lista (scroll SOLO vertical)
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await _ctrl.onRefresh();
                  },
                  child: Scrollbar(
                    controller: _listCtrl,
                    thumbVisibility: true,
                    child: Observer(
                      builder: (_) => ListView.builder(
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
                          return _PagoItem(
                            usuario: u,
                            isMobile: isMobile,
                            onVer: () => _onVerUsuario(u),
                            onConfirmar: u.isPago == true
                                ? null
                                : () => _onConfirmarPago(u),
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

  const _PagoItem({
    required this.usuario,
    required this.isMobile,
    required this.onVer,
    required this.onConfirmar,
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

        // Estado
        SizedBox(
          width: 140,
          child: Align(alignment: Alignment.centerLeft, child: chip),
        ),
        const SizedBox(width: 12),

        // Monto
        SizedBox(
          width: 150,
          child: Text(
            usuario.isPago ? newFormatNumber(usuario.montoPago, 1) : '—',
          ),
        ),
        const SizedBox(width: 12),

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
                '${usuario.id} -  ${usuario.nombreCompleto ?? ''}',
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

class _SectionHeaderChip extends StatelessWidget {
  final String title;
  const _SectionHeaderChip({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFF7FBF8), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: kBorder),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1F2937),
        ),
      ),
    );
  }
}
