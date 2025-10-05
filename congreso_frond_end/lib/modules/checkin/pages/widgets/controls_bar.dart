import 'package:congreso_evento/modules/checkin/controllers/checkin_store.dart';
import 'package:congreso_evento/modules/checkin/enums/checkin_enums.dart';
import 'package:flutter/material.dart';

class ControlsBar extends StatelessWidget {
  const ControlsBar({
    super.key,
    required this.store,
    required this.uuidController,
    required this.isLoading,
    required this.onSubmit,
    required this.fmt,
  });

  final CheckinStore store;
  final TextEditingController uuidController;
  final bool isLoading;
  final Future<void> Function() onSubmit;
  final String Function(DateTime?) fmt;

  @override
  Widget build(BuildContext context) {
    final tipo = store.selectedTipo.value;
    return Card(
      elevation: 0,
      color: Colors.grey.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Wrap(
          runSpacing: 8,
          spacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          children: [
            SizedBox(
              width: 250,
              child: DropdownButtonFormField<CheckinTipo>(
                value: tipo,
                isExpanded: true,
                decoration: const InputDecoration(
                  isDense: true,
                  labelText: 'Tipo',
                  border: OutlineInputBorder(),
                ),
                items: CheckinTipo.values
                    .map(
                      (t) => DropdownMenuItem(value: t, child: Text(t.label)),
                    )
                    .toList(),
                onChanged: (t) => t == null ? null : store.setTipo(t),
              ),
            ),

            // if (tipo == CheckinTipo.LIGA_ASISTENCIA)
            //   SizedBox(
            //     width: 220,
            //     child: DropdownButtonFormField<int>(
            //       value: store.selectedTallerId.value,
            //       decoration: const InputDecoration(
            //         isDense: true,
            //         labelText: 'Taller',
            //         border: OutlineInputBorder(),
            //       ),
            //       items: const [
            //         // TODO: poblar desde tu TallerService
            //         DropdownMenuItem(value: 1, child: Text('Taller 1')),
            //         DropdownMenuItem(value: 2, child: Text('Taller 2')),
            //         DropdownMenuItem(value: 3, child: Text('Taller 3')),
            //       ],
            //       onChanged: store.setTallerId,
            //     ),
            //   ),
            if (tipo == CheckinTipo.COFFEE_BREAK_ENTREGADO)
              SizedBox(
                width: 220,
                child: DropdownButtonFormField<CoffeeBreak>(
                  value: store.selectedCoffeeBreak.value,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Coffee',
                    border: OutlineInputBorder(),
                  ),
                  items: CoffeeBreak.values
                      .map(
                        (c) => DropdownMenuItem(value: c, child: Text(c.label)),
                      )
                      .toList(),
                  onChanged: store.setCoffee,
                ),
              ),

            // // UUID manual compacto
            // SizedBox(
            //   width: 260,
            //   child: TextField(
            //     controller: uuidController,
            //     decoration: const InputDecoration(
            //       isDense: true,
            //       border: OutlineInputBorder(),
            //       labelText: 'UUID (manual)',
            //     ),
            //     minLines: 1,
            //     maxLines: 1,
            //     textInputAction: TextInputAction.done,
            //     onSubmitted: (_) => onSubmit(),
            //   ),
            // ),
            // SizedBox(
            //   height: 40,
            //   child: ElevatedButton.icon(
            //     onPressed: isLoading ? null : onSubmit,
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: const Color(0xFF387f4d),
            //       foregroundColor: Colors.white,
            //     ),
            //     icon: const Icon(Icons.check, size: 18),
            //     label: const Text('Registrar'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
