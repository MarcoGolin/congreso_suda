import 'package:congreso_evento/core/loader_overlau.dart';
import 'package:congreso_evento/core/models/global_state_class.dart';
import 'package:congreso_evento/core/phone_imput_formatter.dart'; // Asegúrate de que esta ruta sea correcta
import 'package:congreso_evento/modules/congresista/pages/congresista_registro_ctrl.dart';
import 'package:congreso_evento/modules/congresista/pages/success_screen_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';

class CongresistaRegistroPage extends StatefulWidget {
  const CongresistaRegistroPage({super.key});

  @override
  State<CongresistaRegistroPage> createState() =>
      _CongresistaRegistroPageState();
}

class _CongresistaRegistroPageState extends State<CongresistaRegistroPage> {
  final LoadingOverlay _loadingOverlay =
      LoadingOverlay(); // Instancia del overlay

  final _ctrl = Modular.get<CongresistaRegistroCtrl>();

  // Adjusted to 8 focus nodes, as the phone row now has a combined logical focus.
  final List<FocusNode> _focusNodes = List.generate(8, (_) => FocusNode());

  final _formKey = GlobalKey<FormState>();

  String? _rowError; // This will hold the error message for the row

  var _obscureText = true; // Variable to toggle password visibility

  bool _aceptaTerminos = false;

  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();
  final telefoneController = TextEditingController();
  final institucionController = TextEditingController();
  final registroAcademicoController = TextEditingController();
  String? _selectedSemestre;
  String? _selectedSeccion;

  String _selectedCountryCodePrefix = '+595'; // Valor inicial para Paraguay
  String _selectedCountryHintText =
      'Ej. +595 9XX XXX XXX'; // Hint inicial para Paraguay
  int _phoneMaxLength =
      16; // Longitud máxima inicial para Paraguay (+595 9XX XXX XXX)

  final List<Map<String, String>> _countryOptions = [
    {
      'code': '+595',
      'name': 'Paraguay',
      'hint': 'Ej. +595 9XX XXX XXX',
      'maxLength': '16',
    }, // 4 (code) + 1 (space) + 3 (9XX) + 1 (space) + 3 (XXX) + 1 (space) + 3 (XXX) = 16
    {
      'code': '+55',
      'name': 'Brasil',
      'hint': 'Ej. +55 DD 9XXXX-XXXX',
      'maxLength': '17',
    }, // 3 (code) + 1 (space) + 2 (DD) + 1 (space) + 5 (9XXXX) + 1 (hyphen) + 4 (XXXX) = 17
  ];

  late ReactionDisposer _rctDspr;

  final PageController _pageController = PageController();

  final String _terminosTexto = '''
🔐 Políticas de Privacidad – IV CIUSMI 2025

La presente política de privacidad describe cómo se recopila, utiliza y protege la información personal proporcionada por los usuarios que se registren o interactúen con el sitio web del IV Congreso Internacional de la Universidad Sudamericana: Medicina Interdisciplinaria, organizado por la Coordinación de Investigación Universitaria de la Universidad Sudamericana sede Saltos del Guairá.

1. Recopilación de datos
Durante el proceso de inscripción, recopilamos los siguientes datos personales: nombre completo, documento de identidad, institución de procedencia, carrera/semestre, correo electrónico y número de teléfono. Estos datos son necesarios para la organización del evento, la gestión de certificados y la emisión de comprobantes.

2. Uso de la información
La información proporcionada será utilizada únicamente para fines relacionados con el congreso, tales como:
• Confirmación de inscripción
• Acreditación y generación de credenciales
• Envío de certificados digitales
• Comunicación de novedades y recordatorios

No compartimos ni vendemos los datos personales con terceros ajenos a la organización.

3. Protección de datos
La información personal es almacenada en plataformas seguras y será eliminada de nuestras bases de datos una vez concluido el evento y entregados todos los certificados correspondientes.

4. Consentimiento
Al inscribirse, el usuario acepta esta política de privacidad y autoriza el uso de sus datos para los fines mencionados.

5. Contacto
Para más información sobre nuestras prácticas de privacidad, podés escribirnos a:
📧 congresosudamericana@gmail.com
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

    telefoneController.text = _selectedCountryCodePrefix;
    // Move cursor to the end of the prefix
    telefoneController.selection = TextSelection.fromPosition(
      TextPosition(offset: _selectedCountryCodePrefix.length),
    );
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
    _validarTelefono(telefoneController.text);
    _validarCountryDropdown(_selectedCountryCodePrefix);

    if (_formKey.currentState!.validate()) {
      final Future<void> registrationFuture = _ctrl.saveCongresista(
        nombreCompleto: nomeController.text,
        email: emailController.text,
        senha: senhaController.text,
        telefone: telefoneController.text,
        institucion: institucionController.text,
        registroAcademico: registroAcademicoController.text,
        semestre: _selectedSemestre ?? '',
        seccion: _selectedSeccion ?? '',
        pais: _selectedCountryCodePrefix == "+595"
            ? "PY"
            : "BR", // Use the selected country code
      );
      _loadingOverlay.show(context, registrationFuture);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = const Color(0xFF0C4793);
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/imagenes/fondo/fondo_inicio.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
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
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Form(
                          key: _formKey,
                          child: ListView(
                            children: [
                              const Text(
                                'Registro de Participante',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0C4793),
                                ),
                              ),
                              const SizedBox(height: 24),
                              // Nombre Completo
                              _buildTextField(
                                "Nombre Completo",
                                nomeController,
                                focusNode: _focusNodes[0],
                                index: 0,
                                textCapitalization: TextCapitalization.words,
                              ),
                              // Email
                              _buildTextField(
                                "Email",
                                emailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: _validarEmail,
                                focusNode: _focusNodes[1],
                                index: 1,
                              ),
                              // Contraseña
                              _buildTextField(
                                "Contraseña",
                                senhaController,
                                obscureText: _obscureText,
                                validator: _validarContrasenha,
                                focusNode: _focusNodes[2],
                                index: 2,
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
                              // Phone number group (Country Dropdown + Phone TextField)
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 12.0,
                                ), // Apply padding to the whole row
                                child: Stack(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 110,
                                          child: DropdownButtonFormField<String>(
                                            value: _selectedCountryCodePrefix,
                                            decoration: _inputDecoration
                                                .copyWith(
                                                  labelText: 'País',
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8.0,
                                                        vertical: 12.0,
                                                      ),
                                                ),
                                            items: _countryOptions.map((
                                              country,
                                            ) {
                                              return DropdownMenuItem<String>(
                                                value: country['code'],
                                                child: Text(
                                                  country['name']!,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedCountryCodePrefix =
                                                    value!;
                                                final selectedOption =
                                                    _countryOptions.firstWhere(
                                                      (element) =>
                                                          element['code'] ==
                                                          value,
                                                    );
                                                _selectedCountryHintText =
                                                    selectedOption['hint']!;
                                                _phoneMaxLength = int.parse(
                                                  selectedOption['maxLength']!,
                                                );

                                                telefoneController.text =
                                                    _selectedCountryCodePrefix;
                                                // Move cursor to the end of the prefix
                                                telefoneController.selection =
                                                    TextSelection.fromPosition(
                                                      TextPosition(
                                                        offset:
                                                            _selectedCountryCodePrefix
                                                                .length,
                                                      ),
                                                    );
                                              });
                                              // Re-validate the phone input group on country change
                                              _validarTelefono(
                                                telefoneController.text,
                                              );
                                              _formKey.currentState!.validate();
                                              _focusNodes[4]
                                                  .requestFocus(); // Move focus to phone field
                                            },
                                            validator: (value) {
                                              if (_rowError != null) {
                                                return ' '; // Return non-null to trigger red border
                                              }
                                              // If no error, return null to indicate valid selection
                                              // This validator triggers red border if _rowError exists
                                              return null;
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ), // Spacing between Dropdown and TextField
                                        Expanded(
                                          child: TextFormField(
                                            controller: telefoneController,
                                            keyboardType: TextInputType.phone,
                                            focusNode: _focusNodes[4],
                                            textInputAction: TextInputAction
                                                .next, // Set to next, as it's part of a logical group
                                            inputFormatters: [
                                              PhoneInputFormatter(),
                                              LengthLimitingTextInputFormatter(
                                                _phoneMaxLength,
                                              ),
                                            ],
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                            ),
                                            decoration: _inputDecoration.copyWith(
                                              labelText:
                                                  "Teléfono", // Label for phone field
                                              hintText:
                                                  _selectedCountryHintText, // Dynamic hint
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 12.0,
                                                    horizontal: 16.0,
                                                  ), // Ensure consistent padding
                                            ),
                                            onChanged: (value) {
                                              // Update maxLength and hint based on typed prefix
                                              if (value.startsWith('+595')) {
                                                setState(() {
                                                  _phoneMaxLength = 16;
                                                  _selectedCountryHintText =
                                                      'Ej. +595 9XX XXX XXX';
                                                  _selectedCountryCodePrefix =
                                                      '+595'; // Sync dropdown
                                                });
                                              } else if (value.startsWith(
                                                '+55',
                                              )) {
                                                setState(() {
                                                  _phoneMaxLength = 17;
                                                  _selectedCountryHintText =
                                                      'Ej. +55 DD 9XXXX-XXXX';
                                                  _selectedCountryCodePrefix =
                                                      '+55'; // Sync dropdown
                                                });
                                              } else {
                                                // If the prefix doesn't match or is deleted, revert to default Paraguay
                                                if (value.isEmpty ||
                                                    !value.startsWith('+')) {
                                                  setState(() {
                                                    _selectedCountryCodePrefix =
                                                        '+595';
                                                    _selectedCountryHintText =
                                                        'Ej. +595 9XX XXX XXX';
                                                    _phoneMaxLength = 16;
                                                  });
                                                }
                                              }
                                              // Call _validarTelefono to update _rowError and trigger red border
                                              _validarTelefono(value);
                                              _formKey.currentState!
                                                  .validate(); // Revalidate form
                                            },
                                            validator: (value) {
                                              // If _rowError is set by _validarTelefono, trigger red border without a new message
                                              if (_rowError != null) {
                                                return ' '; // Return non-null but non-displayable string for border
                                              }
                                              return null;
                                            },
                                            onFieldSubmitted: (_) {
                                              FocusScope.of(
                                                context,
                                              ).requestFocus(_focusNodes[5]);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (_rowError != null)
                                      Positioned(
                                        left: 15,
                                        bottom: 0,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            _rowError!,
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              // Institución
                              _buildTextField(
                                "Institución",
                                institucionController,
                                focusNode: _focusNodes[5], // Adjusted index
                                index: 5,
                                textCapitalization: TextCapitalization.words,
                              ),
                              // Registro Académico
                              _buildTextField(
                                "Registro Académico",
                                registroAcademicoController,
                                keyboardType: TextInputType.number,
                                validator: _validarNumerico,
                                focusNode: _focusNodes[6], // Adjusted index
                                index: 6,
                              ),
                              // Semestre Dropdown
                              Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
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
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: DropdownButtonFormField<String>(
                                  value: _selectedSeccion,
                                  decoration: _inputDecoration.copyWith(
                                    labelText: 'Sección',
                                  ),
                                  items: ['A', 'B', 'C', 'D', 'NO APLICA'].map((
                                    seccion,
                                  ) {
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
                                contentPadding: EdgeInsets.zero,
                                title: GestureDetector(
                                  onTap: () {
                                    // Mostrar los términos o navegar a otra página
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Términos y Condiciones'),
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
                                      backgroundColor: const Color(0xFF0C4793),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
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
                        // Success Page
                        SuccessScreenView(),
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0), // Apply padding here
      child: TextFormField(
        controller: controller,
        obscureText: obscureText ?? false,
        keyboardType: keyboardType,
        focusNode: focusNode,
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
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Debe contener al menos una letra mayúscula';
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Debe contener al menos una letra minúscula';
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Debe contener al menos un dígito';
    }
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Debe contener al menos un carácter especial';
    }
    return null;
  }

  String? _validarConfirmacion(String? value) {
    if (value == null || value.isEmpty) return 'Campo requerido';
    if (value != senhaController.text) return 'Las contraseñas no coinciden';
    return null;
  }

  // New validator for the country dropdown
  String? _validarCountryDropdown(String? value) {
    // This validator is called by _validarTelefono to ensure the dropdown also gets a red border
    // if the phone number as a whole is invalid.
    return _rowError != null
        ? ' '
        : null; // Return non-null to trigger red border
  }

  String? _validarTelefono(String? value) {
    // Use setState here to update the UI (specifically the _rowError text)
    setState(() {
      if (value == null || value.isEmpty) {
        _rowError = 'Campo requerido';
      } else {
        final paraguayRegex = RegExp(r'^\+595\s9\d{2}\s\d{3}\s\d{3}$');
        final brasilRegex = RegExp(r'^\+55\s\d{2}\s9\d{4}-\d{4}$');

        if (paraguayRegex.hasMatch(value) || brasilRegex.hasMatch(value)) {
          _rowError = null; // Clear the row error if valid
        } else {
          _rowError = 'Ej. PY: +595 9XX XXX XXX o BR: +55 DD 9XXXX-XXXX';
        }
      }
    });

    // This return value is used by the TextFormField's validator to trigger the red border.
    // We return null if the text is valid, or a non-empty string (like ' ') if _rowError is active,
    // which makes the border red without adding another error message directly below the field.
    return ' ';
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
