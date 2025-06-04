import 'package:flutter/material.dart';

import 'app_loader.dart';

class LoadingOverlay {
  OverlayEntry? _overlay;

  /// Muestra el overlay de carga.
  ///
  /// [context] El BuildContext actual.
  /// [future] El Future que se está esperando. Cuando este Future se completa,
  /// el overlay se oculta automáticamente.
  void show(BuildContext context, Future<void> future) {
    if (_overlay != null) return; // Evita mostrar múltiples overlays

    _overlay = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Fondo semitransparente para oscurecer el contenido debajo
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(
                0.5,
              ), // Fondo oscuro semitransparente
            ),
          ),
          // Centra el AppLoader en el overlay
          const Center(
            child: AppLoader(), // Tu componente de loader
          ),
        ],
      ),
    );

    // Inserta el overlay en el árbol de widgets
    Overlay.of(context).insert(_overlay!);

    // Cuando el future se completa, oculta el overlay
    future
        .whenComplete(() {
          hide();
        })
        .onError((error, stackTrace) {
          // Manejo de errores: si el future falla, también oculta el overlay
          hide();
          // Opcional: mostrar un mensaje de error al usuario
          print('Error en el future del loader: $error');
        });
  }

  /// Oculta el overlay de carga.
  void hide() {
    if (_overlay != null) {
      _overlay!.remove(); // Elimina el overlay del árbol de widgets
      _overlay = null; // Resetea la referencia
    }
  }
}
