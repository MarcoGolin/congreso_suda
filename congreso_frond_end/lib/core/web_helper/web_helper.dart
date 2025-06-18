// archivo: web_helper.dart
import 'dart:html' as html;

void bloquearBotonAtrasNavegador() {
  html.window.history.replaceState(null, '', '/');
  html.window.onPopState.listen((event) {
    html.window.history.replaceState(null, '', '/');
  });
}
