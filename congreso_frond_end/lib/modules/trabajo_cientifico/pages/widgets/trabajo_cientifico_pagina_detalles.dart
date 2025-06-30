import 'package:congreso_evento/core/inputs/text_field_custom.dart';
import 'package:flutter/material.dart';

class TrabajoCientificoPaginaDetalles extends StatelessWidget {
  final TextEditingController tituloTrabajo;
  final TextEditingController resumen;
  final List<String> modalidades;
  final List<String> areas;
  final String? modalidad;
  final String? area;
  final void Function(String?)? onModadilidadChanged;
  final void Function(String?)? onAreaChanged;
  const TrabajoCientificoPaginaDetalles({
    super.key,
    required this.tituloTrabajo,
    required this.resumen,
    required this.modalidad,
    required this.area,
    required this.onModadilidadChanged,
    required this.onAreaChanged,
    required this.modalidades,
    required this.areas,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        0,
        8,
        0,
        16,
      ), // 👈 ajustá como necesites
      children: [
        const Text(
          'Detalles del trabajo',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0C4793),
          ),
        ),
        const SizedBox(height: 5),
        TextFieldCustom(label: 'Título del trabajo', controller: tituloTrabajo),
        DropdownButtonFormField<String>(
          value: modalidad,
          decoration: inputDecoration.copyWith(labelText: 'Modalidad'),
          items: modalidades
              .map((m) => DropdownMenuItem(value: m, child: Text(m)))
              .toList(),
          onChanged: onModadilidadChanged,
          validator: (v) => v == null ? 'Seleccione una modalidad' : null,
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: area,
          decoration: inputDecoration.copyWith(labelText: 'Área temática'),
          items: areas
              .map((a) => DropdownMenuItem(value: a, child: Text(a)))
              .toList(),
          onChanged: onAreaChanged,
          validator: (v) => v == null ? 'Seleccione un área temática' : null,
        ),
        const SizedBox(height: 10),
        TextFieldCustom(
          label: 'Resumen breve (opcional)',
          controller: resumen,
          maxLines: 3,
          maxLength: 300,
        ),
      ],
    );
  }
}
