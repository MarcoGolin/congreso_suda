import 'package:flutter/material.dart';

class DisertantesSection extends StatelessWidget {
  const DisertantesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final disertantes = [
      {
        'nombre': 'Dra. María López',
        'titulo': 'Médica Emergencista',
        'especialidad': 'Experta en atención prehospitalaria',
        'imagen': 'assets/disertantes/lopez.jpg',
      },
      {
        'nombre': 'Crio. Juan Pérez',
        'titulo': 'Instructor de RCP',
        'especialidad': 'Capacitador en primeros auxilios',
        'imagen': 'assets/disertantes/perez.jpg',
      },
      {
        'nombre': 'Tte. Laura Gómez',
        'titulo': 'Bombera Voluntaria',
        'especialidad': 'Técnicas de rescate y trauma',
        'imagen': 'assets/disertantes/gomez.jpg',
      },
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'DISERTANTES',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF002147),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: disertantes.map((disertante) {
              return _buildCard(disertante);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Map<String, String> disertante) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 20),
            child: child,
          ),
        );
      },
      child: SizedBox(
        width: 250,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    disertante['imagen']!,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  disertante['nombre']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  disertante['titulo']!,
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 6),
                Text(disertante['especialidad']!, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
