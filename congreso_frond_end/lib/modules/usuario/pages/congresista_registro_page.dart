import 'package:congreso_evento/core/loader_overlau.dart';
import 'package:congreso_evento/core/phone_imput_formatter.dart'; // Asegúrate de que esta ruta sea correcta
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importar para TextInputFormatter y LengthLimitingTextInputFormatter

class CongresistaRegistroPage extends StatefulWidget {
  const CongresistaRegistroPage({super.key});

  @override
  State<CongresistaRegistroPage> createState() =>
      _CongresistaRegistroPageState();
}

class _CongresistaRegistroPageState extends State<CongresistaRegistroPage> {
  final LoadingOverlay _loadingOverlay =
      LoadingOverlay(); // Instancia del overlay

  final List<FocusNode> _focusNodes = List.generate(9, (_) => FocusNode());

  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();
  final telefoneController = TextEditingController();
  final institucionController = TextEditingController();
  final registroAcademicoController = TextEditingController();
  // String? _selectedSeccion; // Eliminado
  String?
  _selectedSemestre; // Renombrado de _selectedSeccion a _selectedSemestre
  String? _selectedSeccion; // Use a nullable string for the dropdown value
  // Nuevas variables de estado para el selector de país
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

  @override
  void initState() {
    super.initState();
    // Removidos los listeners manuales, TextCapitalization.words maneja esto
    // nomeController.addListener(_capitalizeNomeField);
    // institucionController.addListener(_capitalizeInstitucionField);

    // Configurar el texto inicial del controlador de teléfono con el prefijo del país por defecto
    telefoneController.text = _selectedCountryCodePrefix;
    // Mover el cursor al final del prefijo
    telefoneController.selection = TextSelection.fromPosition(
      TextPosition(offset: _selectedCountryCodePrefix.length),
    );

    _focusNodes[0].requestFocus(); // Mover el foco al primer campo
  }

  @override
  void dispose() {
    // Removidos los listeners manuales
    // nomeController.removeListener(_capitalizeNomeField);
    // institucionController.removeListener(_capitalizeInstitucionField);

    nomeController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
    telefoneController.dispose();
    institucionController.dispose();
    registroAcademicoController.dispose();
    // semestreController.dispose(); // Eliminado ya que el campo de texto de semestre se reemplaza por dropdown

    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  // Las funciones _capitalizeWords, _capitalizeNomeField y _capitalizeInstitucionField han sido eliminadas
  // ya que la capitalización se maneja directamente con TextCapitalization.words en _buildTextField.

  // Cambiado a Future<void> y async para que el overlay funcione correctamente
  Future<void> _enviarFormulario() async {
    if (_formKey.currentState!.validate()) {
      // Simula una operación asíncrona (por ejemplo, enviar a Firebase)
      final Future<void> registrationFuture = Future.delayed(
        const Duration(seconds: 3), // Simula un retraso de 3 segundos
        () {
          // Aquí iría tu lógica de envío a Firebase o API
          print("Formulario válido y proceso finalizado!");
          print("Nombre: ${nomeController.text}");
          print("Email: ${emailController.text}");
          // No imprimir contraseñas en un entorno de producción
          print("Teléfono: ${telefoneController.text}");
          print("Institución: ${institucionController.text}");
          print("Registro Académico: ${registroAcademicoController.text}");
          print(
            "Semestre: ${_selectedSemestre ?? 'No seleccionada'}",
          ); // Usar _selectedSemestre
          // print("Sección: ${_selectedSeccion ?? 'No seleccionada'}"); // Eliminado
        },
      );

      // Muestra el loader mientras el future se resuelve
      _loadingOverlay.show(context, registrationFuture);

      // Opcional: Puedes esperar a que el future se complete si necesitas hacer algo después
      // await registrationFuture;
      // print("Operación de registro completa.");
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
            iconTheme: IconThemeData(color: textColor), // Back button color
          ),
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20,
              ),
              child: Card(
                elevation: 8, // Slightly less elevation for a cleaner look
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    16,
                  ), // Slightly less rounded
                ),
                color: Colors.white.withOpacity(
                  0.95,
                ), // Slight transparency for background blend
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 500,
                    ), // Max width for a compact look
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // Make column compact
                        children: [
                          const Text(
                            'Registro de Participante',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28, // Slightly larger for emphasis
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0C4793),
                            ),
                          ),
                          const SizedBox(height: 24), // Reduced spacing
                          _buildTextField(
                            "Nombre Completo",
                            nomeController,
                            focusNode: _focusNodes[0],
                            index: 0,
                            textCapitalization: TextCapitalization
                                .words, // Mantenemos esto si quieres la capitalización nativa para móviles
                          ),
                          _buildTextField(
                            "Email",
                            emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: _validarEmail,
                            focusNode: _focusNodes[1],
                            index: 1,
                          ),
                          _buildTextField(
                            "Contraseña",
                            senhaController,
                            obscureText: true,
                            validator:
                                _validarContrasenha, // Validación mejorada
                            focusNode: _focusNodes[2],
                            index: 2,
                          ),
                          _buildTextField(
                            "Confirmar Contraseña",
                            confirmarSenhaController,
                            obscureText: true,
                            validator: _validarConfirmacion,
                            focusNode: _focusNodes[3],
                            index: 3,
                          ),
                          const SizedBox(
                            height: 12,
                          ), // Espacio antes del campo de teléfono
                          Row(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Alineación al inicio
                            children: [
                              SizedBox(
                                width: 130, // Ancho fijo para el Dropdown
                                child: DropdownButtonFormField<String>(
                                  value: _selectedCountryCodePrefix,
                                  decoration: _inputDecoration.copyWith(
                                    labelText: 'País',
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 12.0,
                                    ),
                                  ),
                                  items: _countryOptions.map((country) {
                                    return DropdownMenuItem<String>(
                                      value: country['code'],
                                      child: Text(
                                        country['name']!,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCountryCodePrefix = value!;
                                      final selectedOption = _countryOptions
                                          .firstWhere(
                                            (element) =>
                                                element['code'] == value,
                                          );
                                      _selectedCountryHintText =
                                          selectedOption['hint']!;
                                      _phoneMaxLength = int.parse(
                                        selectedOption['maxLength']!,
                                      );

                                      // Set prefix and move cursor
                                      telefoneController.text =
                                          _selectedCountryCodePrefix;
                                      telefoneController.selection =
                                          TextSelection.fromPosition(
                                            TextPosition(
                                              offset: _selectedCountryCodePrefix
                                                  .length,
                                            ),
                                          );
                                    });
                                    _focusNodes[4]
                                        .requestFocus(); // Mover foco al campo de teléfono
                                    _formKey.currentState!
                                        .validate(); // Validar el formulario al cambiar el país
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ), // Espacio entre Dropdown y TextField
                              Expanded(
                                child: _buildTextField(
                                  "Teléfono", // La etiqueta puede ser genérica
                                  telefoneController,
                                  keyboardType: TextInputType.phone,
                                  validator: _validarTelefono,
                                  focusNode: _focusNodes[4],
                                  index: 4,
                                  inputFormatters: [
                                    PhoneInputFormatter(),
                                    LengthLimitingTextInputFormatter(
                                      _phoneMaxLength,
                                    ), // Aplicar límite de longitud
                                  ],
                                  hintText:
                                      _selectedCountryHintText, // Hint dinámico
                                  // Añadido onChanged para actualizar el maxLength dinámicamente
                                  onChanged: (value) {
                                    // Actualizar maxLength y hint basado en el prefijo digitado
                                    if (value.startsWith('+595')) {
                                      setState(() {
                                        _phoneMaxLength = 16;
                                        _selectedCountryHintText =
                                            'Ej. +595 9XX XXX XXX';
                                        _selectedCountryCodePrefix =
                                            '+595'; // Sincronizar dropdown
                                      });
                                    } else if (value.startsWith('+55')) {
                                      setState(() {
                                        _phoneMaxLength = 17;
                                        _selectedCountryHintText =
                                            'Ej. +55 DD 9XXXX-XXXX';
                                        _selectedCountryCodePrefix =
                                            '+55'; // Sincronizar dropdown
                                      });
                                    } else {
                                      // Si el prefijo no coincide o se borra, vuelve al estado inicial de Paraguay
                                      if (value.isEmpty ||
                                          !value.startsWith('+')) {
                                        setState(() {
                                          _selectedCountryCodePrefix = '+595';
                                          _selectedCountryHintText =
                                              'Ej. +595 9XX XXX XXX';
                                          _phoneMaxLength = 16;
                                        });
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          _buildTextField(
                            "Institución",
                            institucionController,
                            focusNode: _focusNodes[5],
                            index: 5,
                            textCapitalization: TextCapitalization.words,
                          ),
                          _buildTextField(
                            "Registro Académico",
                            registroAcademicoController,
                            keyboardType: TextInputType.number,
                            validator: _validarNumerico,
                            focusNode: _focusNodes[6],
                            index: 6,
                          ),
                          const SizedBox(height: 8), // Spacing before dropdown
                          DropdownButtonFormField<String>(
                            value: _selectedSemestre, // Usar la nueva variable
                            decoration: _inputDecoration.copyWith(
                              labelText:
                                  'Semestre', // Cambiar etiqueta a 'Semestre'
                            ),
                            items: [
                              ...List.generate(
                                12,
                                (index) => (index + 1).toString(),
                              ).map((semestre) {
                                return DropdownMenuItem<String>(
                                  value: semestre,
                                  child: Text(
                                    '$semestreº Semestre',
                                  ), // Modificación aquí
                                );
                              }),
                              const DropdownMenuItem<String>(
                                value: 'NO APLICA',
                                child: Text('NO APLICA'),
                              ),
                            ].toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedSemestre =
                                    value; // Actualizar la nueva variable
                              });
                              _formKey.currentState!.validate();
                            },
                            validator:
                                _validarSemestre, // Usar el validador existente para semestre
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
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
                            },
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                ? 'Campo requerido'
                                : null,
                          ),
                          const SizedBox(
                            height: 20,
                          ), // Spacing before info text
                          Text(
                            "Importante: Por favor, verifique y asegúrese de que todos los datos proporcionados sean correctos. La información será utilizada para que podamos comunicarnos con usted, coordinar el proceso de pago y la emisión de certificados.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12, // Smaller font for info text
                              color: Colors.grey[600],
                              height: 1.5, // Line height for readability
                            ),
                          ),
                          const SizedBox(height: 24), // Spacing before button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ), // Slightly larger padding
                                backgroundColor: const Color(0xFF0C4793),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    12,
                                  ), // Slightly less rounded
                                ),
                                elevation:
                                    5, // Add a subtle shadow to the button
                              ),
                              onPressed: _enviarFormulario,
                              child: const Text(
                                'REGISTRARSE',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing:
                                      1.5, // Add letter spacing for emphasis
                                ),
                              ),
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

  // Common InputDecoration for all text fields
  InputDecoration get _inputDecoration => InputDecoration(
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(
      vertical: 12.0,
      horizontal: 16.0,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none, // No border line for a cleaner look
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
        color: Colors.grey.shade300,
        width: 1.0,
      ), // Light grey border
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: Color(0xFF0C4793),
        width: 2.0,
      ), // Blue border when focused
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
    fillColor: const Color(0xFFF9FAFB), // Light background for input fields
    labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
    hintStyle: TextStyle(color: Colors.grey[400]),
  );

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    required FocusNode focusNode,
    required int index,
    TextCapitalization textCapitalization = TextCapitalization.none,
    List<TextInputFormatter>?
    inputFormatters, // Nuevo parámetro para formatters
    String? hintText, // Nuevo parámetro para el hint text
    ValueChanged<String>? onChanged, // Añadido onChanged aquí
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 12.0,
      ), // Consistent vertical spacing
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        focusNode: focusNode,
        textInputAction: index == _focusNodes.length - 1
            ? TextInputAction.done
            : TextInputAction.next,

        onFieldSubmitted: (_) {
          // Validate on submit
          if (index < _focusNodes.length - 1) {
            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
          } else {
            _enviarFormulario(); // Último campo, envía formulario
          }
        },
        validator:
            validator ??
            (value) =>
                (value == null || value.isEmpty) ? 'Campo requerido' : null,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ), // Darker text for readability
        decoration: _inputDecoration.copyWith(
          labelText: label,
          hintText: hintText, // Aplicar el hint text aquí
        ),
        textCapitalization: textCapitalization, // Se mantiene para otros campos
        inputFormatters: inputFormatters, // Aplicar los formatters aquí
        onChanged: (v) {
          _formKey.currentState!.validate(); // Validar al escribir
          if (onChanged != null) {
            onChanged(v); // Llamar al onChanged si se proporciona
          }
        }, // Pasar el onChanged al TextFormField
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

    // Validar al menos una letra mayúscula
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Debe contener al menos una letra mayúscula';
    }
    // Validar al menos una letra minúscula
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Debe contener al menos una letra minúscula';
    }
    // Validar al menos un dígito
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Debe contener al menos un dígito';
    }
    // Validar al menos un carácter especial (no alfanumérico)
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Debe contener al menos un carácter especial';
    }

    return null; // La contraseña es válida
  }

  String? _validarConfirmacion(String? value) {
    if (value == null || value.isEmpty) return 'Campo requerido';
    if (value != senhaController.text) return 'Las contraseñas no coinciden';
    return null;
  }

  String? _validarTelefono(String? value) {
    if (value == null || value.isEmpty) return 'Campo requerido';

    // Regex para Paraguay: +595 9XX XXX XXX
    final paraguayRegex = RegExp(r'^\+595\s9\d{2}\s\d{3}\s\d{3}$');
    // Regex para Brasil: +55 DD 9XXXX-XXXX
    final brasilRegex = RegExp(r'^\+55\s\d{2}\s9\d{4}-\d{4}$');

    if (paraguayRegex.hasMatch(value) || brasilRegex.hasMatch(value)) {
      return null;
    }
    return 'Formato de teléfono inválido (Ej. PY: +595 9XX XXX XXX o BR: +55 DD 9XXXX-XXXX)';
  }

  String? _validarNumerico(String? value) {
    if (value == null || value.isEmpty) return 'Campo requerido';
    return RegExp(r'^\d+$').hasMatch(value)
        ? null
        : 'Debe contener solo números';
  }

  String? _validarSemestre(String? value) {
    // Si el valor es 'NO APLICA', es válido.
    if (value == 'NO APLICA') {
      return null;
    }
    final num? s = num.tryParse(value ?? '');
    if (s == null || s < 1 || s > 12) {
      return 'Semestre debe estar entre 1 y 12 o ser "NO APLICA"';
    }
    return null;
  }
}
