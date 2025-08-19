// archivo: web_helper.dart
import 'dart:html' as html;
import 'dart:ui_web' as ui;

void bloquearBotonAtrasNavegador() {
  html.window.history.replaceState(null, '', '/');
  html.window.onPopState.listen((event) {
    html.window.history.replaceState(null, '', '/');
  });
}

void cierraPreLoader() {
  // Podés retrasarlo hasta que terminen tus cargas iniciales si querés
  html.window.dispatchEvent(html.CustomEvent('app-ready'));
}

void openExternalUrl(String url) {
  html.window.open(url, '_blank');
}

void visualizarMapa(String url) {
  final String viewType = 'gmap-embed-${DateTime.now().microsecondsSinceEpoch}';
  final iframe = html.IFrameElement()
    ..src = url
    ..style.border = '0'
    ..style.width = '100%'
    ..style.height = '100%'
    ..setAttribute('loading', 'lazy')
    ..setAttribute('referrerpolicy', 'no-referrer-when-downgrade')
    ..allowFullscreen = true;

  ui.platformViewRegistry.registerViewFactory(viewType, (int viewId) => iframe);
}
