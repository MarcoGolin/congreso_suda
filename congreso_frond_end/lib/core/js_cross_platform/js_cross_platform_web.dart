// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:typed_data';

void saveAs(List<int> bytes, String fileName) {
  js.context.callMethod("saveAs", <Object>[
    html.Blob(<Object>[bytes]),
    fileName,
  ]);
}

void imprimir(List<int> bytes, String fileName) {
  final blob = html.Blob(<Object>[bytes]);
  imprimirBlob(blob);
}

void imprimirBlob(html.Blob? blob) {
  // Crear un objeto URL para el blob
  final url = html.Url.createObjectUrlFromBlob(blob!);

  // Abrir la URL en una nueva ventana o pestaña para que el usuario pueda imprimir
  js.context.callMethod('open', [url, '_blank']);

  // Liberar el objeto URL después de un cierto tiempo para liberar memoria
  html.window.onUnload.listen((_) {
    html.Url.revokeObjectUrl(url);
  });
}

void openPDF(Uint8List? data, String fileName) {
  // await Printing.sharePdf(
  //   bytes: data!,
  //   filename: '$fileName$fileExtension',
  // );
  // Crear un blob y una URL para el archivo PDF
  final blob = html.Blob([data!], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);

  // Crear un elemento de anclaje para descargar el archivo
  html.AnchorElement(href: url)
    ..setAttribute('download', fileName)
    ..click();

  // Abrir el PDF en una nueva pestaña o ventana
  html.window.open(url, '_blank');

  // Liberar la URL del objeto después de la descarga
  html.Url.revokeObjectUrl(url);
}

void downlodImage(String url, String fileName) {
  html.AnchorElement(href: url)
    ..setAttribute('download', fileName)
    ..click();
}

/// Descarga un archivo desde una URL (útil para archivos de Supabase)
Future<void> downloadFromUrl(String url, String fileName) async {
  try {
    // Método 1: Intentar descarga directa (funciona si no hay CORS)
    try {
      html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..setAttribute('target', '_blank')
        ..click();
      return; // Si llegamos aquí, la descarga directa funcionó
    } catch (e) {
      // Si falla, intentar método alternativo
    }

    // Método 2: Usar fetch API para manejar CORS y obtener blob
    final response = await html.window.fetch(url, {
      'method': 'GET',
      'mode': 'cors',
    });

    if (response.ok) {
      final blob = await response.blob();
      final objectUrl = html.Url.createObjectUrlFromBlob(blob);

      html.AnchorElement(href: objectUrl)
        ..setAttribute('download', fileName)
        ..click();

      // Limpiar la URL del objeto después de un breve delay
      Future.delayed(const Duration(milliseconds: 100), () {
        html.Url.revokeObjectUrl(objectUrl);
      });
    } else {
      throw Exception('Error HTTP: ${response.status} ${response.statusText}');
    }
  } catch (e) {
    // Método 3: Fallback - abrir en nueva pestaña
    try {
      html.window.open(url, '_blank');
    } catch (fallbackError) {
      throw Exception('Error en descarga y fallback: $e | $fallbackError');
    }
  }
}

/// Obtiene información del archivo (tamaño) sin descargarlo
Future<Map<String, dynamic>> getFileInfo(String url) async {
  try {
    final response = await html.window.fetch(url, {
      'method': 'HEAD',
      'mode': 'cors',
    });

    if (response.ok) {
      final contentLength = response.headers['content-length'];
      final contentType = response.headers['content-type'];

      return {
        'size': contentLength != null ? int.tryParse(contentLength) ?? 0 : 0,
        'type': contentType ?? 'application/octet-stream',
      };
    } else {
      throw Exception('Error al obtener info: ${response.status}');
    }
  } catch (e) {
    return {'size': 0, 'type': 'application/octet-stream'};
  }
}
