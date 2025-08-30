import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mobx/mobx.dart';

mixin DefaultStateNotifier<T extends StatefulWidget> on State<T> {
  late ReactionDisposer _rctDspr;

  late dynamic _ctrl;

  var isOpen = false;

  // ignore: constant_identifier_names
  static const int TYPE_WARNING = 0;
  // ignore: constant_identifier_names
  static const int TYPE_SUCCESS = 1;
  // ignore: constant_identifier_names
  static const int TYPE_ERROR = 2;

  // ignore: constant_identifier_names
  static const String SAVE_SUCCES = 'Guardado con Éxito!';
  // ignore: constant_identifier_names
  static const String SAVE_ERROR = 'Error al Guardar!';

  late Color bkColor;
  Color txtColor = Colors.black87;
  // ignore: unused_local_variable
  late Color c1;
  // ignore: unused_local_variable
  late Color c2;

  @override
  void initState() {
    _reactions();
    super.initState();
  }

  @override
  void dispose() {
    _rctDspr();
    hideLoader();
    super.dispose();
  }

  //inicializa el mixin cargando el controlador
  void iniNotifierMixin(dynamic ctrl) {
    _ctrl = ctrl; // Asigna el controlador recibido al mixin
  }

  void showAlert(String message, int type) {
    late Color c1;
    Color txtColor = Colors.white;
    IconData icon;

    // Determinar colores y icono según el tipo
    if (type == 0) {
      bkColor = Colors.yellow;
      c1 = const Color(0xFFFFDD00);
      txtColor = Colors.black;
      icon = Icons.warning; // Icono de advertencia
    } else if (type == 1) {
      bkColor = Colors.green;
      c1 = const Color(0xFF00B712);
      icon = Icons.check_circle; // Icono de éxito
    } else if (type == 2) {
      bkColor = Colors.red;
      c1 = const Color(0xFFFE5858);
      icon = Icons.error; // Icono de error
    } else {
      // Default values if type is invalid
      c1 = Colors.grey;
      txtColor = Colors.white;
      icon = Icons.info; // Icono de información
    }

    // Texto predeterminado si está vacío
    if (message.isEmpty) {
      message = type == 0
          ? 'Atención'
          : type == 1
          ? '¡Guardado con éxito!'
          : '¡Error al guardar!';
    }

    // Crear el OverlayEntry
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top:
              MediaQuery.of(context).padding.top + 10, // Espaciado desde arriba
          // bottom: MediaQuery.of(context).padding.bottom + 10,
          right: 10, // Espaciado desde la derecha
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                // gradient: LinearGradient(colors: [c1, c2]),
                color: c1.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: txtColor, size: 24),
                  const SizedBox(width: 10), // Espaciado entre icono y texto
                  Text(
                    message,
                    style: TextStyle(
                      color: txtColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // Mostrar el OverlayEntry
    overlay.insert(overlayEntry);

    // Eliminar automáticamente después de 3 segundos
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  Future<dynamic> showAlertWarning(
    String message, {
    Widget? content,
    Function()? onPressed,
    Function()? onCancel,
    bool barrierDismissible = false,
  }) {
    return showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (BuildContext context) {
        return content ??
            AlertDialog(
              title: const Text(
                "Atención",
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Text(message, textAlign: TextAlign.center),
              actions: [
                if (onCancel != null)
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onCancel();
                    },
                    child: const Text("Cancelar"),
                  ),
                TextButton(
                  onPressed: onPressed != null
                      ? () {
                          Navigator.of(context).pop();
                          onPressed();
                        }
                      : () {
                          Navigator.of(context).pop();
                        },
                  child: const Text("Aceptar"),
                ),
              ],
            );
      },
    );
  }

  void showLoader() {
    if (isOpen) return;
    isOpen = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return LoadingAnimationWidget.threeArchedCircle(
          color: Colors.white,
          size: 60,
        );
      },
    );
  }

  void hideLoader() {
    if (isOpen) {
      isOpen = false;
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  void _reactions() {
    _rctDspr = reaction((_) => _ctrl.status, (status) async {
      switch (status) {
        case StatusEnumGlobal.loaded:
          hideLoader();
          break;
        case StatusEnumGlobal.loading:
          showLoader();
          break;
        case StatusEnumGlobal.success:
          hideLoader();
          showAlert(_ctrl.message, TYPE_SUCCESS);
          break;
        case StatusEnumGlobal.successAndBack:
          hideLoader();
          Modular.to.pop();
          showAlert(_ctrl.message, TYPE_SUCCESS);
          break;
        case StatusEnumGlobal.successAndNavigateHome:
          hideLoader();
          showAlert(_ctrl.message, TYPE_SUCCESS);
          Modular.to.navigate("/home_module/");
          break;
        case StatusEnumGlobal.successAndNavigateAtivarNovaConta:
          hideLoader();
          showAlert(_ctrl.message, TYPE_SUCCESS);
          Modular.to.navigate("/ativar_conta");
          break;
        case StatusEnumGlobal.warning:
          hideLoader();
          showAlert(_ctrl.message, TYPE_WARNING);
          FocusManager.instance.primaryFocus?.unfocus();
          break;
        case StatusEnumGlobal.error:
          hideLoader();
          await showAlertWarning(
            _ctrl.message.isEmpty ? "Error Inesperado" : _ctrl.message,
          );
          break;
        case StatusEnumGlobal.errorAndNavigateLogin:
          hideLoader();
          await showAlertWarning(
            _ctrl.message.isEmpty ? "Error Inesperado" : _ctrl.message,
            onPressed: () {
              Modular.to.popAndPushNamed("/login");
            },
          );
        case StatusEnumGlobal.impresoraNoSeleccionada:
          hideLoader();
          await showAlertWarning(
            _ctrl.message.isEmpty ? "Error Inesperado" : _ctrl.message,
            onPressed: () {},
          );
          break;
        default:
      }
    });
  }
}

enum StatusEnumGlobal {
  loaded,
  loading,
  loadingList,
  loadingOnly,
  loadingCaixa,
  success,
  successEmpty,
  successOther,
  successAndAction,
  successAndBack,
  successAndNavigateHome,
  successAndNavigateAtivarNovaConta,
  error,
  errorAndAction,
  errorAndNavigateLogin,
  errorDialog,
  warning,
  onlyWarning,
  impresoraNoSeleccionada,
  listaVacia,
  clear,
  printerAPIError,
  loadingQR,
  loadedQR,
  caixaFechado,
}

double calculateTextWidth(String text, TextStyle style) {
  final textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: ui.TextDirection.ltr,
  )..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size.width;
}
