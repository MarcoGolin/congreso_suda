import 'package:congreso_evento/modules/trabajo_cientifico/pages/widgets/trabajo_cientifico_pagina_coautor.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/pages/widgets/trabajo_cientifico_pagina_detalles.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'widgets/trabajo_cientifico_pagina_autor.dart';

class TrabajoCientificoRegistro extends StatefulWidget {
  const TrabajoCientificoRegistro({super.key});

  @override
  State<TrabajoCientificoRegistro> createState() =>
      _TrabajoCientificoRegistroState();
}

class _TrabajoCientificoRegistroState extends State<TrabajoCientificoRegistro> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _aceptaDeclaracion = false;
  bool _formIsValid = false;

  final _autorNombre = TextEditingController();
  final _autorEmail = TextEditingController();
  final _autorTelefono = TextEditingController();

  final _coautoresNombre = TextEditingController();
  final _coautoresEmail = TextEditingController();

  final _tituloTrabajo = TextEditingController();
  final _resumen = TextEditingController();
  String? _modalidad;
  String? _area;

  PlatformFile? _archivoWord;
  PlatformFile? _archivoPdf;

  final _autorFormKey = GlobalKey<FormState>();

  final List<Map<String, dynamic>> _coautores = [
    {
      'nombre': TextEditingController(),
      'email': TextEditingController(),
      'filiacion': null, // valor seleccionado en el dropdown
      'filiacionOtro':
          TextEditingController(), // para texto libre si selecciona "Otros"
    },
  ];

  final List<String> _filiacionesDisponibles = [
    'Universidad Sudamericana, Facultad de Ciencias de la Salud, Saltos del Guairá, Paraguay',
    'Otros',
  ];

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _autorNombre.dispose();
    _autorEmail.dispose();
    _autorTelefono.dispose();

    _coautoresNombre.dispose();
    _coautoresEmail.dispose();

    _tituloTrabajo.dispose();
    _resumen.dispose();

    _pageController.dispose();

    // Dispose de todos los controladores de coautores
    for (final coautor in _coautores) {
      (coautor['nombre'] as TextEditingController).dispose();
      (coautor['email'] as TextEditingController).dispose();
      (coautor['filiacionOtro'] as TextEditingController).dispose();
    }

    // Limpieza de variables no controladas
    _archivoWord = null;
    _archivoPdf = null;
    _modalidad = null;
    _area = null;

    _formKey.currentState?.reset();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = const Color(0xFF0C4793);
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/imagenes/fondo/fondo_inicio.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: textColor),
          ),
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,

          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 15,
              ),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white.withOpacity(0.95),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            'Carga de Trabajo Científico',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0C4793),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: PageView(
                              controller: _pageController,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                TrabajoCientificoPaginaAutor(
                                  formKey: _autorFormKey,
                                  autorNombreTXTCTRL: _autorNombre,
                                  autorEmailTXTCTRL: _autorEmail,
                                  autorTelefonoTXTCTRL: _autorTelefono,
                                  onChanged: () {
                                    _checkValidForm(); // 👈 recalcula si el botón debe estar habilitado
                                  },
                                ),
                                TrabajoCientificoPaginaCoautor(
                                  coautores: _coautores,
                                  filiacionesDisponibles:
                                      _filiacionesDisponibles,
                                  onFiliacionChanged: (v, index) {
                                    setState(() {
                                      _coautores[index]['filiacion'] = v;
                                    });
                                  },
                                  onRemoveCoautor: (index) {
                                    setState(() {
                                      _coautores.removeAt(index);
                                    });
                                  },
                                  addNuevoCoautor: () => setState(() {
                                    _coautores.add({
                                      'nombre': TextEditingController(),
                                      'email': TextEditingController(),
                                      'filiacion': null,
                                      'filiacionOtro': TextEditingController(),
                                    });
                                  }),
                                ),
                                TrabajoCientificoPaginaDetalles(
                                  tituloTrabajo: _tituloTrabajo,
                                  resumen: _resumen,
                                  modalidad: _modalidad,
                                  area: _area,
                                  modalidades: _modalidades,
                                  areas: _areas,
                                  onModadilidadChanged: (v) {
                                    setState(() => _modalidad = v);
                                  },
                                  onAreaChanged: (v) {
                                    setState(() => _area = v);
                                  },
                                ),
                                _paginaArchivos(),
                                _paginaDeclaracion(),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                if (_currentPage > 0)
                                  TextButton(
                                    onPressed: () {
                                      FocusScope.of(
                                        context,
                                      ).unfocus(); // cerrar teclado
                                      setState(() => _currentPage--);
                                      _pageController.animateToPage(
                                        _currentPage,
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: const Text(
                                        'Atrás'
                                        ' ',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF0C4793),
                                        ),
                                      ),
                                    ),
                                  ),
                                const Spacer(),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    backgroundColor: const Color(0xFF0C4793),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: _formIsValid
                                      ? _validarYAvanzar
                                      : null,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      _currentPage == 4
                                          ? 'Enviar'
                                          : 'Siguiente',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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

  Widget _paginaArchivos() => ListView(
    padding: const EdgeInsets.fromLTRB(0, 8, 0, 16), // 👈 ajustá como necesites
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
  );

  Widget _paginaDeclaracion() => ListView(
    padding: const EdgeInsets.fromLTRB(0, 8, 0, 16), // 👈 ajustá como necesites
    children: [
      const Text(
        'Declaro que el trabajo enviado es original, no ha sido publicado ni enviado a ningún otro evento o revista, y que todos los autores han aprobado esta versión del manuscrito.',
        style: TextStyle(fontSize: 14),
      ),
      CheckboxListTile(
        value: _aceptaDeclaracion,
        onChanged: (v) => setState(() => _aceptaDeclaracion = v ?? false),
        title: const Text('Acepto la declaración de originalidad'),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    ],
  );

  void _validarYAvanzar() {
    FocusScope.of(context).unfocus();

    if (_currentPage < 4) {
      setState(() => _currentPage++);
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _checkValidForm(); // 👈 recalcula si el botón debe estar habilitado
    } else {
      _enviarFormulario();
    }
  }

  void _checkValidForm() {
    // Solo valida los campos visibles según la página actual
    bool isValid = false;
    switch (_currentPage) {
      case 0: // Página autor
        isValid = _autorFormKey.currentState?.validate() ?? false;
        break;
      case 1: // Coautores
        isValid = true; // O validación personalizada
        break;
      case 2: // Detalles del trabajo
        isValid =
            _tituloTrabajo.text.isNotEmpty &&
            _resumen.text.isNotEmpty &&
            _modalidad != null &&
            _area != null;
        break;
      case 3: // Archivos
        isValid = _archivoWord != null;
        break;
      case 4: // Declaración
        isValid = _aceptaDeclaracion;
        break;
    }
    setState(() {
      _formIsValid = isValid;
    });
  }
}
