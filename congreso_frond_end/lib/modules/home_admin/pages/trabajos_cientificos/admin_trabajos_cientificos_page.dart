import 'package:congreso_evento/core/js_cross_platform/js_cross_platform.dart'
    as js;
import 'package:congreso_evento/modules/home_admin/pages/trabajos_cientificos/stores/admin_trabajos_cientificos_store.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/controllers/mis_trabajos_excel_ctrl.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/models/trabajo_cientifico.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/widgets/trabajos_column_selection_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminTrabajosCientificosPage extends StatefulWidget {
  const AdminTrabajosCientificosPage({super.key});

  @override
  State<AdminTrabajosCientificosPage> createState() =>
      _AdminTrabajosCientificosPageState();
}

class _AdminTrabajosCientificosPageState
    extends State<AdminTrabajosCientificosPage> {
  static const brandPrimary = Color(0xFF387f4d);

  final _store = Modular.get<AdminTrabajosCientificosStore>();
  final _searchController = TextEditingController();
  final _excelController = MisTrabajosCientificosExcelCtrl();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _store.cargarTodos();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Construye la URL completa de Supabase a partir del path almacenado en la BD
  String _construirUrlSupabase(String pathBD) {
    const baseUrl =
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public';
    return '$baseUrl/$pathBD';
  }

  Future<void> _descargarArchivo(String pathBD, String nombreArchivo) async {
    try {
      final urlCompleta = _construirUrlSupabase(pathBD);

      if (kIsWeb) {
        await _mostrarDialogoDescarga(urlCompleta, nombreArchivo);
      } else {
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

  Future<void> _mostrarDialogoDescarga(String url, String nombreArchivo) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          _DialogoDescarga(url: url, nombreArchivo: nombreArchivo),
    );
  }

  void _mostrarDetalleCompleto(TrabajoCientifico trabajo) {
    Modular.to.pushNamed(
      '/home_admin/trabajos/detalle/${trabajo.id}',
      arguments: trabajo.toJson(),
    );
  }

  Future<void> _onRefresh() async {
    await _store.cargarTodos();
  }

  void _mostrarDialogoExportacion() {
    if (_store.trabajosFiltrados.isEmpty) {
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
        trabajos: _store.trabajosFiltrados,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = MediaQuery.of(context).size.width < 600;
            return Text(
              isSmallScreen
                  ? 'Trabajos - Admin'
                  : 'Trabajos Científicos - Admin',
              style: const TextStyle(fontWeight: FontWeight.bold),
            );
          },
        ),
        backgroundColor: brandPrimary,
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
          Observer(
            builder: (_) => Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isSmallScreen = MediaQuery.of(context).size.width < 600;
                  return Observer(
                    builder: (_) => Text(
                      isSmallScreen
                          ? '${_store.trabajosFiltrados.length}'
                          : '${_store.trabajosFiltrados.length} trabajos',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Observer(
          builder: (_) {
            if (_store.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (_store.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar trabajos',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _store.errorMessage!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _onRefresh,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                _buildFiltros(),
                Expanded(
                  child: _store.trabajosFiltrados.isEmpty
                      ? _buildEmptyState()
                      : _buildTrabajosList(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildFiltros() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: _store.setFiltroTexto,
            decoration: InputDecoration(
              hintText: 'Buscar por título, autor, email o área temática...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _store.setFiltroTexto('');
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: brandPrimary, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Observer(
            builder: (_) {
              // Detectar si es móvil
              final isSmallScreen = MediaQuery.of(context).size.width < 600;

              if (isSmallScreen) {
                // Layout vertical para móvil
                return Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _store.filtroModalidad.isEmpty
                          ? null
                          : _store.filtroModalidad,
                      onChanged: (value) =>
                          _store.setFiltroModalidad(value ?? ''),
                      decoration: InputDecoration(
                        labelText: 'Modalidad',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: [
                        const DropdownMenuItem<String>(
                          value: '',
                          child: Text('Todas'),
                        ),
                        ..._store.modalidadesDisponibles.map(
                          (modalidad) => DropdownMenuItem<String>(
                            value: modalidad,
                            child: Text(
                              modalidad,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _store.filtroArea.isEmpty
                          ? null
                          : _store.filtroArea,
                      onChanged: (value) => _store.setFiltroArea(value ?? ''),
                      decoration: InputDecoration(
                        labelText: 'Área Temática',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      items: [
                        const DropdownMenuItem<String>(
                          value: '',
                          child: Text('Todas'),
                        ),
                        ..._store.areasDisponibles.map(
                          (area) => DropdownMenuItem<String>(
                            value: area,
                            child: Text(area, overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          _searchController.clear();
                          _store.limpiarFiltros();
                        },
                        child: const Text('Limpiar Filtros'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: brandPrimary,
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                // Layout horizontal para desktop/tablet
                return Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _store.filtroModalidad.isEmpty
                            ? null
                            : _store.filtroModalidad,
                        onChanged: (value) =>
                            _store.setFiltroModalidad(value ?? ''),
                        decoration: InputDecoration(
                          labelText: 'Modalidad',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: [
                          const DropdownMenuItem<String>(
                            value: '',
                            child: Text('Todas'),
                          ),
                          ..._store.modalidadesDisponibles.map(
                            (modalidad) => DropdownMenuItem<String>(
                              value: modalidad,
                              child: Text(modalidad),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _store.filtroArea.isEmpty
                            ? null
                            : _store.filtroArea,
                        onChanged: (value) => _store.setFiltroArea(value ?? ''),
                        decoration: InputDecoration(
                          labelText: 'Área Temática',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: [
                          const DropdownMenuItem<String>(
                            value: '',
                            child: Text('Todas'),
                          ),
                          ..._store.areasDisponibles.map(
                            (area) => DropdownMenuItem<String>(
                              value: area,
                              child: Text(area),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: () {
                        _searchController.clear();
                        _store.limpiarFiltros();
                      },
                      child: const Text('Limpiar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: brandPrimary,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.science_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No se encontraron trabajos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Intenta ajustar los filtros de búsqueda',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildTrabajosList() {
    return Observer(
      builder: (_) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _store.trabajosFiltrados.length,
        itemBuilder: (context, index) {
          final trabajo = _store.trabajosFiltrados[index];
          return _TrabajoCard(
            trabajo: trabajo,
            onTap: () => _mostrarDetalleCompleto(trabajo),
            onDescargar: _descargarArchivo,
          );
        },
      ),
    );
  }
}

class _TrabajoCard extends StatelessWidget {
  final TrabajoCientifico trabajo;
  final VoidCallback onTap;
  final Function(String, String) onDescargar;

  const _TrabajoCard({
    required this.trabajo,
    required this.onTap,
    required this.onDescargar,
  });

  String _fmtDate(DateTime? dt) {
    if (dt == null) return 'N/A';
    return DateFormat('dd/MM/yyyy').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmallScreen = constraints.maxWidth < 400;
            return Padding(
              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header con título y modalidad
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              trabajo.titulo,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width < 600
                                    ? 14
                                    : 16,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1F2937),
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF387f4d).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                trabajo.modalidad,
                                style: const TextStyle(
                                  color: Color(0xFF387f4d),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.chevron_right, color: Colors.grey[400]),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Información del autor
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isSmallScreen = constraints.maxWidth < 400;
                      return Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.person,
                              size: isSmallScreen ? 14 : 16,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  trabajo.autorNombre,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: isSmallScreen ? 13 : 14,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  trabajo.autorEmail,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: isSmallScreen ? 11 : 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const Divider(height: 24),

                  // Información adicional en chips
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isSmallScreen = constraints.maxWidth < 400;
                      return Wrap(
                        spacing: isSmallScreen ? 4 : 8,
                        runSpacing: isSmallScreen ? 4 : 8,
                        children: [
                          _InfoChip(
                            icon: Icons.category,
                            label: trabajo.areaTematica,
                            color: Colors.purple,
                            isCompact: isSmallScreen,
                          ),
                          _InfoChip(
                            icon: Icons.medical_services,
                            label: trabajo.areaDeLaMedicina,
                            color: Colors.orange,
                            isCompact: isSmallScreen,
                          ),
                          _InfoChip(
                            icon: Icons.schedule,
                            label: 'Reg: ${_fmtDate(trabajo.fechaRegistro)}',
                            color: Colors.green,
                            isCompact: isSmallScreen,
                          ),
                          if (trabajo.coautores.isNotEmpty)
                            _InfoChip(
                              icon: Icons.group,
                              label: '${trabajo.coautores.length} coautores',
                              color: Colors.blue,
                              isCompact: isSmallScreen,
                            ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 12),

                  // Archivos disponibles con botones de descarga
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isSmallScreen = constraints.maxWidth < 400;

                      if (isSmallScreen) {
                        // Layout vertical para móvil
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                if (trabajo.archivoWordUrl.isNotEmpty)
                                  Expanded(
                                    child: _DownloadButton(
                                      onTap: () => onDescargar(
                                        trabajo.archivoWordUrl,
                                        '${trabajo.titulo}_trabajo.docx',
                                      ),
                                      label: 'Word',
                                      color: Colors.blue,
                                      isCompact: true,
                                    ),
                                  ),
                                if (trabajo.archivoWordUrl.isNotEmpty &&
                                    trabajo.archivoPdfUrl != null &&
                                    trabajo.archivoPdfUrl!.isNotEmpty)
                                  const SizedBox(width: 8),
                                if (trabajo.archivoPdfUrl != null &&
                                    trabajo.archivoPdfUrl!.isNotEmpty)
                                  Expanded(
                                    child: _DownloadButton(
                                      onTap: () => onDescargar(
                                        trabajo.archivoPdfUrl!,
                                        '${trabajo.titulo}_trabajo.pdf',
                                      ),
                                      label: 'PDF',
                                      color: Colors.red,
                                      isCompact: true,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tocar para descargar • Ver detalles completos',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      } else {
                        // Layout horizontal para desktop/tablet
                        return Row(
                          children: [
                            if (trabajo.archivoWordUrl.isNotEmpty)
                              _DownloadButton(
                                onTap: () => onDescargar(
                                  trabajo.archivoWordUrl,
                                  '${trabajo.titulo}_trabajo.docx',
                                ),
                                label: 'Word',
                                color: Colors.blue,
                              ),
                            if (trabajo.archivoWordUrl.isNotEmpty &&
                                trabajo.archivoPdfUrl != null &&
                                trabajo.archivoPdfUrl!.isNotEmpty)
                              const SizedBox(width: 8),
                            if (trabajo.archivoPdfUrl != null &&
                                trabajo.archivoPdfUrl!.isNotEmpty)
                              _DownloadButton(
                                onTap: () => onDescargar(
                                  trabajo.archivoPdfUrl!,
                                  '${trabajo.titulo}_trabajo.pdf',
                                ),
                                label: 'PDF',
                                color: Colors.red,
                              ),
                            const Spacer(),
                            Flexible(
                              child: Text(
                                'Descargar archivos • Ver detalles',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                  fontStyle: FontStyle.italic,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        );
                      }
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
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isCompact;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isCompact ? 6 : 8,
        vertical: isCompact ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(isCompact ? 8 : 12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isCompact ? 12 : 14, color: color),
          SizedBox(width: isCompact ? 3 : 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: isCompact ? 10 : 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _DownloadButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final Color color;
  final bool isCompact;

  const _DownloadButton({
    required this.onTap,
    required this.label,
    required this.color,
    this.isCompact = false,
  });

  Color get _lightColor {
    if (color == Colors.blue) return Colors.blue[50]!;
    if (color == Colors.red) return Colors.red[50]!;
    return color.withOpacity(0.1);
  }

  Color get _borderColor {
    if (color == Colors.blue) return Colors.blue[200]!;
    if (color == Colors.red) return Colors.red[200]!;
    return color.withOpacity(0.3);
  }

  Color get _darkColor {
    if (color == Colors.blue) return Colors.blue[700]!;
    if (color == Colors.red) return Colors.red[700]!;
    return color;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(isCompact ? 8 : 12),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isCompact ? 6 : 8,
            vertical: isCompact ? 3 : 4,
          ),
          decoration: BoxDecoration(
            color: _lightColor,
            borderRadius: BorderRadius.circular(isCompact ? 8 : 12),
            border: Border.all(color: _borderColor),
          ),
          child: Row(
            mainAxisSize: isCompact ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.download,
                size: isCompact ? 12 : 14,
                color: _darkColor,
              ),
              SizedBox(width: isCompact ? 3 : 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: isCompact ? 10 : 12,
                  color: _darkColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
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
      if (kIsWeb) {
        final fileInfo = await js.getFileInfo(widget.url);
        setState(() {
          _tamanhoArchivo = fileInfo['size'] ?? 0;
          _estado = 'Preparando descarga...';
        });
      }

      await _simularProgreso();

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

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
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
