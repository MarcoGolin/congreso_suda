import 'package:congreso_evento/modules/trabajo_cientifico/models/trabajo_cientifico.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalleTrabajoCientificoPage extends StatelessWidget {
  final TrabajoCientifico trabajo;

  const DetalleTrabajoCientificoPage({
    super.key,
    required this.trabajo,
  });

  String _fmtDate(DateTime? dt) {
    if (dt == null) return 'N/A';
    return DateFormat('dd/MM/yyyy HH:mm').format(dt);
  }

  /// Construye la URL completa de Supabase a partir del path almacenado en la BD
  String _construirUrlSupabase(String pathBD) {
    const baseUrl =
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public';
    // El path ya incluye el bucket, solo agregamos la base
    return '$baseUrl/$pathBD';
  }

  Future<void> _descargarArchivo(String pathBD, String nombreArchivo) async {
    try {
      // Construir URL completa de Supabase
      final urlCompleta = _construirUrlSupabase(pathBD);

      if (kIsWeb) {
        // Mostrar diálogo de descarga con progreso
        await _mostrarDialogoDescarga(urlCompleta, nombreArchivo);
      } else {
        // Para móvil: usar url_launcher
        final uri = Uri.parse(urlCompleta);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          throw 'No se pudo abrir la URL del archivo';
        }
      }
    } catch (e) {
      // Manejar errores - se podría agregar SnackBar aquí
      debugPrint('Error al descargar: $e');
    }
  }

  /// Muestra diálogo de descarga con progreso, tamaño y tiempo estimado
  Future<void> _mostrarDialogoDescarga(String url, String nombreArchivo) async {
    // Implementación del diálogo de descarga
    // Por simplicidad, aquí se podría usar el mismo _DialogoDescarga
    // que ya existe en la página principal
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Detalle del Trabajo Científico',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF387f4d),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con título
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF387f4d).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.science,
                          color: Color(0xFF387f4d),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          trabajo.titulo,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF387f4d).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      trabajo.modalidad,
                      style: const TextStyle(
                        color: Color(0xFF387f4d),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Archivos disponibles - PRIMERO para fácil acceso
            if (trabajo.archivoWordUrl.isNotEmpty ||
                (trabajo.archivoPdfUrl != null && trabajo.archivoPdfUrl!.isNotEmpty))
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF387f4d).withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF387f4d).withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.cloud_download, color: Color(0xFF387f4d)),
                        SizedBox(width: 12),
                        Text(
                          'Descargar Archivos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF387f4d),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (trabajo.archivoWordUrl.isNotEmpty)
                      _ArchivoButton(
                        icono: Icons.description,
                        titulo: 'Documento Word',
                        subtitulo: 'Archivo original del trabajo científico',
                        color: Colors.blue,
                        onTap: () => _descargarArchivo(
                          trabajo.archivoWordUrl,
                          '${trabajo.titulo.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')}_trabajo.docx',
                        ),
                      ),
                    if (trabajo.archivoWordUrl.isNotEmpty &&
                        trabajo.archivoPdfUrl != null &&
                        trabajo.archivoPdfUrl!.isNotEmpty)
                      const SizedBox(height: 12),
                    if (trabajo.archivoPdfUrl != null && trabajo.archivoPdfUrl!.isNotEmpty)
                      _ArchivoButton(
                        icono: Icons.picture_as_pdf,
                        titulo: 'Documento PDF',
                        subtitulo: 'Versión en formato PDF',
                        color: Colors.red,
                        onTap: () => _descargarArchivo(
                          trabajo.archivoPdfUrl!,
                          '${trabajo.titulo.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')}_trabajo.pdf',
                        ),
                      ),
                  ],
                ),
              ),

            if (trabajo.archivoWordUrl.isNotEmpty ||
                (trabajo.archivoPdfUrl != null && trabajo.archivoPdfUrl!.isNotEmpty))
              const SizedBox(height: 24),

            // Información del autor
            _SeccionDetalle(
              titulo: 'Información del Autor',
              icono: Icons.person,
              contenido: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetalleRow(label: 'Nombre:', value: trabajo.autorNombre),
                  _DetalleRow(label: 'Email:', value: trabajo.autorEmail),
                  if (trabajo.autorTelefono.isNotEmpty)
                    _DetalleRow(label: 'Teléfono:', value: trabajo.autorTelefono),
                  _DetalleRow(label: 'Filiación:', value: trabajo.autorFiliacion),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Información del trabajo
            _SeccionDetalle(
              titulo: 'Detalles del Trabajo',
              icono: Icons.info,
              contenido: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetalleRow(label: 'Modalidad:', value: trabajo.modalidad),
                  _DetalleRow(label: 'Área temática:', value: trabajo.areaTematica),
                  _DetalleRow(label: 'Área de medicina:', value: trabajo.areaDeLaMedicina),
                  if (trabajo.fechaRegistro != null)
                    _DetalleRow(
                      label: 'Fecha de registro:',
                      value: _fmtDate(trabajo.fechaRegistro!),
                    ),
                  _DetalleRow(
                    label: 'Acepta declaración:',
                    value: trabajo.aceptaDeclaracion == true ? 'Sí' : 'No',
                  ),
                ],
              ),
            ),

            // Resumen si existe
            if (trabajo.resumen != null && trabajo.resumen!.isNotEmpty) ...[
              const SizedBox(height: 20),
              _SeccionDetalle(
                titulo: 'Resumen',
                icono: Icons.description,
                contenido: Text(
                  trabajo.resumen!,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.6,
                    color: Color(0xFF374151),
                  ),
                ),
              ),
            ],

            // Coautores si existen
            if (trabajo.coautores.isNotEmpty) ...[
              const SizedBox(height: 20),
              _SeccionDetalle(
                titulo: 'Coautores (${trabajo.coautores.length})',
                icono: Icons.group,
                contenido: Column(
                  children: trabajo.coautores.map((coautor) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _DetalleRow(label: 'Nombre:', value: coautor.nombre),
                          _DetalleRow(label: 'Email:', value: coautor.email),
                          _DetalleRow(label: 'Filiación:', value: coautor.filiacion ?? 'N/A'),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SeccionDetalle extends StatelessWidget {
  final String titulo;
  final IconData icono;
  final Widget contenido;

  const _SeccionDetalle({
    required this.titulo,
    required this.icono,
    required this.contenido,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icono, size: 24, color: const Color(0xFF387f4d)),
              const SizedBox(width: 12),
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF387f4d),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          contenido,
        ],
      ),
    );
  }
}

class _ArchivoButton extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String subtitulo;
  final Color color;
  final VoidCallback onTap;

  const _ArchivoButton({
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icono, color: color, size: 28),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitulo,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.download,
                      color: Colors.white,
                      size: 18,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Descargar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
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

class _DetalleRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetalleRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF111827),
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
