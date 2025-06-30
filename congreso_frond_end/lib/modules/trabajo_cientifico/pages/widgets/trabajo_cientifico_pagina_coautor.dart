import 'package:congreso_evento/core/inputs/text_field_custom.dart';
import 'package:flutter/material.dart';

class TrabajoCientificoPaginaCoautor extends StatelessWidget {
  final List<Map<String, dynamic>> coautores;
  final List<String> filiacionesDisponibles;
  final void Function(String?, int index) onFiliacionChanged;
  final void Function(int index) onRemoveCoautor;
  final void Function() addNuevoCoautor;
  const TrabajoCientificoPaginaCoautor({
    super.key,
    required this.coautores,
    required this.filiacionesDisponibles,
    required this.onFiliacionChanged,
    required this.onRemoveCoautor,
    required this.addNuevoCoautor,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
      children: [
        const Text(
          'Coautores (opcional)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0C4793),
          ),
        ),
        const SizedBox(height: 8),
        ...coautores.asMap().entries.map((entry) {
          final index = entry.key;
          final map = entry.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index > 0) const Divider(height: 24),
              TextFieldCustom(
                label: 'Nombre del coautor',
                controller: map['nombre'],
              ),
              TextFieldCustom(
                label: 'Correo del coautor',
                controller: map['email'],
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v != null && v.isNotEmpty && !v.contains('@')) {
                    return 'Email inválido';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: map['filiacion'],
                isExpanded: true,
                decoration: inputDecoration.copyWith(
                  labelText: 'Filiación institucional del coautor',
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
                  onFiliacionChanged(v, index);
                },
                validator: (v) => v == null ? 'Seleccione una filiación' : null,
              ),
              if (map['filiacion'] == 'Otros')
                TextFieldCustom(
                  label: 'Especifique la filiación',
                  controller: map['filiacionOtro'],
                  validator: (v) => v == null || v.isEmpty
                      ? 'Debe especificar la filiación'
                      : null,
                ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    onRemoveCoautor(index);
                  },
                ),
              ),
            ],
          );
        }),
        TextButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Agregar coautor'),
          onPressed: () {
            addNuevoCoautor();
          },
        ),
      ],
    );
  }
}
