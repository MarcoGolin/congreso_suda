import 'package:congreso_evento/core/inputs/text_field_custom.dart';
import 'package:flutter/material.dart';

class TrabajoCientificoPaginaDetalles extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController tituloTrabajo;
  final TextEditingController resumen;
  final List<String> modalidades;
  final List<String> areasTematicas;
  final List<String> areasDeLaMedicina;
  final String? modalidad;
  final String? areaTematica;
  final String? areaDeLaMedicina;
  final void Function(String?)? onModadilidadChanged;
  final void Function(String?)? onAreaTematicaChanged;
  final void Function(String?)? onAreaDeLaMedicinaChanged;

  final Function() onChanged;
  const TrabajoCientificoPaginaDetalles({
    super.key,
    required this.tituloTrabajo,
    required this.resumen,
    required this.modalidad,
    required this.areaTematica,
    required this.areaDeLaMedicina,
    required this.onModadilidadChanged,
    required this.onAreaTematicaChanged,
    required this.onAreaDeLaMedicinaChanged,
    required this.modalidades,
    required this.areasTematicas,
    required this.areasDeLaMedicina,
    required this.formKey,
    required this.onChanged,
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
            'Detalles del trabajo',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF387f4d),
            ),
          ),
          const SizedBox(height: 5),
          TextFieldCustom(
            label: 'Título del trabajo',
            controller: tituloTrabajo,
            maxLength: 100,
            validator: (p0) {
              if (p0 == null || p0.isEmpty) {
                return 'El título es obligatorio';
              }
              if (p0.length < 10) {
                return 'El título debe tener al menos 10 caracteres';
              }
              return null;
            },
            onChanged: (value) {
              onChanged();
              // Aquí puedes manejar el cambio de texto si es necesario
            },
          ),
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
            value: areaTematica,
            decoration: inputDecoration.copyWith(labelText: 'Área temática'),
            items: areasTematicas
                .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                .toList(),
            onChanged: onAreaTematicaChanged,
            validator: (v) => v == null ? 'Seleccione un área temática' : null,
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: areaDeLaMedicina,
            decoration: inputDecoration.copyWith(
              labelText: 'Área de la Medicina',
            ),
            items: areasDeLaMedicina.map((a) {
              final partes = a.split('–');
              final titulo = partes[0].trim();
              final detalle = partes.length > 1 ? partes[1].trim() : '';

              return DropdownMenuItem(
                value: a,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: Colors.black,
                      ), // estilo base
                      children: [
                        TextSpan(
                          text: '$titulo ',
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                        if (detalle.isNotEmpty)
                          TextSpan(
                            text: '– $detalle',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
            isExpanded: true,
            onChanged: onAreaDeLaMedicinaChanged,
            validator: (v) =>
                v == null ? 'Seleccione un área de la Medicina' : null,
          ),
          const SizedBox(height: 10),
          TextFieldCustom(
            label: 'Resumen breve (opcional)',
            controller: resumen,
            maxLines: 3,
            maxLength: 300,
          ),
        ],
      ),
    );
  }
}
