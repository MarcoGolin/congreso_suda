import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class IngresoRestringidoPage extends StatelessWidget {
  const IngresoRestringidoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Acceso restringido'),
        backgroundColor: const Color(0xFF73c165),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
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
              child: LayoutBuilder(
                builder: (context, cts) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const _LockBadge(),
                      const SizedBox(height: 12),

                      // Título
                      Text(
                        '403 — Acceso restringido',
                        style: text.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1F2937),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),

                      // Mensaje
                      Text(
                        'No tenés permisos suficientes para acceder a esta sección.\n'
                        'Si necesitás acceso, comunicate con el equipo del congreso.',
                        style: text.bodyMedium?.copyWith(
                          color: const Color(0xFF4B5563),
                          height: 1.35,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 16),

                      SizedBox(
                        width: double.infinity,
                        height: 42,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Modular.to.pushNamedAndRemoveUntil(
                              '/',
                              ModalRoute.withName('/'),
                            );
                          }, // UI solamente
                          icon: const Icon(
                            Icons.home_outlined,
                            size: 18,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Volver al inicio',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF387f4d),
                            disabledForegroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                        ),
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
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LockBadge extends StatelessWidget {
  const _LockBadge();

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
          child: const Icon(Icons.lock_outline, color: green, size: 28),
        ),
      ],
    );
  }
}
