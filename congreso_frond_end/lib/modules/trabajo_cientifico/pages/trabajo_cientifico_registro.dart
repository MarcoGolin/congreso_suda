import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class TrabajoCientificoRegistro extends StatefulWidget {
  const TrabajoCientificoRegistro({super.key});

  @override
  State<TrabajoCientificoRegistro> createState() =>
      _TrabajoCientificoRegistroState();
}

class _TrabajoCientificoRegistroState extends State<TrabajoCientificoRegistro> {
  int _currentStep = 0;
  final _formKey = GlobalKey<FormState>();
  bool _aceptaDeclaracion = false;

  final _autorNombre = TextEditingController();
  final _autorEmail = TextEditingController();
  final _autorTelefono = TextEditingController();

  final _coautoresNombre = TextEditingController();
  final _coautoresEmail = TextEditingController();
  final _filiacion = TextEditingController();

  final _tituloTrabajo = TextEditingController();
  final _resumen = TextEditingController();
  String? _modalidad;
  String? _area;

  PlatformFile? _archivoWord;
  PlatformFile? _archivoPdf;

  final _modalidades = [
    'Artículo original de investigación',
    'Artículo de revisión bibliográfica',
    'Caso clínico',
    'Resumen en modalidad póster',
  ];

  final _areas = [
    'Pediatría',
    'Salud mental',
    'Cirugía',
    'Medicina interna',
    'Ginecología',
    'Otro',
  ];

  Future<void> _seleccionarArchivoWord() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['doc', 'docx'],
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() => _archivoWord = result.files.first);
    }
  }

  Future<void> _seleccionarArchivoPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() => _archivoPdf = result.files.first);
    }
  }

  void _enviarFormulario() {
    if (_formKey.currentState!.validate() &&
        _archivoWord != null &&
        _aceptaDeclaracion) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Formulario enviado correctamente')),
      );
    } else {
      if (_archivoWord == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Debes subir el archivo Word obligatorio'),
          ),
        );
      }
    }
  }

  InputDecoration _inputStyle(String label) => InputDecoration(
    labelText: label,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    filled: true,
    fillColor: const Color(0xFFF9FAFB),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  );

  @override
  Widget build(BuildContext context) {
    final textColor = const Color(0xFF0C4793);

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/imagenes/fondo/fondo_inicio.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: textColor),
            title: const Text(
              'Registro de Trabajo Científico',
              style: TextStyle(
                color: Color(0xFF0C4793),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Colors.white.withOpacity(0.95),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Stepper(
                      currentStep: _currentStep,
                      onStepContinue: () {
                        if (_currentStep < 4) {
                          setState(() => _currentStep++);
                        } else {
                          _enviarFormulario();
                        }
                      },
                      onStepCancel: () {
                        if (_currentStep > 0) {
                          setState(() => _currentStep--);
                        }
                      },
                      controlsBuilder: (context, details) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: details.onStepCancel,
                            child: const Text('Atrás'),
                          ),
                          ElevatedButton(
                            onPressed: details.onStepContinue,
                            child: Text(
                              _currentStep == 4 ? 'Enviar' : 'Siguiente',
                            ),
                          ),
                        ],
                      ),
                      steps: [
                        Step(
                          title: const Text('Autor principal'),
                          content: Column(
                            children: [
                              TextFormField(
                                controller: _autorNombre,
                                decoration: _inputStyle('Nombre completo'),
                                validator: (v) => v == null || v.isEmpty
                                    ? 'Campo requerido'
                                    : null,
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _autorEmail,
                                decoration: _inputStyle('Correo electrónico'),
                                validator: (v) => v == null || !v.contains('@')
                                    ? 'Email inválido'
                                    : null,
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _autorTelefono,
                                decoration: _inputStyle('Teléfono (WhatsApp)'),
                                validator: (v) => v == null || v.length < 8
                                    ? 'Número inválido'
                                    : null,
                              ),
                            ],
                          ),
                          isActive: _currentStep >= 0,
                        ),
                        Step(
                          title: const Text('Coautores'),
                          content: Column(
                            children: [
                              TextFormField(
                                controller: _coautoresNombre,
                                decoration: _inputStyle(
                                  'Nombres coautores (opcional)',
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _coautoresEmail,
                                decoration: _inputStyle(
                                  'Correos coautores (opcional)',
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _filiacion,
                                decoration: _inputStyle(
                                  'Filiación institucional',
                                ),
                                validator: (v) => v == null || v.isEmpty
                                    ? 'Campo requerido'
                                    : null,
                              ),
                            ],
                          ),
                          isActive: _currentStep >= 1,
                        ),
                        Step(
                          title: const Text('Detalles del trabajo'),
                          content: Column(
                            children: [
                              TextFormField(
                                controller: _tituloTrabajo,
                                decoration: _inputStyle('Título del trabajo'),
                                validator: (v) => v == null || v.isEmpty
                                    ? 'Campo requerido'
                                    : null,
                              ),
                              const SizedBox(height: 10),
                              DropdownButtonFormField<String>(
                                value: _modalidad,
                                decoration: _inputStyle('Modalidad'),
                                items: _modalidades
                                    .map(
                                      (m) => DropdownMenuItem(
                                        value: m,
                                        child: Text(m),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) =>
                                    setState(() => _modalidad = v),
                                validator: (v) => v == null
                                    ? 'Seleccione una modalidad'
                                    : null,
                              ),
                              const SizedBox(height: 10),
                              DropdownButtonFormField<String>(
                                value: _area,
                                decoration: _inputStyle('Área temática'),
                                items: _areas
                                    .map(
                                      (a) => DropdownMenuItem(
                                        value: a,
                                        child: Text(a),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) => setState(() => _area = v),
                                validator: (v) => v == null
                                    ? 'Seleccione un área temática'
                                    : null,
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _resumen,
                                maxLines: 5,
                                decoration: _inputStyle(
                                  'Resumen breve (opcional)',
                                ),
                              ),
                            ],
                          ),
                          isActive: _currentStep >= 2,
                        ),
                        Step(
                          title: const Text('Subida de archivos'),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ElevatedButton(
                                onPressed: _seleccionarArchivoWord,
                                child: Text(
                                  _archivoWord == null
                                      ? 'Subir archivo Word (.docx) *'
                                      : 'Archivo Word: ${_archivoWord!.name}',
                                ),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: _seleccionarArchivoPdf,
                                child: Text(
                                  _archivoPdf == null
                                      ? 'Subir archivo PDF (opcional)'
                                      : 'Archivo PDF: ${_archivoPdf!.name}',
                                ),
                              ),
                            ],
                          ),
                          isActive: _currentStep >= 3,
                        ),
                        Step(
                          title: const Text('Declaración'),
                          content: Column(
                            children: [
                              const Text(
                                'Declaro que el trabajo enviado es original, no ha sido publicado ni enviado a ningún otro evento o revista, y que todos los autores han aprobado esta versión del manuscrito.',
                                style: TextStyle(fontSize: 14),
                              ),
                              CheckboxListTile(
                                value: _aceptaDeclaracion,
                                onChanged: (v) => setState(
                                  () => _aceptaDeclaracion = v ?? false,
                                ),
                                title: const Text(
                                  'Acepto la declaración de originalidad',
                                ),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                              ),
                            ],
                          ),
                          isActive: _currentStep >= 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
