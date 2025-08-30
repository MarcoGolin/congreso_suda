import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PaginaNoEncontradaPage extends StatelessWidget {
  const PaginaNoEncontradaPage({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('*** PaginaNoEncontradaPage build ***');
    debugPrint(Modular.to.path);
    return Scaffold(
      backgroundColor: const Color(0xFF121A14),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '404',
                style: TextStyle(
                  fontSize: 96,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'No encontramos esa página',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.white70),
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                children: [
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF387f4d),
                    ),
                    onPressed: () => Modular.to.navigate('/'),
                    child: const Text('Ir al inicio'),
                  ),
                  OutlinedButton(
                    onPressed: () => Modular.to.maybePop(),
                    child: const Text('Volver'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
