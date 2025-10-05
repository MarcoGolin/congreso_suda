import 'dart:io';

import 'package:congreso_evento/core/behahavior/custom_scroll_behavior.dart';
import 'package:congreso_evento/core/loader_overlau.dart';
import 'package:congreso_evento/core/notifiier/default_state_notififier.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/models/coautor.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/models/trabajo_cientifico.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/pages/trabajo_cientifico_registro_ctrl.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/pages/widgets/trabajo_cientifico_pagina_coautor.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/pages/widgets/trabajo_cientifico_pagina_detalles.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/pages/widgets/trabajo_cientifico_success_screen_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'widgets/trabajo_cientifico_pagina_autor.dart';

String _stripDiacriticsBasic(String s) {
  const from = 'áàäâãÁÀÄÂÃéèëêÉÈËÊíìïîÍÌÏÎóòöôõÓÒÖÔÕúùüûÚÙÜÛñÑçÇ';
  const to = 'aaaaaAAAAAeeeeEEEEiiiiIIIIoooooOOOOOuuuuUUUUnNcC';
  return s.split('').map((ch) {
    final i = from.indexOf(ch);
    return i >= 0 ? to[i] : ch;
  }).join();
}

String _sanitizeForStorage(String input) {
  final s = _stripDiacriticsBasic(input);
  return s
      .trim()
      .replaceAll(
        RegExp(r'[\\?#\[\]@!$&\()*+,;=]'),
        '_',
      ) // símbolos conflictivos
      .replaceAll(RegExp(r'\s+'), '_') // espacios -> _
      .replaceAll(RegExp(r'/+'), '/') // colapsar slashes
      .replaceAll('..', '.') // evitar ".."
      .replaceAll(RegExp(r'^/+|/+$'), ''); // sin slash al inicio/fin
}

String _contentTypeFor(String fileName) {
  final ext = fileName.split('.').last.toLowerCase();
  switch (ext) {
    case 'pdf':
      return 'application/pdf';
    case 'doc':
      return 'application/msword';
    case 'docx':
      return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
    default:
      return 'application/octet-stream';
  }
}

class TrabajoCientificoRegistro extends StatefulWidget {
  const TrabajoCientificoRegistro({super.key});

  @override
  State<TrabajoCientificoRegistro> createState() =>
      _TrabajoCientificoRegistroState();
}

class _TrabajoCientificoRegistroState extends State<TrabajoCientificoRegistro> {
  final _ctrl = Modular.get<TrabajoCientificoRegistroCtrl>();
  final LoadingOverlay _loadingOverlay =
      LoadingOverlay(); // Instancia del overlay
  final _pageController = PageController();
  int _currentPage = 0;
  bool _aceptaDeclaracion = false;
  bool _formIsValid = false;

  final _autorNombreTXTCTRL = TextEditingController();
  final _autorEmail = TextEditingController();
  final _autorTelefono = TextEditingController();
  final _filiacionXTCTRL = TextEditingController();
  final _filiacionOtrosXTCTRL = TextEditingController();
  String? _filiacionSelected;

  final _coautoresNombre = TextEditingController();
  final _coautoresEmail = TextEditingController();

  final _tituloTrabajoTXTCTRL = TextEditingController();
  final _resumen = TextEditingController();
  String? _modalidad;
  String? _areaTematica;
  String? _areaDeLaMedicina;

  String? _archivoWord;
  String? _nameArchivoWord;
  String? _archivoPdf;
  String? _nameArchivoPdf;

  final _autorFormKey = GlobalKey<FormState>();
  final _coautorFormKey = GlobalKey<FormState>();
  final _detallesFormKey = GlobalKey<FormState>();

  final supabase = Supabase.instance.client;

  late ReactionDisposer _rctDsp;

  var _loadingWord = false;
  var _loadingPdf = false;

  final List<Map<String, dynamic>> _coautores = [
    {
      'nombre': TextEditingController(),
      'email': TextEditingController(),
      'filiacion': null, // valor seleccionado en el dropdown
      'filiacionOtro':
          TextEditingController(), // para texto libre si selecciona "Otros"
    },
    {
      'nombre': TextEditingController(),
      'email': TextEditingController(),
      'filiacion': null,
      'filiacionOtro': TextEditingController(),
    },

    {
      'nombre': TextEditingController(),
      'email': TextEditingController(),
      'filiacion': null,
      'filiacionOtro': TextEditingController(),
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

  final _areasTematicas = [
    'Monitoreo y Análisis de la Situación de Salud – Estudios de situación de salud, acceso, cobertura y calidad de los servicios sanitarios',
    'Vigilancia Epidemiológica en Salud Pública – Control de riesgos y daños, enfermedades transmisibles y no transmisibles, bioseguridad y bioterrorismo',
    'Promoción de la Salud, Participación Social y Empoderamiento Ciudadano – Estrategias de promoción, determinantes sociales, estilos de vida, políticas públicas, calidad de vida y participación comunitaria',
    'Innovaciones en las Investigaciones Biomédicas – Nuevas vacunas, genética, genómica, epidemiología molecular, biobancos, telemedicina y tecnologías biomédicas aplicadas',
    'Ética en la Investigación en Salud – Principios bioéticos, consentimiento informado, comités de ética, evaluación ética de instituciones y proyectos',
    'Investigación en Salud Mental – Depresión, suicidio, adicciones, violencia, consumo de sustancias, salud mental en poblaciones vulnerables',
    'Tecnologías de la Información y la Comunicación en Salud (TICs) – Procesamiento y gestión de datos, seguridad de la información, sistemas digitales aplicados al ámbito sanitario',
    'Tecnologías Biomédicas – Evaluación de dispositivos médicos, calidad, eficacia y seguridad de tecnologías sanitarias, biotecnología en salud',
    'Salud Internacional y Salud de Fronteras – Cooperación internacional, vigilancia en zonas fronterizas, inequidades y asimetrías en salud, impacto de la globalización y cambio climático',
  ];

  /// Áreas de la Medicina
  final _areasDeLaMedicina = [
    'Medicina Interna – Incluye cardiología, neumología, gastroenterología, endocrinología, reumatología, nefrología',
    'Pediatría y Neonatología – Salud infantil, neonatología, nutrición pediátrica e infectología pediátrica',
    'Ginecología y Obstetricia – Obstetricia, salud materno-fetal, salud reproductiva, oncología ginecológica',
    'Cirugía – Cirugía general, mínimamente invasiva, traumatología, ortopedia y cirugía reconstructiva',
    'Urgencias y Emergencias – Trauma, cuidados críticos, medicina de emergencias y desastres',
    'Psiquiatría y Salud Mental – Trastornos mentales, adicciones, psiquiatría infantil y psicología médica',
    'Medicina Preventiva y Salud Pública – Epidemiología, políticas de salud, promoción y programas preventivos',
    'Medicina Familiar y Comunitaria – Atención primaria, enfoque integral del paciente, salud ocupacional',
    'Neurología y Neurociencias – Neurología clínica, neurocirugía, neuropsiquiatría, neurociencias básicas',
    'Oncología y Hematología – Cáncer, terapias dirigidas, hematología clínica y experimental',
    'Dermatología – Dermatología clínica, oncología cutánea y enfermedades infecciosas de la piel',
    'Infectología – Enfermedades transmisibles, resistencia antimicrobiana, zoonosis y enfermedades emergentes',
    'Anestesiología y Cuidados Intensivos – Anestesia, manejo del dolor, cuidados intensivos',
    'Rehabilitación y Medicina Física – Fisioterapia, rehabilitación postquirúrgica y neurológica',
    'Ciencias Básicas en Salud – Anatomía, fisiología, bioquímica, farmacología, microbiología',
  ];

  Future<void> _seleccionarArchivoWord() async {
    setState(() => _loadingWord = true);
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['doc', 'docx'],
      withData: kIsWeb, // asegura bytes en web
    );

    String? filePath;
    String? fileName;

    if (result != null && result.files.isNotEmpty) {
      final picked = result.files.first;
      final titulo = _sanitizeForStorage(_tituloTrabajoTXTCTRL.text);
      final original = _sanitizeForStorage(picked.name);
      final epoch = DateTime.now().millisecondsSinceEpoch;

      final key = 'trabajos_cientificos/$titulo/$epoch/$original';
      filePath = await sendToSupabase(key, picked);
      fileName = picked.name;
    }

    setState(() {
      _archivoWord = filePath;
      _nameArchivoWord = fileName;
      _loadingWord = false;
    });
    _checkValidForm();
  }

  Future<void> _seleccionarArchivoPdf() async {
    setState(() => _loadingPdf = true);
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: kIsWeb, // asegura bytes en web
    );

    String? filePath;
    String? fileName;

    if (result != null && result.files.isNotEmpty) {
      final picked = result.files.first;
      final titulo = _sanitizeForStorage(_tituloTrabajoTXTCTRL.text);
      final original = _sanitizeForStorage(picked.name);
      final epoch = DateTime.now().millisecondsSinceEpoch;

      final key = 'trabajos_cientificos/$titulo/$epoch/$original';
      filePath = await sendToSupabase(key, picked);
      fileName = picked.name;
    }

    setState(() {
      _archivoPdf = filePath;
      _nameArchivoPdf = fileName;
      _loadingPdf = false;
    });
    _checkValidForm();
  }

  Future<String> sendToSupabase(String key, PlatformFile file) async {
    final contentType = _contentTypeFor(file.name);

    late final String uploadedKey;
    if (kIsWeb) {
      // En web, asegurate de usar bytes; withData:true arriba
      final bytes = file.bytes!;
      uploadedKey = await supabase.storage
          .from('congreso')
          .uploadBinary(
            key,
            bytes,
            fileOptions: FileOptions(
              upsert: true,
              cacheControl: '3600',
              contentType: contentType,
            ),
          );
    } else {
      final f = File(file.path!);
      final bytes = await f.readAsBytes();
      uploadedKey = await supabase.storage
          .from('congreso')
          .uploadBinary(
            key,
            bytes,
            fileOptions: FileOptions(
              upsert: true,
              cacheControl: '3600',
              contentType: contentType,
            ),
          );
    }
    return uploadedKey; // devuelve la key subida
  }

  void _enviarFormulario() {
    final trabajo = TrabajoCientifico(
      autorNombre: _autorNombreTXTCTRL.text,
      autorEmail: _autorEmail.text,
      autorTelefono: _autorTelefono.text,
      autorFiliacion: _filiacionXTCTRL.text.isEmpty
          ? _filiacionOtrosXTCTRL.text
          : _filiacionXTCTRL.text,
      coautores: _coautores.map((coautor) {
        return Coautor(
          filiacion: coautor['filiacion'] ?? '',
          nombre: coautor['nombre'].text,
          email: coautor['email'].text,
          filiacionOtro: coautor['filiacionOtro'].text.isNotEmpty
              ? coautor['filiacionOtro'].text
              : null,
        );
      }).toList(),
      titulo: _tituloTrabajoTXTCTRL.text,
      resumen: _resumen.text,
      modalidad: _modalidad ?? '',
      areaTematica: _areaTematica ?? '',
      areaDeLaMedicina: _areaDeLaMedicina ?? '',
      archivoWordUrl: _archivoWord ?? '',
      archivoPdfUrl: _archivoPdf,
      aceptaDeclaracion: _aceptaDeclaracion,
      estado: 'En revisión',
    );
    final Future<void> registrationFuture = _ctrl.save(trabajo);

    _loadingOverlay.show(context, registrationFuture);
  }

  @override
  void initState() {
    _capitalizarTexto(_autorNombreTXTCTRL);
    _capitalizarTexto(_tituloTrabajoTXTCTRL);

    for (final coautor in _coautores) {
      _capitalizarTexto(coautor['nombre'] as TextEditingController);
    }

    if (kDebugMode) {
      _autorNombreTXTCTRL.text = 'Juan Pérez';
      _autorEmail.text = 'marcogolin60@gmail.com';
      _autorTelefono.text = '+595 981 234 567';
      _filiacionXTCTRL.text =
          'Universidad Sudamericana, Facultad de Ciencias de la Salud, Saltos del Guairá, Paraguay';
      _filiacionSelected =
          'Universidad Sudamericana, Facultad de Ciencias de la Salud, Saltos del Guairá, Paraguay';

      //cargar datos coautores
      _coautores[0]['nombre'].text = 'Jose López';
      _coautores[0]['email'].text = 'marcogolin60@gmail.com';
      _coautores[0]['filiacion'] =
          'Universidad Sudamericana, Facultad de Ciencias de la Salud, Saltos del Guairá, Paraguay';
      _coautores[0]['filiacionOtro'].text = '';

      //cargar datos coautores
      _coautores[1]['nombre'].text = 'Eduardo López';
      _coautores[1]['email'].text = 'marcogolin60@gmail.com';
      _coautores[1]['filiacion'] =
          'Universidad Sudamericana, Facultad de Ciencias de la Salud, Saltos del Guairá, Paraguay';
      _coautores[1]['filiacionOtro'].text = '';

      //cargar datos coautores
      _coautores[2]['nombre'].text = 'María López';
      _coautores[2]['email'].text = 'marcogolin60@gmail.com';
      _coautores[2]['filiacion'] =
          'Universidad Sudamericana, Facultad de Ciencias de la Salud, Saltos del Guairá, Paraguay';
      _coautores[2]['filiacionOtro'].text = '';

      _tituloTrabajoTXTCTRL.text = 'Estudio sobre la salud infantil';
      _resumen.text =
          'Este es un resumen del trabajo científico que se está presentando.';
      _modalidad = _modalidades[0]; // Artículo original de investigación
      _areaTematica = _areasTematicas[0]; // Pediatría
      _areaDeLaMedicina = _areasDeLaMedicina[0]; // Pediatría
    }

    _rctDsp = reaction((_) => _ctrl.stateClass, (state) {
      switch (state.status) {
        case StatusEnumGlobal.success:
          _loadingOverlay.hide();
          setState(() => _currentPage++);
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          break;
        case StatusEnumGlobal.error:
          _loadingOverlay.hide();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
          break;
        default:
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _checkValidForm();
    });
    super.initState();
  }

  void _capitalizarTexto(TextEditingController controller) {
    controller.addListener(() {
      final text = controller.text;
      if (text.isNotEmpty) {
        final capitalizedText = text
            .split(' ')
            .map(
              (word) => word.isNotEmpty
                  ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                  : '',
            )
            .join(' ');
        if (capitalizedText != text) {
          controller.value = TextEditingValue(
            text: capitalizedText,
            selection: TextSelection.collapsed(offset: capitalizedText.length),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _autorNombreTXTCTRL.dispose();
    _autorEmail.dispose();
    _autorTelefono.dispose();

    _coautoresNombre.dispose();
    _coautoresEmail.dispose();

    _tituloTrabajoTXTCTRL.dispose();
    _resumen.dispose();

    _pageController.dispose();

    _rctDsp();

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
    _areaTematica = null;
    _areaDeLaMedicina = null;

    _autorFormKey.currentState?.reset();
    _coautorFormKey.currentState?.reset();
    _detallesFormKey.currentState?.reset();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = const Color(0xFF387f4d);

    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/imagenes/fondo/fondo.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(
              'Trabajo Científico',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: textColor),
          ),
          backgroundColor: Colors.transparent,
          body: Align(
            alignment: Alignment.topCenter,
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
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Expanded(
                        child: ScrollConfiguration(
                          behavior: CustomScrollBehavior(),
                          child: PageView(
                            controller: _pageController,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              TrabajoCientificoPaginaAutor(
                                formKey: _autorFormKey,
                                autorNombreTXTCTRL: _autorNombreTXTCTRL,
                                autorEmailTXTCTRL: _autorEmail,
                                autorTelefonoTXTCTRL: _autorTelefono,
                                filiacionXTCTRL: _filiacionXTCTRL,
                                filiacionOtrosXTCTRL: _filiacionOtrosXTCTRL,
                                filiacionSelected: _filiacionSelected,
                                onFiliacionChanged: (v) {
                                  setState(() {
                                    _filiacionSelected = v;
                                  });
                                },
                                onChanged: () {
                                  _checkValidForm(); // 👈 recalcula si el botón debe estar habilitado
                                },
                                filiacionesDisponibles: _filiacionesDisponibles,
                              ),
                              TrabajoCientificoPaginaCoautor(
                                coautores: _coautores,
                                filiacionesDisponibles: _filiacionesDisponibles,
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
                                formKey: _detallesFormKey,
                                tituloTrabajo: _tituloTrabajoTXTCTRL,
                                resumen: _resumen,
                                modalidad: _modalidad,
                                areaTematica: _areaTematica,
                                areaDeLaMedicina: _areaDeLaMedicina,
                                modalidades: _modalidades,
                                areasTematicas: _areasTematicas,
                                areasDeLaMedicina: _areasDeLaMedicina,
                                onModadilidadChanged: (v) {
                                  setState(() => _modalidad = v);
                                  _checkValidForm();
                                },
                                onAreaTematicaChanged: (v) {
                                  setState(() => _areaTematica = v);
                                  _checkValidForm();
                                },
                                onAreaDeLaMedicinaChanged: (v) {
                                  setState(() => _areaDeLaMedicina = v);
                                  _checkValidForm();
                                },
                                onChanged: () {
                                  _checkValidForm(); // 👈 recalcula si el botón debe estar habilitado
                                },
                              ),
                              _paginaArchivos(),
                              _paginaDeclaracion(),
                              TrabajoCientificoSuccessScreenView(),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            if (_currentPage > 0 && _currentPage != 5)
                              TextButton(
                                onPressed: () {
                                  FocusScope.of(
                                    context,
                                  ).unfocus(); // cerrar teclado
                                  setState(() => _currentPage--);
                                  _pageController.animateToPage(
                                    _currentPage,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                  _checkValidForm();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: const Text(
                                    'Atrás'
                                    ' ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF387f4d),
                                    ),
                                  ),
                                ),
                              ),
                            const Spacer(),
                            if (_currentPage != 5)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  backgroundColor: textColor,
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
                                    _currentPage == 4 ? 'Enviar' : 'Siguiente',
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
      ],
    );
  }

  Widget _paginaArchivos() => ListView(
    padding: const EdgeInsets.fromLTRB(0, 8, 0, 16), // 👈 ajustá como necesites
    children: [
      ElevatedButton(
        onPressed: _seleccionarArchivoWord,
        child: _loadingWord
            ? Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : Text(
                _archivoWord == null
                    ? 'Subir archivo Word (.docx) *'
                    : 'Archivo Word: $_nameArchivoWord',
              ),
      ),
      const SizedBox(height: 10),
      ElevatedButton(
        onPressed: _seleccionarArchivoPdf,
        child: _loadingPdf
            ? Center(
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : Text(
                _archivoPdf == null
                    ? 'Subir archivo PDF (opcional)'
                    : 'Archivo PDF: $_nameArchivoPdf',
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
        onChanged: (v) {
          setState(() => _aceptaDeclaracion = v ?? false);
          _checkValidForm(); // 👈 recalcula si el botón debe estar habilitado
        },
        title: const Text('Acepto la declaración de originalidad'),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    ],
  );

  void _validarYAvanzar() {
    FocusScope.of(context).unfocus();

    _checkValidForm(); // 👈 recalcula si el botón debe estar habilitado
    if (_currentPage < 4) {
      setState(() => _currentPage++);
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
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
        isValid = true;
        break;
      case 2: // Detalles del trabajo
        isValid = _detallesFormKey.currentState?.validate() ?? false;
        break;
      case 3: // Archivos
        isValid =
            (_archivoWord !=
            null); // Verifica si se subió el archivo Word y se aceptó la declaración
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
