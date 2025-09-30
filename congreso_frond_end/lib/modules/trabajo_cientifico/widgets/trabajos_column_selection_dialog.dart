import 'package:congreso_evento/modules/trabajo_cientifico/controllers/mis_trabajos_excel_ctrl.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/models/trabajo_cientifico.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class TrabajosColumnSelectionDialog extends StatelessWidget {
  final MisTrabajosCientificosExcelCtrl controller;
  final List<TrabajoCientifico> trabajos;

  const TrabajosColumnSelectionDialog({
    super.key,
    required this.controller,
    required this.trabajos,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) => AlertDialog(
        title: const Text(
          'Seleccionar Columnas para Exportar',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 500,
          child: Column(
            children: [
              // Botones de selección global
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: controller.seleccionarTodasLasColumnas,
                    icon: const Icon(Icons.select_all, size: 16),
                    label: const Text('Seleccionar Todo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: controller.deseleccionarTodasLasColumnas,
                    icon: const Icon(Icons.deselect, size: 16),
                    label: const Text('Deseleccionar Todo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Selector de ordenamiento
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ordenar por:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButton<String>(
                        value: controller.ordenamientoSeleccionado,
                        isExpanded: true,
                        items: controller.opcionesOrdenamiento.entries
                            .map(
                              (entry) => DropdownMenuItem(
                                value: entry.value,
                                child: Text(entry.key),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.setOrdenamientoSeleccionado(value);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Lista de categorías y columnas
              Expanded(
                child: Observer(
                  builder: (context) => ListView.builder(
                    itemCount: controller.categoriaColumnas.length,
                    itemBuilder: (context, index) {
                      final categoria = controller.categoriaColumnas.keys
                          .elementAt(index);
                      final columnas = controller.categoriaColumnas[categoria]!;

                      return Observer(
                        builder: (context) {
                          final isSelected =
                              controller.categoriasSeleccionadas[categoria] ??
                              false;
                          final columnasSeleccionadas =
                              controller.columnasPorCategoria[categoria] ?? [];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ExpansionTile(
                              title: Row(
                                children: [
                                  Checkbox(
                                    value: isSelected,
                                    onChanged: (_) =>
                                        controller.toggleCategoria(categoria),
                                    tristate: true,
                                  ),
                                  Expanded(
                                    child: Text(
                                      categoria,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '${columnasSeleccionadas.length}/${columnas.length}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              children: columnas.map((columna) {
                                return Observer(
                                  builder: (context) {
                                    final isColumnaSelected =
                                        columnasSeleccionadas.contains(columna);
                                    return CheckboxListTile(
                                      title: Text(
                                        columna,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                      value: isColumnaSelected,
                                      onChanged: (_) => controller
                                          .toggleColumna(categoria, columna),
                                      dense: true,
                                      contentPadding: const EdgeInsets.only(
                                        left: 32,
                                        right: 16,
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),

              // Información de columnas seleccionadas
              Observer(
                builder: (context) => Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Colors.blue,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Columnas seleccionadas: ${controller.columnasSeleccionadas.length}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              controller.ocultarDialogoSeleccionColumnas();
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          Observer(
            builder: (context) => ElevatedButton.icon(
              onPressed: controller.columnasSeleccionadas.isEmpty
                  ? null
                  : () async {
                      Navigator.of(context).pop();
                      await controller.confirmarExportacion(trabajos);
                    },
              icon: const Icon(Icons.file_download, size: 16),
              label: const Text('Exportar Excel'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
