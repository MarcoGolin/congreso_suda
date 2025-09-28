import 'dart:convert';

import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:congreso_evento/modules/talleres/models/taller_inscripto.dart';
import 'package:congreso_evento/modules/talleres/stores/mis_talleres_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class MisTalleresPage extends StatefulWidget {
  const MisTalleresPage({super.key});

  @override
  State<MisTalleresPage> createState() => _MisTalleresPageState();
}

class _MisTalleresPageState extends State<MisTalleresPage> {
  static const brandPrimary = Color(0xFF387f4d);
  static const brandLight = Color(0xFF73c165);

  final _store = Modular.get<MisTalleresStore>();
  Usuario? _usuario;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadUserAndTalleres();
    });
  }

  Future<void> _loadUserAndTalleres() async {
    final storage = const FlutterSecureStorage();
    try {
      final raw = await storage.read(key: 'usuario_json');
      if (raw != null) {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        _usuario = Usuario.fromJson(map);

        if (_usuario?.id != null) {
          await _store.load(_usuario!.id.toString());
        }
      }
    } catch (e) {
      // Error cargando usuario
      debugPrint('Error cargando usuario: $e');
    }
  }

  Future<void> _onRefresh() async {
    if (_usuario?.id != null) {
      await _store.refresh(_usuario!.id.toString());
    } else {
      await _loadUserAndTalleres();
    }
  }

  String _fmtDate(DateTime dt) {
    return DateFormat('dd/MM/yyyy').format(dt);
  }

  String _fmtTime(DateTime dt) {
    return DateFormat('HH:mm').format(dt);
  }

  /// Determina el estado basado en los campos de pago del modelo real
  String _getEstadoTexto(TallerInscripto taller) {
    if (taller.isExonerado == true) {
      return '✅ Exonerado de pago';
    } else if (taller.fechaPago != null) {
      return '💰 Pago confirmado';
    } else {
      return '⏳ Pendiente de pago';
    }
  }

  Color _getEstadoColor(TallerInscripto taller) {
    if (taller.isExonerado == true) {
      return const Color(0xFF0EA5E9); // azul para exonerado
    } else if (taller.fechaPago != null) {
      return const Color(0xFF059669); // verde más intenso para pagado
    } else {
      return const Color(
        0xFFDC2626,
      ); // rojo para pendiente de pago (más urgente)
    }
  }

  void _mostrarDetalle(TallerInscripto taller) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(taller.taller.titulo ?? 'Taller'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Descripción completa si está disponible
              if (taller.taller.descripcion != null &&
                  taller.taller.descripcion!.isNotEmpty) ...[
                Text(
                  'Descripción:',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  taller.taller.descripcion!,
                  style: const TextStyle(color: Color(0xFF111827), height: 1.4),
                ),
                const SizedBox(height: 12),
              ],

              _DetalleRow(
                label: 'Fecha:',
                value: _fmtDate(taller.taller.fechaHora ?? taller.fecha),
              ),
              _DetalleRow(
                label: 'Horario:',
                value: _fmtTime(taller.taller.fechaHora ?? taller.fecha),
              ),
              if (taller.taller.sala != null)
                _DetalleRow(label: 'Sala:', value: taller.taller.sala!),
              if (taller.taller.organizador != null)
                _DetalleRow(
                  label: 'Organizador:',
                  value: taller.taller.organizador!,
                ),
              if (taller.taller.responsable != null)
                _DetalleRow(
                  label: 'Responsable:',
                  value: taller.taller.responsable!,
                ),
              if (taller.taller.contacto != null &&
                  taller.taller.contacto!.isNotEmpty)
                _DetalleRow(label: 'Contacto:', value: taller.taller.contacto!),
              _DetalleRow(
                label: 'Estado:',
                value: _getEstadoTexto(taller),
                valueColor: _getEstadoColor(taller),
              ),

              // Información de pago detallada
              if (taller.fechaPago != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF059669).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF059669).withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: const Color(0xFF059669),
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Información de Pago',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF059669),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _DetalleRow(
                        label: 'Fecha de pago:',
                        value: _fmtDate(taller.fechaPago!),
                      ),
                      if (taller.vlPago != null)
                        _DetalleRow(
                          label: 'Monto:',
                          value:
                              'Gs. ${NumberFormat('#,###').format(taller.vlPago)}',
                        ),
                      if (taller.usuarioPago != null)
                        _DetalleRow(
                          label: 'Cobrador:',
                          value: taller.usuarioPago!,
                        ),
                      if (taller.nrComprobante != null)
                        _DetalleRow(
                          label: 'Comprobante:',
                          value: taller.nrComprobante!,
                        ),
                    ],
                  ),
                ),
              ] else if (taller.isExonerado != true) ...[
                // Solo mostrar info de monto si está pendiente
                if (taller.vlPago != null)
                  _DetalleRow(
                    label: 'Monto a pagar:',
                    value: 'Gs. ${NumberFormat('#,###').format(taller.vlPago)}',
                    valueColor: const Color(0xFFDC2626),
                  ),
              ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis talleres'),
        backgroundColor: brandLight,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Observer(
        builder: (_) {
          if (_store.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_store.errorMessage != null) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _ErrorState(
                    message: _store.errorMessage!,
                    onRetry: () {
                      _store.clearError();
                      _onRefresh();
                    },
                  ),
                ],
              ),
            );
          }

          if (_store.talleres.isEmpty) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [_EmptyState(onRefresh: _onRefresh)],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _store.talleres.length,
              itemBuilder: (context, index) {
                final taller = _store.talleres[index];
                return _TallerCard(
                  taller: taller,
                  onTap: () => _mostrarDetalle(taller),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _TallerCard extends StatelessWidget {
  final TallerInscripto taller;
  final VoidCallback onTap;

  const _TallerCard({required this.taller, required this.onTap});

  String _fmtDate(DateTime dt) {
    return DateFormat('dd/MM/yyyy').format(dt);
  }

  String _fmtTime(DateTime dt) {
    return DateFormat('HH:mm').format(dt);
  }

  String _getEstadoTexto(TallerInscripto taller) {
    if (taller.isExonerado == true) {
      return '✅ Exonerado';
    } else if (taller.fechaPago != null) {
      return '💰 Pagado';
    } else {
      return '⏳ Pendiente pago';
    }
  }

  Color _getEstadoColor(TallerInscripto taller) {
    if (taller.isExonerado == true) {
      return const Color(0xFF0EA5E9); // azul para exonerado
    } else if (taller.fechaPago != null) {
      return const Color(0xFF059669); // verde más intenso para pagado
    } else {
      return const Color(
        0xFFDC2626,
      ); // rojo para pendiente de pago (más urgente)
    }
  }

  @override
  Widget build(BuildContext context) {
    final fechaTaller = taller.taller.fechaHora ?? taller.fecha;
    final nombreTaller = taller.taller.titulo ?? 'Taller sin título';

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      nombreTaller,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF111827),
                      ),
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _EstadoChip(
                    texto: _getEstadoTexto(taller),
                    color: _getEstadoColor(taller),
                  ),
                ],
              ),

              // Organizador
              if (taller.taller.organizador != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 16,
                      color: const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Organizado por: ${taller.taller.organizador}',
                        style: const TextStyle(
                          color: Color(0xFF374151),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ],

              // Descripción
              if (taller.taller.descripcion != null &&
                  taller.taller.descripcion!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: Text(
                    taller.taller.descripcion!,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 13,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                ),
              ],

              const SizedBox(height: 12),

              // Fecha, hora
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 16,
                    color: const Color(0xFF6B7280),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _fmtDate(fechaTaller),
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.access_time_outlined,
                    size: 16,
                    color: const Color(0xFF6B7280),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _fmtTime(fechaTaller),
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              // Sala
              if (taller.taller.sala != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.room_outlined,
                      size: 16,
                      color: const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      taller.taller.sala!,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],

              // Contacto
              if (taller.taller.contacto != null &&
                  taller.taller.contacto!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.contact_mail_outlined,
                      size: 16,
                      color: const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Contacto: ${taller.taller.contacto}',
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 13,
                        ),
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 12),
              Row(
                children: [
                  const Spacer(),
                  TextButton.icon(
                    onPressed: onTap,
                    icon: const Icon(Icons.info_outline, size: 16),
                    label: const Text('Ver detalle'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF387f4d),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EstadoChip extends StatelessWidget {
  final String texto;
  final Color color;

  const _EstadoChip({required this.texto, required this.color});

  @override
  Widget build(BuildContext context) {
    // Si es estado "Pagado" o contiene "💰", usar estilo más prominente
    final isPagado =
        texto.contains('💰') || texto.toLowerCase().contains('pagado');
    final isExonerado =
        texto.contains('✅') || texto.toLowerCase().contains('exonerado');

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isPagado || isExonerado ? 10 : 8,
        vertical: isPagado || isExonerado ? 6 : 4,
      ),
      decoration: BoxDecoration(
        color: isPagado || isExonerado
            ? color.withOpacity(0.15)
            : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(isPagado || isExonerado ? 10 : 8),
        border: Border.all(
          color: color.withOpacity(isPagado || isExonerado ? 0.4 : 0.25),
          width: isPagado || isExonerado ? 1.5 : 1,
        ),
        boxShadow: isPagado || isExonerado
            ? [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Text(
        texto,
        style: TextStyle(
          color: color,
          fontSize: isPagado || isExonerado ? 13 : 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const _EmptyState({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        gradient: const LinearGradient(
          colors: [Color(0xFFF7FBF8), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.event_busy_outlined,
            size: 64,
            color: Color(0xFF9CA3AF),
          ),
          const SizedBox(height: 16),
          const Text(
            'No tienes talleres inscriptos',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Inscríbete a talleres para verlos aquí.',
            style: TextStyle(color: Color(0xFF6B7280)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onRefresh,
            icon: const Icon(Icons.refresh),
            label: const Text('Actualizar'),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorState({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEF4444)),
        color: const Color(0xFFFEF2F2),
      ),
      child: Column(
        children: [
          const Icon(Icons.error_outline, size: 64, color: Color(0xFFEF4444)),
          const SizedBox(height: 16),
          const Text(
            'Error cargando talleres',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(color: Color(0xFF6B7280)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}

class _DetalleRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetalleRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: valueColor ?? const Color(0xFF111827),
                fontWeight: valueColor != null
                    ? FontWeight.w700
                    : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
