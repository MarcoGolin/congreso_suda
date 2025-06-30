import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../phone_imput_formatter.dart';
import 'text_field_custom.dart';

class TextFieldCelular extends StatefulWidget {
  final FocusNode? focusNode;
  final TextEditingController telefoneController;
  final void Function(String? nrTelefono, String? selectedCountryCodePrefix)?
  onChanged;

  const TextFieldCelular({
    super.key,
    this.focusNode,
    required this.telefoneController,
    required this.onChanged,
  });

  @override
  State<TextFieldCelular> createState() => _TextFieldCelularState();
}

class _TextFieldCelularState extends State<TextFieldCelular> {
  String? _rowError;

  int _phoneMaxLength = 16;
  String _selectedCountryCodePrefix = '+595';
  String _selectedCountryHintText = 'Ej. +595 9XX XXX XXX';
  final List<Map<String, String>> _countryOptions = [
    {
      'code': '+595',
      'name': 'Paraguay',
      'hint': 'Ej. +595 9XX XXX XXX',
      'maxLength': '16',
    },
    {
      'code': '+55',
      'name': 'Brasil',
      'hint': 'Ej. +55 DD 9XXXX-XXXX',
      'maxLength': '17',
    },
  ];

  @override
  void initState() {
    super.initState();

    if (widget.telefoneController.text.isEmpty) {
      widget.telefoneController.text = _selectedCountryCodePrefix;
      widget.telefoneController.selection = TextSelection.fromPosition(
        TextPosition(offset: _selectedCountryCodePrefix.length),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110,
              height: 60,
              child: DropdownButtonFormField<String>(
                value: _selectedCountryCodePrefix,
                decoration: inputDecoration.copyWith(
                  labelText: 'País',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 11.0,
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
                    final selectedOption = _countryOptions.firstWhere(
                      (element) => element['code'] == value,
                    );
                    _selectedCountryHintText = selectedOption['hint']!;
                    _phoneMaxLength = int.parse(selectedOption['maxLength']!);

                    widget.telefoneController.text = _selectedCountryCodePrefix;
                    widget
                        .telefoneController
                        .selection = TextSelection.fromPosition(
                      TextPosition(offset: _selectedCountryCodePrefix.length),
                    );
                  });

                  widget.onChanged?.call(
                    widget.telefoneController.text,
                    _selectedCountryCodePrefix,
                  );
                },
                validator: (value) {
                  return _validarTelefono(widget.telefoneController.text, true);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFieldCustom(
                label: 'Celular',
                controller: widget.telefoneController,
                keyboardType: TextInputType.phone,
                focusNode: widget.focusNode,
                textInputAction: TextInputAction.next,
                inputFormatters: [
                  PhoneInputFormatter(),
                  LengthLimitingTextInputFormatter(_phoneMaxLength),
                ],
                onChanged: (value) {
                  if (value.startsWith('+595')) {
                    setState(() {
                      _phoneMaxLength = 16;
                      _selectedCountryHintText = 'Ej. +595 9XX XXX XXX';
                      _selectedCountryCodePrefix = '+595';
                    });
                  } else if (value.startsWith('+55')) {
                    setState(() {
                      _phoneMaxLength = 17;
                      _selectedCountryHintText = 'Ej. +55 DD 9XXXX-XXXX';
                      _selectedCountryCodePrefix = '+55';
                    });
                  } else if (value.isEmpty || !value.startsWith('+')) {
                    setState(() {
                      _selectedCountryCodePrefix = '+595';
                      _selectedCountryHintText = 'Ej. +595 9XX XXX XXX';
                      _phoneMaxLength = 16;
                    });
                  }
                  widget.onChanged?.call(value, _selectedCountryCodePrefix);
                },
                maxLength: _phoneMaxLength,
                hintText: _selectedCountryHintText,
                onTap: () => setState(() => _rowError = null),
                validator: (value) {
                  return _validarTelefono(value, true);
                },
                onFieldSubmitted: (_) {
                  if (widget.focusNode != null) {
                    FocusScope.of(context).requestFocus(widget.focusNode);
                  }
                },
              ),
            ),
          ],
        ),
        if (_rowError != null)
          Positioned(
            top: 41,
            left:
                15, // Adjust this value to position the error message correctly
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _rowError!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          ),
      ],
    );
  }

  String? _validarTelefono(String? value, bool isOnChanged) {
    setState(() {
      if (value == null || value.isEmpty) {
        _rowError = 'Campo requerido';
      } else {
        final py = RegExp(r'^\+595\s9\d{2}\s\d{3}\s\d{3}$');
        final br = RegExp(r'^\+55\s\d{2}\s9\d{4}-\d{4}$');
        _rowError = (py.hasMatch(value) || br.hasMatch(value))
            ? null
            : 'Ej. PY: +595 9XX XXX XXX o BR: +55 DD 9XXXX-XXXX';
      }
    });
    return isOnChanged
        ? (_rowError != null || _rowError?.isNotEmpty == true)
              ? ''
              : null
        : _rowError;
  }
}
