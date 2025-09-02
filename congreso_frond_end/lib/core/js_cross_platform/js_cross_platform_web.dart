// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html' as html;
import 'dart:js' as js;
import 'dart:typed_data';

void saveAs(List<int> bytes, String fileName) {
  js.context.callMethod(
    "saveAs",
    <Object>[
      html.Blob(<Object>[bytes]),
      fileName
    ],
  );
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
