import 'package:flutter/material.dart';

class HomeCongresistaPage extends StatelessWidget {
  const HomeCongresistaPage({super.key});

  @override
  Widget build(BuildContext context) {
    const brandPrimary = Color(0xFF387f4d); // verde del proyecto
    const brandLight = Color(0xFF73c165);

    final text = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel del Congresista'),
        backgroundColor: brandLight,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                gradient: const LinearGradient(
                  colors: [Color(0xFFF7FBF8), Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ilustración / ícono
                  const _BuildBadge(),
                  const SizedBox(height: 12),

                  // Título
                  Text(
                    'Estamos trabajando en esta sección',
                    style: text.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1F2937),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),

                  // Subtítulo
                  Text(
                    'En breve estará disponible el panel del congresista.\n'
                    'Seguimos mejorando tu experiencia en el congreso.',
                    style: text.bodyMedium?.copyWith(
                      color: const Color(0xFF4B5563),
                      height: 1.35,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),
                  // Barra de progreso sutil (solo UI)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      minHeight: 8,
                      valueColor: const AlwaysStoppedAnimation(brandPrimary),
                      backgroundColor: brandPrimary.withOpacity(0.12),
                    ),
                  ),

                  const SizedBox(height: 14),
                  // Etiquetas de “En camino”
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      _Tag('Mi agenda'),
                      _Tag('Certificados'),
                      _Tag('Mis inscripciones'),
                      _Tag('Historial de asistencia'),
                    ],
                  ),

                  const SizedBox(height: 16),
                  // Botones de UI (sin acciones)
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 42,
                          child: ElevatedButton.icon(
                            onPressed: null, // UI solamente
                            icon: const Icon(
                              Icons.notifications_none,
                              size: 18,
                            ),
                            label: const Text('Avisarme cuando esté listo'),
                            style: ElevatedButton.styleFrom(
                              disabledBackgroundColor: brandPrimary,
                              disabledForegroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 42,
                          child: OutlinedButton.icon(
                            onPressed: null, // UI solamente
                            icon: const Icon(Icons.home_outlined, size: 18),
                            label: const Text('Volver al inicio'),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: brandPrimary),
                              foregroundColor: brandPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Text(
                    'IVCUSMI 2025 • Congreso Internacional de Medicina',
                    style: text.labelSmall?.copyWith(
                      color: const Color(0xFF6B7280),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BuildBadge extends StatelessWidget {
  const _BuildBadge();

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF387f4d);
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 92,
          height: 92,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [Color(0x2A387f4d), Colors.transparent],
              stops: [0.0, 1.0],
            ),
          ),
        ),
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0x1A387f4d),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0x30387f4d)),
          ),
          child: const Icon(Icons.hourglass_bottom, color: green, size: 28),
        ),
      ],
    );
  }
}

class _Tag extends StatelessWidget {
  final String text;
  const _Tag(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0x14387f4d),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0x20387f4d)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF1F2937),
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
