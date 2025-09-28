import 'dart:typed_data';

void saveAs(List<int> bytes, String fileName) {}

void imprimir(List<int> bytes, String fileName) {}

void imprimirBlob(blob) {}

void openPDF(Uint8List? data, String fileName) {}

void downlodImage(String url, String fileName) {}

/// Descarga un archivo desde una URL (versión no-op para móvil)
Future<void> downloadFromUrl(String url, String fileName) async {
  // No-op para plataformas no web
}

/// Obtiene información del archivo (versión no-op para móvil)
Future<Map<String, dynamic>> getFileInfo(String url) async {
  return {'size': 0, 'type': 'application/octet-stream'};
}
