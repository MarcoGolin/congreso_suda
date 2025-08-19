import 'package:congreso_evento/core/inputs/text_field_celular.dart';
import 'package:congreso_evento/core/inputs/text_field_custom.dart';
import 'package:flutter/material.dart';

class TrabajoCientificoPaginaAutor extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController autorNombreTXTCTRL;
  final TextEditingController autorEmailTXTCTRL;
  final TextEditingController autorTelefonoTXTCTRL;
  final String? filiacionSelected;
  final TextEditingController filiacionXTCTRL;
  final TextEditingController filiacionOtrosXTCTRL;
  final Function() onChanged;
  final List<String> filiacionesDisponibles;
  final void Function(String?) onFiliacionChanged;
  const TrabajoCientificoPaginaAutor({
    super.key,
    required this.autorNombreTXTCTRL,
    required this.autorEmailTXTCTRL,
    required this.autorTelefonoTXTCTRL,
    required this.formKey,
    required this.onChanged,
    required this.filiacionesDisponibles,
    required this.filiacionXTCTRL,
    required this.onFiliacionChanged,
    required this.filiacionOtrosXTCTRL,
    this.filiacionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          0,
          8,
          0,
          16,
        ), // 👈 ajustá como necesites
        children: [
          const Text(
            'Autor principal',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF387f4d),
            ),
          ),
          const SizedBox(height: 5),
          TextFieldCustom(
            label: 'Nombre completo',
            controller: autorNombreTXTCTRL,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            validator: (v) {
              if (v == null || v.isEmpty) {
                return 'Campo requerido';
              }
              if (v.length < 3) {
                return 'Nombre muy corto';
              }
              return null; // Validación exitosa
            },
            onChanged: (value) {
              onChanged();
              // Aquí puedes manejar el cambio de texto si es necesario
            },
          ),
          TextFieldCustom(
            label: 'Correo electrónico',
            controller: autorEmailTXTCTRL,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (v) {
              if (v == null || v.isEmpty) return 'Campo requerido';
              final emailRegex = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$');
              return emailRegex.hasMatch(v)
                  ? null
                  : 'Email inválido, formato correcto juanperez@gmail.com';
            },
            onChanged: (value) {
              onChanged();
              // Aquí puedes manejar el cambio de texto si es necesario
            },
          ),

          TextFieldCelular(
            telefoneController: autorTelefonoTXTCTRL,
            onChanged: (nrTelefono, selectedCountryCodePrefix) {
              // Call _validarTelefono to update _rowError and trigger red border
              // setState(() {
              //   _selectedCountryCodePrefix = selectedCountryCodePrefix ?? '+595';
              // });

              // _formKey.currentState!.validate();
              onChanged();
            },
          ),

          DropdownButtonFormField<String>(
            isExpanded: true,
            value: filiacionSelected,
            decoration: inputDecoration.copyWith(
              labelText: 'Filiación institucional del autor',
            ),
            items: filiacionesDisponibles
                .map(
                  (f) => DropdownMenuItem(
                    value: f,
                    child: Text(f, overflow: TextOverflow.ellipsis),
                  ),
                )
                .toList(),
            onChanged: (v) {
              onFiliacionChanged(v);
            },
            validator: (v) => v == null ? 'Seleccione una filiación' : null,
          ),
          if (filiacionSelected == 'Otros')
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: TextFieldCustom(
                label: 'Especifique la filiación',
                controller: filiacionOtrosXTCTRL,
                validator: (v) => v == null || v.isEmpty
                    ? 'Debe especificar la filiación'
                    : null,
              ),
            ),
        ],
      ),
    );
  }
}
