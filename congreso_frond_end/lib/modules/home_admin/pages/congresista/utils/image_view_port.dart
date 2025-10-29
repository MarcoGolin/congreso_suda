import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImageViewport extends StatelessWidget {
  final Uint8List bytes;
  final String fileNameWithExt;
  final String mimeType;
  const ImageViewport({
    super.key,
    required this.bytes,
    required this.fileNameWithExt,
    required this.mimeType,
  });

  @override
  Widget build(BuildContext context) {
    // Lienzo neutral y centrado, con zoom/pan.
    return Scaffold(
      appBar: AppBar(title: Text(fileNameWithExt)),
      body: Stack(
        children: [
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(blurRadius: 12, color: Colors.black12),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 5,
                  child: Image.memory(bytes, fit: BoxFit.contain),
                ),
              ),
            ),
          ),
          // // barra flotante
          // Positioned(
          //   left: 16,
          //   right: 16,
          //   bottom: 16,
          //   child: PdfFabBar(
          //     onDescargar: () => _descargar(context, bytes, fileNameWithExt),
          //     onCompartir: () =>
          //         _compartir(context, bytes, fileNameWithExt, mimeType),
          //     onImprimir: () => _imprimir(context, bytes),
          //   ),
          // ),
        ],
      ),
    );
  }

  Future<void> _compartir(
    BuildContext context,
    Uint8List bytes,
    String fileNameWithExt,
    String mimeType,
  ) async {
    // try {
    //   if (kIsWeb) {
    //     // En web, descargar directamente; compartir web requiere integración extra
    //     js.saveAs(bytes, fileNameWithExt);
    //     return;
    //   }

    //   // En móviles/desktop compartimos el binario
    //   await Share.shareXFiles([
    //     XFile.fromData(bytes, name: fileNameWithExt, mimeType: mimeType),
    //   ], text: 'Compartido desde FlexPDV');
    // } catch (e) {
    //   _toast(context, 'No se pudo compartir.');
    // }
  }

  Future<void> _descargar(
    BuildContext context,
    Uint8List bytes,
    String fileNameWithExt,
  ) async {
    // try {
    //   if (kIsWeb) {
    //     js.saveAs(bytes, fileNameWithExt);
    //     return;
    //   }
    //   final path = await FilePicker.platform.saveFile(
    //     dialogTitle: 'Guardar comprobante',
    //     fileName: fileNameWithExt,
    //   );
    //   if (path == null) return;
    //   final f = File(path);
    //   await f.writeAsBytes(bytes);
    //   if (!kIsWeb &&
    //       (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
    //     await OpenFile.open(path);
    //   }
    //   _toast(context, 'Archivo guardado');
    // } catch (e) {
    //   _toast(context, 'No se pudo guardar.');
    // }
  }

  Future<void> _imprimir(BuildContext context, Uint8List bytes) async {
    try {
      // Creamos un PDF temporal que contiene la imagen para poder imprimir
      // await Printing.layoutPdf(
      //   onLayout: (PdfPageFormat format) async {
      //     final doc = pw.Document();
      //     final image = pw.MemoryImage(bytes);
      //     doc.addPage(
      //       pw.Page(
      //         pageFormat: format,
      //         build: (_) =>
      //             pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain)),
      //       ),
      //     );
      //     return doc.save();
      //   },
      // );
    } catch (e) {
      _toast(context, 'No se pudo imprimir la imagen.');
    }
  }

  void _toast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
