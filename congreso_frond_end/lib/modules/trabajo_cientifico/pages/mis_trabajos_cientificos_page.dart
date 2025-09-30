import 'dart:convert';

import 'package:congreso_evento/core/js_cross_platform/js_cross_platform.dart'
    as js;
import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/controllers/mis_trabajos_excel_ctrl.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/models/trabajo_cientifico.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/stores/mis_trabajos_cientificos_store.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/widgets/trabajos_column_selection_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class MisTrabajosCientificosPage extends StatefulWidget {
  const MisTrabajosCientificosPage({super.key});

  @override
  State<MisTrabajosCientificosPage> createState() =>
      _MisTrabajosCientificosPageState();
}

class _MisTrabajosCientificosPageState
    extends State<MisTrabajosCientificosPage> {
  static const brandPrimary = Color(0xFF387f4d);
  static const brandLight = Color(0xFF73c165);

  final _store = Modular.get<MisTrabajosCientificosStore>();
  Usuario? _usuario;
  final _excelController = MisTrabajosCientificosExcelCtrl();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadUserAndTrabajos();
    });
  }

  Future<void> _loadUserAndTrabajos() async {
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
      debugPrint('Error cargando usuario: $e');
    }
  }

  Future<void> _onRefresh() async {
    if (_usuario?.id != null) {
      await _store.refresh(_usuario!.id.toString());
    } else {
      await _loadUserAndTrabajos();
    }
  }

  String _fmtDate(DateTime dt) {
    return DateFormat('dd/MM/yyyy').format(dt);
  }

  /// Sanitiza el nombre del archivo siguiendo el patrón de pdf_render.dart
  /// Construye la URL completa de Supabase a partir del path almacenado en la BD
  String _construirUrlSupabase(String pathBD) {
    const baseUrl =
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public';
    // El path ya incluye el bucket, solo agregamos la base
    return '$baseUrl/$pathBD';
  }

  String _sanitizeFileName(String input) {
    // Reemplazar caracteres inválidos (incluye \n, \r, tabs, etc.)
    final invalidChars = RegExp(r'[<>:"/\\|?*\x00-\x1F]');
    var sanitized = input.replaceAll(invalidChars, " ");

    // Quitar espacios o puntos al final (no válidos en Windows)
    sanitized = sanitized.replaceAll(RegExp(r'[ .]+$'), "");

    // Evitar nombres reservados en Windows
    const reserved = {
      "CON",
      "PRN",
      "AUX",
      "NUL",
      "COM1",
      "COM2",
      "COM3",
      "COM4",
      "COM5",
      "COM6",
      "COM7",
      "COM8",
      "COM9",
      "LPT1",
      "LPT2",
      "LPT3",
      "LPT4",
      "LPT5",
      "LPT6",
      "LPT7",
      "LPT8",
      "LPT9",
    };
    if (reserved.contains(sanitized.toUpperCase())) {
      sanitized = "_$sanitized";
    }

    // Evitar vacío
    if (sanitized.isEmpty) sanitized = "trabajo_cientifico";

    // Limitar a 255 caracteres (típico máximo en FS)
    if (sanitized.length > 200) {
      sanitized = sanitized.substring(0, 200);
    }

    return sanitized;
  }

  Future<void> _descargarArchivo(String pathBD, String nombreArchivo) async {
    try {
      // Construir URL completa de Supabase
      final urlCompleta = _construirUrlSupabase(pathBD);

      if (kIsWeb) {
        // Mostrar diálogo de descarga con progreso
        await _mostrarDialogoDescarga(urlCompleta, nombreArchivo);
      } else {
        // Para móvil: usar url_launcher (siguiendo el patrón de tu pdf_render)
        _mostrarIndicadorCarga(nombreArchivo);

        final uri = Uri.parse(urlCompleta);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.open_in_new, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(child: Text('📱 Archivo abierto: $nombreArchivo')),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          throw 'No se pudo abrir la URL del archivo';
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '❌ Error al descargar $nombreArchivo: ${e.toString()}',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  void _mostrarIndicadorCarga(String nombreArchivo) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text('Abriendo $nombreArchivo...')),
          ],
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: const Color(0xFF387f4d),
      ),
    );
  }

  /// Muestra diálogo de descarga con progreso, tamaño y tiempo estimado
  Future<void> _mostrarDialogoDescarga(String url, String nombreArchivo) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          _DialogoDescarga(url: url, nombreArchivo: nombreArchivo),
    );
  }

  /// Descarga archivo con confirmación previa
  Future<void> _descargarConConfirmacion(
    String url,
    String nombreArchivo,
  ) async {
    final confirmar = await _confirmarDescarga(nombreArchivo);
    if (confirmar) {
      await _descargarArchivo(url, nombreArchivo);
    }
  }

  /// Muestra un diálogo de confirmación antes de descargar archivos grandes
  Future<bool> _confirmarDescarga(String nombreArchivo) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.download, color: Color(0xFF387f4d)),
                SizedBox(width: 8),
                Text('Confirmar descarga'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('¿Deseas descargar el archivo?'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF387f4d).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.description,
                        color: Color(0xFF387f4d),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          nombreArchivo,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF387f4d),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(true),
                icon: const Icon(Icons.download, size: 16),
                label: const Text('Descargar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF387f4d),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _mostrarDetalle(TrabajoCientifico trabajo) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          trabajo.titulo,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetalleRow(
                label: 'Autor principal:',
                value: trabajo.autorNombre,
              ),
              _DetalleRow(label: 'Email:', value: trabajo.autorEmail),
              if (trabajo.autorTelefono.isNotEmpty)
                _DetalleRow(label: 'Teléfono:', value: trabajo.autorTelefono),
              _DetalleRow(label: 'Filiación:', value: trabajo.autorFiliacion),
              _DetalleRow(label: 'Modalidad:', value: trabajo.modalidad),
              _DetalleRow(label: 'Área temática:', value: trabajo.areaTematica),
              _DetalleRow(
                label: 'Área de medicina:',
                value: trabajo.areaDeLaMedicina,
              ),
              if (trabajo.resumen != null && trabajo.resumen!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Resumen:',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  trabajo.resumen!,
                  style: const TextStyle(color: Color(0xFF111827), height: 1.4),
                ),
              ],
              if (trabajo.coautores.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  'Coautores:',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 4),
                ...trabajo.coautores.map(
                  (coautor) => Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 2),
                    child: Text(
                      '• ${coautor.nombre} (${coautor.email})',
                      style: const TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
              if (trabajo.fechaRegistro != null)
                _DetalleRow(
                  label: 'Fecha de registro:',
                  value: _fmtDate(trabajo.fechaRegistro!),
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

  void _mostrarDialogoExportacion() {
    if (_store.trabajos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No hay trabajos científicos para exportar'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => TrabajosColumnSelectionDialog(
        controller: _excelController,
        trabajos: _store.trabajos,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis trabajos científicos'),
        backgroundColor: brandLight,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Observer(
            builder: (_) => IconButton(
              onPressed: _excelController.isLoading
                  ? null
                  : _mostrarDialogoExportacion,
              icon: _excelController.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.file_download),
              tooltip: 'Exportar a Excel',
            ),
          ),
        ],
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

          if (_store.trabajos.isEmpty) {
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
              itemCount: _store.trabajos.length,
              itemBuilder: (context, index) {
                final trabajo = _store.trabajos[index];
                return _TrabajoCard(
                  trabajo: trabajo,
                  onTap: () => _mostrarDetalle(trabajo),
                  onDescargarWord: () => _descargarConConfirmacion(
                    trabajo.archivoWordUrl,
                    '${_sanitizeFileName(trabajo.titulo)}.docx',
                  ),
                  onDescargarPdf: trabajo.archivoPdfUrl != null
                      ? () => _descargarConConfirmacion(
                          trabajo.archivoPdfUrl!,
                          '${_sanitizeFileName(trabajo.titulo)}.pdf',
                        )
                      : null,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _TrabajoCard extends StatelessWidget {
  final TrabajoCientifico trabajo;
  final VoidCallback onTap;
  final VoidCallback onDescargarWord;
  final VoidCallback? onDescargarPdf;

  const _TrabajoCard({
    required this.trabajo,
    required this.onTap,
    required this.onDescargarWord,
    this.onDescargarPdf,
  });

  String _fmtDate(DateTime dt) {
    return DateFormat('dd/MM/yyyy').format(dt);
  }

  @override
  Widget build(BuildContext context) {
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
              // Título
              Text(
                trabajo.titulo,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                ),
                softWrap: true,
              ),

              const SizedBox(height: 8),

              // Autor y modalidad
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
                      'Autor: ${trabajo.autorNombre}',
                      style: const TextStyle(
                        color: Color(0xFF374151),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      softWrap: true,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF387f4d).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF387f4d).withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      trabajo.modalidad,
                      style: const TextStyle(
                        color: Color(0xFF387f4d),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Áreas
              Row(
                children: [
                  Icon(
                    Icons.category_outlined,
                    size: 16,
                    color: const Color(0xFF6B7280),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${trabajo.areaTematica} • ${trabajo.areaDeLaMedicina}',
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 12,
                      ),
                      softWrap: true,
                    ),
                  ),
                ],
              ),

              if (trabajo.fechaRegistro != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 16,
                      color: const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Registrado: ${_fmtDate(trabajo.fechaRegistro!)}',
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 12),

              // Botones de descarga y ver detalle
              Row(
                children: [
                  // Botón Word con mejor feedback
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onDescargarWord,
                      icon: const Icon(Icons.download, size: 16),
                      label: const Text('Descargar Word'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1565C0),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 36),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Botón PDF (si existe) con mejor feedback
                  if (onDescargarPdf != null)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onDescargarPdf,
                        icon: const Icon(Icons.download, size: 16),
                        label: const Text('Descargar PDF'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDC2626),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(0, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 8),

              // Botón ver detalle separado
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onTap,
                  icon: const Icon(Icons.info_outline, size: 16),
                  label: const Text('Ver detalles completos'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF387f4d),
                    side: const BorderSide(color: Color(0xFF387f4d)),
                    minimumSize: const Size(0, 36),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
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
            Icons.science_outlined,
            size: 64,
            color: Color(0xFF9CA3AF),
          ),
          const SizedBox(height: 16),
          const Text(
            'No tienes trabajos científicos registrados',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Registra tus trabajos científicos para verlos aquí.',
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
            'Error cargando trabajos científicos',
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
            width: 100,
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

class _DialogoDescarga extends StatefulWidget {
  final String url;
  final String nombreArchivo;

  const _DialogoDescarga({required this.url, required this.nombreArchivo});

  @override
  State<_DialogoDescarga> createState() => _DialogoDescargaState();
}

class _DialogoDescargaState extends State<_DialogoDescarga>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  int _tamanhoArchivo = 0;
  int _bytesDescargados = 0;
  String _tiempoRestante = 'Calculando...';
  bool _iniciandoDescarga = true;
  bool _descargaCompleta = false;
  String _estado = 'Obteniendo información del archivo...';

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _iniciarDescarga();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _iniciarDescarga() async {
    try {
      // Paso 1: Obtener información del archivo
      if (kIsWeb) {
        final fileInfo = await js.getFileInfo(widget.url);
        setState(() {
          _tamanhoArchivo = fileInfo['size'] ?? 0;
          _estado = 'Preparando descarga...';
        });
      }

      // Paso 2: Simular progreso de descarga
      await _simularProgreso();

      // Paso 3: Realizar descarga real
      setState(() {
        _estado = 'Iniciando descarga...';
      });

      if (kIsWeb) {
        await js.downloadFromUrl(widget.url, widget.nombreArchivo);
      }

      setState(() {
        _descargaCompleta = true;
        _estado = '✅ Descarga completada';
        _bytesDescargados = _tamanhoArchivo;
      });

      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      setState(() {
        _estado = '❌ Error: ${e.toString()}';
      });
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _simularProgreso() async {
    setState(() {
      _iniciandoDescarga = false;
      _estado = 'Descargando archivo...';
    });

    const intervalos = 30;
    const duracionIntervalo = Duration(milliseconds: 100);

    for (int i = 0; i <= intervalos; i++) {
      if (!mounted) break;

      final progreso = i / intervalos;
      final bytesActuales = (_tamanhoArchivo * progreso).round();
      final tiempoTranscurrido = duracionIntervalo.inMilliseconds * i;

      String tiempoRestante = 'Calculando...';
      if (progreso > 0.1) {
        final tiempoEstimado = (tiempoTranscurrido / progreso) * (1 - progreso);
        final segundos = (tiempoEstimado / 1000).round();
        tiempoRestante = segundos > 0
            ? '${segundos}s restantes'
            : 'Casi listo...';
      }

      setState(() {
        _bytesDescargados = bytesActuales;
        _tiempoRestante = tiempoRestante;
      });

      _animationController.animateTo(progreso);
      await Future.delayed(duracionIntervalo);
    }
  }

  String _formatearTamanho(int bytes) {
    if (bytes == 0) return 'Desconocido';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final progreso = _tamanhoArchivo > 0
        ? _bytesDescargados / _tamanhoArchivo
        : 0.0;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF387f4d).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _descargaCompleta ? Icons.download_done : Icons.download,
                    color: const Color(0xFF387f4d),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Descargando archivo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.nombreArchivo,
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Barra de progreso
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _estado,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF374151),
                      ),
                    ),
                    Text(
                      '${(progreso * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF387f4d),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                AnimatedBuilder(
                  animation: _progressAnimation,
                  builder: (context, child) {
                    return LinearProgressIndicator(
                      value: _iniciandoDescarga
                          ? _progressAnimation.value
                          : progreso,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _descargaCompleta
                            ? Colors.green
                            : const Color(0xFF387f4d),
                      ),
                      minHeight: 8,
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Información del archivo
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tamaño',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _formatearTamanho(_tamanhoArchivo),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Descargado',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _formatearTamanho(_bytesDescargados),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Tiempo restante',
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            _tiempoRestante,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (!_descargaCompleta) ...[
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
