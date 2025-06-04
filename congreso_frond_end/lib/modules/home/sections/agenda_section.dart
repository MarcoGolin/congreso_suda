import 'package:flutter/material.dart';

class AgendaSection extends StatelessWidget {
  const AgendaSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'AGENDA DEL CONGRESO',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF002147),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _buildAgendaList(),
        ],
      ),
    );
  }

  Widget _buildAgendaList() {
    final agenda = [
      {
        'dia': 'Día 1 - Viernes 15 de Agosto',
        'actividades': [
          '08:00 - Acreditación e ingreso',
          '09:00 - Acto de apertura',
          '10:00 - Charla: Avances en medicina de emergencia',
          '13:00 - Almuerzo',
          '14:30 - Taller práctico: RCP y manejo de DEA',
          '17:00 - Cierre del día',
        ],
      },
      {
        'dia': 'Día 2 - Sábado 16 de Agosto',
        'actividades': [
          '08:30 - Recepción',
          '09:00 - Panel de expertos: Trauma y atención prehospitalaria',
          '11:30 - Casos clínicos interactivos',
          '13:00 - Almuerzo',
          '15:00 - Taller: Uso de ventilación mecánica portátil',
          '17:30 - Sorteos y cierre del congreso',
        ],
      },
    ];

    return Column(
      children: agenda.map((dia) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: ExpansionTile(
            collapsedShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.transparent),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            backgroundColor: Colors.white,
            collapsedBackgroundColor: Colors.white,
            title: Text(
              dia['dia'] as String,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: Color(0xFF002147),
              ),
            ),
            children: (dia['actividades'] as List<String>).map((actividad) {
              return ListTile(
                leading: const Icon(
                  Icons.check_circle_outline,
                  color: Color(0xFF00B2C5),
                ),
                title: Text(actividad),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}
