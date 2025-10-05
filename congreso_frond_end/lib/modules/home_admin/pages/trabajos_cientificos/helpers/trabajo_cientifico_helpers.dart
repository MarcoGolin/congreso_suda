// ---------- Helpers de estilo de estado ----------
import 'package:flutter/material.dart';

class EstadoStyle {
  final Color color;
  final IconData icon;
  final String label;
  const EstadoStyle(this.color, this.icon, this.label);
}

EstadoStyle estadoStyleFor(String? estadoRaw) {
  final e = (estadoRaw ?? '').toLowerCase().trim();
  if (e.contains('acept')) {
    return EstadoStyle(Colors.green, Icons.check_circle, 'Aceptado');
  }
  if (e.contains('rechaz')) {
    return EstadoStyle(Colors.red, Icons.highlight_off, 'Rechazado');
  }
  if (e.contains('observ')) {
    return EstadoStyle(Colors.deepOrange, Icons.visibility, 'Observado');
  }
  if (e.contains('revisi')) {
    return EstadoStyle(Colors.amber[800]!, Icons.hourglass_top, 'En revisión');
  }
  if (e.contains('recib')) {
    return EstadoStyle(Colors.blueGrey, Icons.inbox, 'Recibido');
  }
  // Default neutro
  return EstadoStyle(
    Colors.grey,
    Icons.flag,
    (estadoRaw?.isNotEmpty ?? false) ? estadoRaw! : 'Sin estado',
  );
}
