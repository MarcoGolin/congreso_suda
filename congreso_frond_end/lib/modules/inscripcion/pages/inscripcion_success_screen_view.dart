import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class InscripcionSuccesScreenView extends StatelessWidget {
  const InscripcionSuccesScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 900;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FadeInDown(
            child: Image.asset(
              'assets/imagenes/logo/logo_congreso_largo.png',
              width: 400,
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
                    color: Color(0xFF387f4d),
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
                    backgroundColor: const Color(0xFF387f4d),
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
                FadeInUp(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Image.asset(
                      'assets/imagenes/logo/unisud_investigacion_verde.png',
                      width: isMobile ? 140 : 400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
