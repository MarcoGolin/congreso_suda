import 'package:congreso_evento/modules/home_admin/pages/trabajos_cientificos/helpers/trabajo_cientifico_helpers.dart';
import 'package:congreso_evento/modules/home_admin/pages/trabajos_cientificos/stores/admin_trabajos_cientificos_store.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/models/trabajo_cientifico.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class DetalleTrabajoCientificoPage extends StatefulWidget {
  final TrabajoCientifico trabajo;

  const DetalleTrabajoCientificoPage({super.key, required this.trabajo});

  @override
  State<DetalleTrabajoCientificoPage> createState() =>
      _DetalleTrabajoCientificoPageState();
}

class _DetalleTrabajoCientificoPageState
    extends State<DetalleTrabajoCientificoPage> {
  final _store = Modular.get<AdminTrabajosCientificosStore>();

  static const brandPrimary = Color(0xFF387f4d);
  static const brandGreyTitle = Color(0xFF1F2937);

  late String _estado; // estado local para reflejar cambios

  final List<String> _estadosDisponibles = const [
    'Recibido',
    'En revisión',
    'Observado',
    'Aceptado',
    'Rechazado',
  ];

  @override
  void initState() {
    super.initState();
    _estado = (widget.trabajo.estado ?? '').trim();
  }

  String _fmtDate(DateTime? dt) {
    if (dt == null) return 'N/A';
    return DateFormat('dd/MM/yyyy HH:mm').format(dt);
  }

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
        final uri = Uri.parse(urlCompleta);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          throw 'No se pudo abrir la URL del archivo';
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al descargar: $e')));
    }
  }

  Future<void> _mostrarDialogoDescarga(String url, String nombreArchivo) async {
    // Reutiliza tu _DialogoDescarga si lo tienes en otra página
  }

  Future<void> _confirmEliminar(TrabajoCientifico t) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar trabajo'),
        content: Text(
          '¿Seguro que deseas eliminar “${t.titulo}”? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (ok == true) {
      await _store.cancelar(t.id!); // mantener nombre de tu Store
      if (!mounted) return;
      Modular.to.pop(); // volver a la lista
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Trabajo eliminado'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _cambiarEstado(String nuevo) async {
    await _store.cambiarEstado(widget.trabajo.id!, nuevo);
    if (!mounted) return;
    setState(() => _estado = nuevo);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Estado cambiado a $nuevo'),
        backgroundColor: brandPrimary,
      ),
    );
  }

  Widget _chip({required String texto, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        texto,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  InputDecoration _estadoInputDecoration(Color accent) => InputDecoration(
    labelText: 'Cambiar estado',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: accent.withOpacity(0.25)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: accent, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  );

  Widget _estadoChip(EstadoStyle s) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: s.color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: s.color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(s.icon, size: 14, color: s.color),
          const SizedBox(width: 6),
          Text(
            s.label,
            style: TextStyle(
              color: s.color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trabajo = widget.trabajo;

    final style = estadoStyleFor(_estado);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Detalle del Trabajo Científico',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: brandPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        // 👇 sin acciones aquí; van al final
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con título + chips de estado/aprobado
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
                // Degradé suave según estado
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [style.color.withOpacity(0.06), Colors.white],
                ),
                color: Colors.white, // fallback
              ),
              child: Stack(
                children: [
                  // Barra lateral de estado
                  Positioned.fill(
                    left: 0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 6,
                        decoration: BoxDecoration(
                          color: style.color,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: brandPrimary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.science,
                                color: brandPrimary,
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
                                  color: brandGreyTitle,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _chip(
                              texto: trabajo.modalidad,
                              color: brandPrimary,
                            ),
                            _estadoChip(
                              style,
                            ), // 👈 chip de estado con ícono y color
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Descargas
            if (trabajo.archivoWordUrl.isNotEmpty ||
                (trabajo.archivoPdfUrl != null &&
                    trabajo.archivoPdfUrl!.isNotEmpty))
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: brandPrimary.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: brandPrimary.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.cloud_download, color: brandPrimary),
                        SizedBox(width: 12),
                        Text(
                          'Descargar Archivos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: brandPrimary,
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
                    if (trabajo.archivoPdfUrl != null &&
                        trabajo.archivoPdfUrl!.isNotEmpty)
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
                (trabajo.archivoPdfUrl != null &&
                    trabajo.archivoPdfUrl!.isNotEmpty))
              const SizedBox(height: 24),

            // Autor
            _SeccionDetalle(
              titulo: 'Información del Autor',
              icono: Icons.person,
              contenido: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetalleRow(label: 'Nombre:', value: trabajo.autorNombre),
                  _DetalleRow(label: 'Email:', value: trabajo.autorEmail),
                  if (trabajo.autorTelefono.isNotEmpty)
                    _DetalleRow(
                      label: 'Teléfono:',
                      value: trabajo.autorTelefono,
                    ),
                  _DetalleRow(
                    label: 'Filiación:',
                    value: trabajo.autorFiliacion,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Detalles del trabajo
            _SeccionDetalle(
              titulo: 'Detalles del Trabajo',
              icono: Icons.info,
              contenido: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetalleRow(label: 'Modalidad:', value: trabajo.modalidad),
                  _DetalleRow(
                    label: 'Área temática:',
                    value: trabajo.areaTematica,
                  ),
                  _DetalleRow(
                    label: 'Área de medicina:',
                    value: trabajo.areaDeLaMedicina,
                  ),
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

            // Resumen
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

            // Coautores
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
                          _DetalleRow(
                            label: 'Filiación:',
                            value: coautor.filiacion ?? 'N/A',
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // ======= ACCIONES (al final) =======
            _SeccionDetalle(
              titulo: 'Acciones',
              icono: Icons.checklist,
              contenido: LayoutBuilder(
                builder: (context, c) {
                  final isSmall = c.maxWidth < 520;
                  if (isSmall) {
                    // Column (mobile)
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 12),
                        // Cambiar estado
                        DropdownButtonFormField<String>(
                          value: _estado.isEmpty ? null : _estado,
                          decoration: InputDecoration(
                            labelText: 'Cambiar estado',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                          ),
                          items: [
                            const DropdownMenuItem(
                              value: '',
                              child: Text('— Seleccionar —'),
                            ),
                            ..._estadosDisponibles.map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            ),
                          ],
                          onChanged: (v) {
                            if (v == null || v.isEmpty) return;
                            _cambiarEstado(v);
                          },
                        ),
                        const SizedBox(height: 12),
                        // Eliminar
                        ElevatedButton.icon(
                          onPressed: () => _confirmEliminar(trabajo),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.delete_outline),
                          label: const Text('Eliminar trabajo'),
                        ),
                      ],
                    );
                  }

                  // Row (desktop/tablet)
                  return Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _estado.isEmpty ? null : _estado,
                          decoration: _estadoInputDecoration(style.color),
                          items: [
                            const DropdownMenuItem(
                              value: '',
                              child: Text('— Seleccionar —'),
                            ),
                            ..._estadosDisponibles.map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            ),
                          ],
                          onChanged: (v) {
                            if (v == null || v.isEmpty) return;
                            _cambiarEstado(v);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      SizedBox(
                        width: 220,
                        child: ElevatedButton.icon(
                          onPressed: () => _confirmEliminar(trabajo),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 25),
                          ),
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Eliminar',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

// ======= Widgets reutilizables =======

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
    const brandPrimary = _DetalleConst.brandPrimary;

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
              Icon(icono, size: 24, color: brandPrimary),
              const SizedBox(width: 12),
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: brandPrimary,
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
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
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
                    Icon(Icons.download, color: Colors.white, size: 18),
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

class _AprobadoTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _AprobadoTile({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const brandPrimary = _DetalleConst.brandPrimary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified, color: brandPrimary),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Aprobado',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Switch(
            value: value,
            activeColor: Colors.white,
            activeTrackColor: brandPrimary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _DetalleConst {
  static const brandPrimary = Color(0xFF387f4d);
}
