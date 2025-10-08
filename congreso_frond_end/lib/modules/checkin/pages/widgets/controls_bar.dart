import 'package:congreso_evento/modules/checkin/controllers/checkin_ctrl.dart';
import 'package:congreso_evento/modules/checkin/enums/checkin_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ControlsBar extends StatelessWidget {
  const ControlsBar({
    super.key,
    required this.store,
    required this.uuidController,
    required this.isLoading,
    required this.onSubmit,
    required this.fmt,
  });

  final CheckinCtrl store;
  final TextEditingController uuidController;
  final bool isLoading;
  final Future<void> Function() onSubmit;
  final String Function(DateTime?) fmt;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Observer(
        builder: (_) => Wrap(
          runSpacing: 8,
          spacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 250,
                  child: DropdownButtonFormField<CheckinTipo>(
                    value: store.selectedTipo,
                    isExpanded: true,
                    style: TextStyle(color: Colors.white, fontSize: 14),
                    dropdownColor: Colors.grey[900],
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: 'Tipo',
                      labelStyle: TextStyle(
                        color: store.bloquearControles
                            ? Colors.white30
                            : Colors.white,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white30),
                      ),
                      fillColor: store.bloquearControles
                          ? Colors.white24
                          : Colors.white10,
                      filled: true,
                    ),

                    items: CheckinTipo.values
                        .map(
                          (t) =>
                              DropdownMenuItem(value: t, child: Text(t.label)),
                        )
                        .toList(),
                    onChanged: store.bloquearControles
                        ? null
                        : (t) => t == null ? null : store.setTipo(t),
                  ),
                ),
                IconButton(
                  color: Colors.white70,
                  tooltip: store.bloquearControles
                      ? 'Desbloquear controles'
                      : 'Bloquear controles',
                  onPressed: () => store.toggleBloquearControles(),
                  icon: store.bloquearControles
                      ? Icon(Icons.lock)
                      : Icon(Icons.lock_open),
                ),
              ],
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
            Observer(
              builder: (_) {
                if (store.selectedTipo == CheckinTipo.COFFEE_BREAK_ENTREGADO) {
                  return SizedBox(
                    width: 220,
                    child: DropdownButtonFormField<CoffeeBreak>(
                      value: store.selectedCoffeeBreak,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      dropdownColor: Colors.grey[900],
                      decoration: InputDecoration(
                        isDense: true,
                        labelText: 'Coffee',
                        labelStyle: TextStyle(
                          color: store.bloquearControles
                              ? Colors.white30
                              : Colors.white,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white54),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white30),
                        ),
                        fillColor: store.bloquearControles
                            ? Colors.white24
                            : Colors.white10,
                        filled: true,
                      ),
                      items: CoffeeBreak.values
                          .map(
                            (c) => DropdownMenuItem(
                              value: c,
                              child: Text(c.label),
                            ),
                          )
                          .toList(),
                      onChanged: store.bloquearControles
                          ? null
                          : store.setCoffee,
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
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
