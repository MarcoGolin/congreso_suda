import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SuccessScreenView extends StatelessWidget {
  const SuccessScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FadeInDown(
            child: Image.asset(
              'assets/imagenes/logo/logo_congreso_largo.png',
              width: 300,
            ),
          ),

          Expanded(
            child: ListView(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 80),
                const SizedBox(height: 16),
                Text(
                  '¡Preinscripción completada exitosamente!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0C4793),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Gracias por completar tu preinscripción. En breve recibirás un correo electrónico con los detalles de tu registro y las instrucciones para validar tu usuario.',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 24,
                    ),
                    backgroundColor: const Color(0xFF0C4793),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Modular.to.navigate(
                      '/',
                      arguments: {
                        'message': '¡Gracias por tu preinscripción!',
                        'type': 'success',
                      },
                    );
                  },
                  child: const Text(
                    'Volver al inicio',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          FadeInUp(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 5),
              child: Wrap(
                spacing: isMobile ? 20 : 50,
                runSpacing: isMobile ? 20 : 50,
                alignment: WrapAlignment.center,
                children: [
                  Image.asset(
                    'assets/imagenes/logo/suda_logo_largo.png',
                    width: isMobile ? 140 : 200,
                  ),
                  Image.asset(
                    'assets/imagenes/logo/suda_inv_logo_largo.png',
                    width: isMobile ? 140 : 200,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
