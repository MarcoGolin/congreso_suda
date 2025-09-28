// ignore_for_file: use_build_context_synchronously

import 'package:congreso_evento/core/behahavior/custom_scroll_behavior.dart';
import 'package:congreso_evento/core/inputs/text_field_celular.dart';
import 'package:congreso_evento/core/loader_overlau.dart';
import 'package:congreso_evento/core/notifiier/default_state_notififier.dart';
import 'package:congreso_evento/modules/inscripcion/pages/inscripcion_registro_ctrl.dart';
import 'package:congreso_evento/modules/inscripcion/pages/inscripcion_success_screen_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

class InscripcionRegistroPage extends StatefulWidget {
  const InscripcionRegistroPage({super.key});

  @override
  State<InscripcionRegistroPage> createState() =>
      _InscripcionRegistroPageState();
}

class _InscripcionRegistroPageState extends State<InscripcionRegistroPage> {
  final LoadingOverlay _loadingOverlay =
      LoadingOverlay(); // Instancia del overlay

  final _ctrl = Modular.get<InscripcionRegistroCtrl>();

  // Adjusted to 8 focus nodes, as the phone row now has a combined logical focus.
  final List<FocusNode> _focusNodes = List.generate(8, (_) => FocusNode());

  final _formKey = GlobalKey<FormState>();

  var _obscureText = true; // Variable to toggle password visibility

  bool _aceptaTerminos = false;

  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();
  final telefoneController = TextEditingController();
  final institucionController = TextEditingController();
  final registroAcademicoController = TextEditingController();
  String? _selectedInstitucion;
  String? _selectedSemestre;
  String? _selectedSeccion;

  String _selectedCountryCodePrefix = '+595';

  late ReactionDisposer _rctDspr;

  final PageController _pageController = PageController();

  bool get _esOtraInstitucion => _selectedInstitucion == 'OTROS';

  final String _terminosTexto = '''
📜 Bases y Condiciones de Participación

IV Congreso Internacional de la Universidad Sudamericana: Medicina Interdisciplinaria

📅 10, 11 y 12 de octubre de 2025
📍 Shopping Mall Mercosur, Saltos del Guairá

1. Naturaleza del evento
El congreso es una actividad académica organizada por la Coordinación de Investigación Universitaria de la Universidad Sudamericana Sede Saltos del Guairá, orientada a promover el intercambio científico, la formación interdisciplinaria y la participación activa de estudiantes, docentes e investigadores del área de la salud.

2. Preinscripción e inscripción
•	La preinscripción se realiza exclusivamente a través del formulario oficial del congreso.
•	La inscripción se confirma únicamente una vez realizado el pago presencial ante personal autorizado por el Comité Organizador en la Universidad Sudamericana.
•	El Comité Organizador no se responsabiliza por pagos realizados a terceros no autorizados.
•	Los cupos son limitados y se adjudican según orden de confirmación.

3. Control de participación y acreditación
•	Durante todo el evento se realizará un sistema de acreditación obligatorio mediante check-in y check-out, escaneando la credencial del participante al ingresar y salir de cada jornada o actividad.
•	El escaneo será realizado exclusivamente por el staff del evento.
•	En caso de ausencia de alguno de estos registros (check-in o check-out) sin justificación válida, la participación en ese día podrá ser invalidada, afectando la cantidad de horas extracurriculares (investigación y extensión) reflejadas en el certificado.
•	Esta medida busca fomentar la participación total y activa durante todo el congreso.

4. Certificados
•	Los certificados serán emitidos en formato digital y estarán disponibles al finalizar el evento.
•	Serán válidos únicamente para los participantes que:
	• Hayan completado su inscripción y acreditación.
	• Participen en las actividades según el sistema de control establecido.
	• Cumplan con el porcentaje mínimo de asistencia requerido.
	• Los certificados detallarán las horas de participación en investigación y/o extensión, según la cantidad de actividades efectivamente acreditadas.
	• No se reimprimirán certificados por errores en los datos si fueron ingresados incorrectamente por el participante.

5. Uso de imagen
Con su participación, el/la inscripto/a autoriza el uso de su imagen (fotos y videos) capturados durante el evento, con fines institucionales, académicos o de difusión, sin fines comerciales.

6. Compromiso del participante
•	El participante se compromete a respetar las normas del evento, el reglamento interno y las instrucciones del comité organizador.
•	No se permitirá el ingreso de personas no registradas ni la cesión de credenciales.
•	El Comité Organizador se reserva el derecho de admisión y permanencia dentro del evento en caso de conductas inadecuadas o que interfieran con el normal desarrollo de las actividades.

7. Información oficial
Las actualizaciones sobre el congreso (cronograma, actividades, pagos, entrega de kits, etc.) serán comunicadas únicamente a través de los siguientes canales oficiales:
•	Página web del evento
•	Redes sociales institucionales
•	Grupos institucionales de estudiantes
•	Coordinación de Investigación Universitaria, Universidad Sudamericana, Saltos del Guairá

8. Protección de datos
La información personal es almacenada en plataformas seguras y será eliminada de nuestras bases de datos una vez concluido el evento y entregados todos los certificados correspondientes.


9. Contacto
Para más información sobre nuestras prácticas de privacidad, podés escribirnos a:
📧 consultas@congresounisud.com

✅ Declaración de aceptación
Al completar y enviar el formulario de preinscripción, el/la participante declara haber leído, comprendido y aceptado todas las cláusulas de las presentes Bases y Condiciones de Participación del IV CIUSMI 2025.
''';

  @override
  void initState() {
    super.initState();

    //listener para Capitalizar la primera letra de cada palabra en el campo de nombre
    nomeController.addListener(() {
      final text = nomeController.text;
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
          nomeController.value = TextEditingValue(
            text: capitalizedText,
            selection: TextSelection.collapsed(offset: capitalizedText.length),
          );
        }
      }
    });

    institucionController.addListener(() {
      final text = institucionController.text;
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
          institucionController.value = TextEditingValue(
            text: capitalizedText,
            selection: TextSelection.collapsed(offset: capitalizedText.length),
          );
        }
      }
    });

    _rctDspr = reaction((_) => _ctrl.stateClass.status, (
      StatusEnumGlobal status,
    ) {
      if (status == StatusEnumGlobal.success) {
        // Navigate to the next page on success
        // Modular.to.pushNamed('/usuario/congresista_registro_success');
        _pageController.animateToPage(
          1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        debugPrint(
          "Congresista registrado exitosamente: ${_ctrl.stateClass.message}",
        );
      } else if (status == StatusEnumGlobal.errorDialog) {
        // Show error dialog on error
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Atencion!'),
              content: Text(_ctrl.stateClass.message),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            );
          },
        );
      } else if (status == StatusEnumGlobal.warning) {
        // Show error message on error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _ctrl.stateClass.message,
              style: TextStyle(
                color: Colors.black87, // Text color for better contrast
              ),
            ),
            backgroundColor: Colors.yellow,
          ),
        );
      }
    });

    _focusNodes[0].requestFocus();

    if (kDebugMode) {
      //cargar los valores de prueba
      nomeController.text = "Juan Perez";
      emailController.text = "marcogolin60@gmail.com";
      senhaController.text = "Contraseña123!";
      confirmarSenhaController.text = "Contraseña123!";
      telefoneController.text = "+595 991 234 567";
      institucionController.text = "Universidad Nacional";
      registroAcademicoController.text = "123456789";
      _selectedSemestre = "3"; // Ejemplo de semestre seleccionado
      _selectedSeccion = "A"; // Ejemplo de sección seleccionada
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
    telefoneController.dispose();
    institucionController.dispose();
    registroAcademicoController.dispose();
    for (final node in _focusNodes) {
      node.dispose();
    }
    _rctDspr.call();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _enviarFormulario() async {
    // Manually validate the phone field before calling _formKey.currentState!.validate()
    // to ensure _rowError is updated before overall form validation.
    // Also validate the country dropdown explicitly.

    if (_formKey.currentState!.validate()) {
      final institucionParaGuardar = _esOtraInstitucion
          ? institucionController.text
          : (_selectedInstitucion ?? '');
      final Future<void> registrationFuture = _ctrl.saveCongresista(
        nombreCompleto: nomeController.text,
        email: emailController.text,
        senha: senhaController.text,
        telefone: telefoneController.text,
        institucion: institucionParaGuardar, // <- aquí
        registroAcademico: registroAcademicoController.text,
        semestre: _selectedSemestre ?? '',
        seccion: _selectedSeccion ?? '',
        pais: _selectedCountryCodePrefix == "+595" ? "PY" : "BR",
      );
      _loadingOverlay.show(context, registrationFuture);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = const Color(0xFF387f4d);
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/imagenes/fondo/fondo.jpg',
            fit: BoxFit.cover,
          ),
        ),

        Scaffold(
          appBar: AppBar(
            title: Text(
              'Registro del participante',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: textColor),
          ),
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          body: Center(
            child: SafeArea(
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
                    child: ScrollConfiguration(
                      behavior: CustomScrollBehavior(),
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Form(
                            key: _formKey,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            child: AutofillGroup(
                              child: ListView(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                children: [
                                  // Nombre Completo
                                  _buildTextField(
                                    "Nombre Completo",
                                    nomeController,
                                    focusNode: _focusNodes[0],
                                    index: 0,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    autofillHints: const [
                                      AutofillHints.name,
                                      AutofillHints.username,
                                    ],
                                  ),
                                  // Email
                                  _buildTextField(
                                    "Email",
                                    emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: _validarEmail,
                                    focusNode: _focusNodes[1],
                                    index: 1,
                                    autofillHints: const [
                                      AutofillHints.username,
                                      AutofillHints.email,
                                    ],
                                  ),
                                  // Contraseña
                                  _buildTextField(
                                    "Contraseña",
                                    senhaController,
                                    obscureText: _obscureText,
                                    validator: _validarContrasenha,
                                    focusNode: _focusNodes[2],
                                    index: 2,
                                    autofillHints: const [
                                      AutofillHints.newPassword,
                                    ],
                                  ),
                                  // Confirmar Contraseña
                                  _buildTextField(
                                    "Confirmar Contraseña",
                                    confirmarSenhaController,
                                    obscureText: _obscureText,
                                    validator: _validarConfirmacion,
                                    focusNode: _focusNodes[3],
                                    index: 3,
                                  ),

                                  TextFieldCelular(
                                    telefoneController: telefoneController,
                                    onChanged:
                                        (
                                          nrTelefono,
                                          selectedCountryCodePrefix,
                                        ) {
                                          // Call _validarTelefono to update _rowError and trigger red border
                                          setState(() {
                                            _selectedCountryCodePrefix =
                                                selectedCountryCodePrefix ??
                                                '+595';
                                          });

                                          _formKey.currentState!.validate();
                                        },
                                  ),

                                  // Institución (dropdown)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 12.0,
                                    ),
                                    child: DropdownButtonFormField<String>(
                                      value: _selectedInstitucion,
                                      decoration: _inputDecoration.copyWith(
                                        labelText: 'Institución',
                                      ),
                                      items: const [
                                        DropdownMenuItem(
                                          value:
                                              'Universidad Sudamericana - SDG',
                                          child: Text(
                                            'Universidad Sudamericana - SDG',
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value:
                                              'Universidad Sudamericana - PJC',
                                          child: Text(
                                            'Universidad Sudamericana - PJC',
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: 'OTROS',
                                          child: Text('OTROS'),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedInstitucion = value;
                                          if (_esOtraInstitucion) {
                                            institucionController
                                                .clear(); // Pedimos que escriba
                                            // Foco al campo tipeable
                                            Future.microtask(() {
                                              if (!mounted) return;
                                              FocusScope.of(
                                                context,
                                              ).requestFocus(_focusNodes[5]);
                                            });
                                          } else {
                                            institucionController.text =
                                                value ??
                                                ''; // Guardamos directo
                                            // Foco salta al siguiente campo real (Registro Académico)
                                            Future.microtask(
                                              () => FocusScope.of(
                                                context,
                                              ).requestFocus(_focusNodes[6]),
                                            );
                                          }
                                        });
                                        _formKey.currentState!.validate();
                                      },
                                      validator: (value) =>
                                          (value == null || value.isEmpty)
                                          ? 'Campo requerido'
                                          : null,
                                    ),
                                  ),

                                  // Solo mostrar el campo tipeable si eligió "OTROS"
                                  if (_esOtraInstitucion)
                                    _buildTextField(
                                      "Otra institución (escribí el nombre)",
                                      institucionController,
                                      focusNode: _focusNodes[5],
                                      index: 5,
                                      textCapitalization:
                                          TextCapitalization.words,
                                      validator: (v) {
                                        if (!_esOtraInstitucion) return null;
                                        if (v == null || v.trim().isEmpty) {
                                          return 'Ingresá el nombre de la institución';
                                        }
                                        if (v.trim().length < 3) {
                                          return 'Nombre demasiado corto';
                                        }
                                        return null;
                                      },
                                    ),

                                  // Registro Académico
                                  _buildTextField(
                                    "Registro Académico (RA)",
                                    registroAcademicoController,
                                    keyboardType: TextInputType.number,
                                    validator: _validarNumerico,
                                    focusNode: _focusNodes[6], // Adjusted index
                                    index: 6,
                                  ),
                                  // Semestre Dropdown
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 12.0,
                                    ),
                                    child: DropdownButtonFormField<String>(
                                      value: _selectedSemestre,
                                      decoration: _inputDecoration.copyWith(
                                        labelText: 'Semestre',
                                      ),
                                      items: [
                                        ...List.generate(
                                          12,
                                          (index) => (index + 1).toString(),
                                        ).map((semestre) {
                                          return DropdownMenuItem<String>(
                                            value: semestre,
                                            child: Text('$semestreº Semestre'),
                                          );
                                        }),
                                        const DropdownMenuItem<String>(
                                          value: 'NO APLICA',
                                          child: Text('NO APLICA'),
                                        ),
                                      ].toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedSemestre = value;
                                        });
                                        _formKey.currentState!.validate();
                                        FocusScope.of(context).requestFocus(
                                          _focusNodes[7],
                                        ); // Focus next after dropdown
                                      },
                                      validator: _validarSemestre,
                                    ),
                                  ),
                                  // Sección Dropdown
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: 12.0,
                                    ),
                                    child: DropdownButtonFormField<String>(
                                      value: _selectedSeccion,
                                      decoration: _inputDecoration.copyWith(
                                        labelText: 'Sección',
                                      ),
                                      items:
                                          [
                                            'A',
                                            'B',
                                            'C',
                                            'D',
                                            'E',
                                            'F',
                                            'NO APLICA',
                                          ].map((seccion) {
                                            return DropdownMenuItem<String>(
                                              value: seccion,
                                              child: Text(seccion),
                                            );
                                          }).toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedSeccion = value;
                                        });
                                        _formKey.currentState!.validate();
                                        // No next focus, as this is the last input before button
                                      },
                                      validator: (value) =>
                                          (value == null || value.isEmpty)
                                          ? 'Campo requerido'
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ), // Reduced spacing after last input
                                  Text(
                                    "Importante: Por favor, verifique y asegúrese de que todos los datos proporcionados sean correctos. La información será utilizada para que podamos comunicarnos con usted, coordinar el proceso de pago y la emisión de certificados.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                      height: 1.5,
                                    ),
                                  ),
                                  CheckboxListTile(
                                    activeColor: textColor,
                                    contentPadding: EdgeInsets.zero,
                                    title: GestureDetector(
                                      onTap: () {
                                        // Mostrar los términos o navegar a otra página
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text(
                                              'Términos y Condiciones',
                                            ),
                                            content: SingleChildScrollView(
                                              child: Text(
                                                _terminosTexto,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text('Cerrar'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: const Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(text: 'Acepto los '),
                                            TextSpan(
                                              text: 'términos y condiciones',
                                              style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    value: _aceptaTerminos,
                                    onChanged: (value) {
                                      setState(() {
                                        _aceptaTerminos = value ?? false;
                                      });
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                  ),
                                  const SizedBox(height: 5),
                                  Observer(
                                    builder: (_) => SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                          backgroundColor: textColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          elevation: 5,
                                        ),
                                        onPressed:
                                            (_ctrl.stateClass.status ==
                                                    StatusEnumGlobal.loading ||
                                                !_aceptaTerminos)
                                            ? null
                                            : _enviarFormulario,
                                        child: const Text(
                                          'REGISTRARSE',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ),
                          // Success Page
                          InscripcionSuccesScreenView(),
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

  // Common InputDecoration for all text fields and dropdowns
  InputDecoration get _inputDecoration => InputDecoration(
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(
      vertical: 12.0,
      horizontal: 16.0,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF0C4793), width: 2.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 2.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 2.0),
    ),
    filled: true,
    fillColor: const Color(0xFFF9FAFB),
    labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
    hintStyle: TextStyle(color: Colors.grey[400]),
  );

  // Helper widget for standard TextFields (now without its own padding)
  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool? obscureText,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    required FocusNode focusNode,
    required int index,
    TextCapitalization textCapitalization = TextCapitalization.none,
    List<TextInputFormatter>? inputFormatters,
    String? hintText,
    ValueChanged<String>? onChanged,
    List<String>? autofillHints, // <-- NUEVO
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0), // Apply padding here
      child: TextFormField(
        controller: controller,
        obscureText: obscureText ?? false,
        keyboardType: keyboardType,
        focusNode: focusNode,
        autofillHints: autofillHints,
        textInputAction: index == _focusNodes.length - 1
            ? TextInputAction.done
            : TextInputAction.next,
        onFieldSubmitted: (_) {
          if (index < _focusNodes.length - 1) {
            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
          } else {
            _enviarFormulario();
          }
        },
        validator:
            validator ??
            (value) =>
                (value == null || value.isEmpty) ? 'Campo requerido' : null,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
        decoration: _inputDecoration.copyWith(
          labelText: label,
          hintText: hintText,
          isDense: true,
          suffixIcon: obscureText != null
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText =
                          !_obscureText; // Toggle password visibility
                    });
                    // Implement show/hide password logic here
                  },
                )
              : null,
        ),
        textCapitalization: textCapitalization,
        inputFormatters: inputFormatters,
        onChanged: (v) {
          _formKey.currentState!
              .validate(); // Validate on type for immediate feedback
          if (onChanged != null) {
            onChanged(v);
          }
        },
      ),
    );
  }

  // VALIDACIONES PERSONALIZADAS

  String? _validarEmail(String? value) {
    if (value == null || value.isEmpty) return 'Campo requerido';
    final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
    return emailRegex.hasMatch(value) ? null : 'Email inválido';
  }

  String? _validarContrasenha(String? value) {
    if (value == null || value.isEmpty) return 'Campo requerido';
    if (value.length < 6) return 'Mínimo 6 caracteres';
    return null;
  }

  String? _validarConfirmacion(String? value) {
    if (value == null || value.isEmpty) return 'Campo requerido';
    if (value != senhaController.text) return 'Las contraseñas no coinciden';
    return null;
  }

  String? _validarNumerico(String? value) {
    if (value == null || value.isEmpty) return 'Campo requerido';
    return RegExp(r'^\d+$').hasMatch(value)
        ? null
        : 'Debe contener solo números';
  }

  String? _validarSemestre(String? value) {
    if (value == null || value.isEmpty) {
      return 'Campo requerido'; // Make dropdown required
    }
    // Si el valor es 'NO APLICA', es válido.
    if (value == 'NO APLICA') {
      return null;
    }
    final num? s = num.tryParse(value);
    if (s == null || s < 1 || s > 12) {
      return 'Semestre debe estar entre 1 y 12 o ser "NO APLICA"';
    }
    return null;
  }
}
