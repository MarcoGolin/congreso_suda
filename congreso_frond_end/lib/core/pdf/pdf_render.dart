import 'dart:io';

import 'package:congreso_evento/core/buttons/elevated_button_with_loader.dart';
import 'package:congreso_evento/core/empty_result.dart';
import 'package:congreso_evento/core/formater/date_formater.dart';
import 'package:congreso_evento/core/inputs/date/period_field.dart';
import 'package:congreso_evento/core/js_cross_platform/js_cross_platform.dart'
    as js;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import 'pdf_filtro_render.dart';

class PdfRender extends StatefulWidget {
  final String filaName;
  final Uint8List? pdf;
  final Future<Uint8List?> Function()? geraXlsx;
  final bool isLoading;
  final List<Widget>? filtros;
  final Future<Uint8List?> Function(List<String>? periodo)? gerarRelatorio;
  final bool showPeridoSelect;
  final bool? showFiltro;
  const PdfRender({
    super.key,
    required this.filaName,
    this.pdf,
    this.geraXlsx,
    required this.isLoading,
    this.filtros,
    this.gerarRelatorio,
    this.showPeridoSelect = false,
    this.showFiltro = true,
  });

  @override
  State<PdfRender> createState() => _PdfRenderState();
}

class _PdfRenderState extends State<PdfRender> {
  final _periodoTxtCtrl = TextEditingController();

  final List<Widget> _widgets = [];

  final dtf = DateFormat('yyyy-MM-dd', 'es_PY');

  Uint8List? pdfLocal;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    if (widget.pdf != null) {
      pdfLocal = widget.pdf;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scaffoldKey.currentState?.openEndDrawer();
    });

    _widgets.add(
      PdfPreviewAction(
        icon: const FaIcon(FontAwesomeIcons.download),
        onPressed: (context, format, onPressed) => _export('pdf'),
      ),
    );

    if (widget.geraXlsx != null) {
      _widgets.add(
        PdfPreviewAction(
          icon: const FaIcon(FontAwesomeIcons.fileExcel),
          onPressed: (context, format, onPressed) => _export('xlsx'),
        ),
      );
    }

    _widgets.add(
      PdfPreviewAction(
        icon: const FaIcon(FontAwesomeIcons.shareNodes),
        onPressed: (context, format, onPressed) =>
            _compartir(bytes: pdfLocal!, fileName: widget.filaName),
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _periodoTxtCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    final appBar = AppBar(
      title: Text(
        widget.filaName,
        style: TextStyle(color: Colors.black, fontSize: isMobile ? 12 : 24),
      ),
      actions: [
        if (isMobile)
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
      ],
    );

    final pdfFiltros = PdfFiltroRender(
      filtros: [
        ...widget.filtros ?? [],
        Visibility(
          visible: widget.showPeridoSelect,
          child: Column(
            children: [
              PeriodField(
                date: '',
                selectedPeriod: (value) => widget.gerarRelatorio?.call(value),
                label: "Periodo",
                controller: _periodoTxtCtrl,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    child: Text(resolveMesAtualEmLetras()),
                    onPressed: () {
                      final now = DateTime.now();
                      final dt = DateTime(now.year, now.month, 1);
                      final dtFinal = resolveUltimoDiaMes(dateTime: dt);
                      _periodoTxtCtrl.text =
                          '${formatDateWithLocal(dtf.format(dt))} - ${formatDateWithLocal(dtf.format(dtFinal.subtract(const Duration(days: 1))))}';

                      _geraPeriodoPorDia(dt, dtFinal);
                    },
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    child: const Text('Ayer'),
                    onPressed: () {
                      DateTime now = DateTime.now();
                      DateTime dt = DateTime(now.year, now.month, now.day - 1);
                      _periodoTxtCtrl.text =
                          '${formatDateWithLocal(dtf.format(dt))} - ${formatDateWithLocal(dtf.format(dt))}';
                      _geraPeriodoPorDia(dt, dt);
                    },
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    child: const Text('Hoy'),
                    onPressed: () {
                      DateTime dt = DateTime.now();
                      _periodoTxtCtrl.text =
                          '${formatDateWithLocal(dtf.format(dt))} - ${formatDateWithLocal(dtf.format(dt))}';
                      _geraPeriodoPorDia(dt, dt);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButtonWithLoader(
          isLoading: widget.isLoading,
          label: 'Generar',
          onPressed: () async {
            final result = await widget.gerarRelatorio?.call(null);
            if (result != null) {
              setState(() {
                pdfLocal = result;
              });
            }
          },
        ),
      ],
    );

    return Row(
      children: [
        Expanded(
          child: Visibility(
            visible: !widget.isLoading,
            replacement: Scaffold(
              appBar: appBar,
              body: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 10),
                    Text('Generando Reporte, aguarde...'),
                  ],
                ),
              ),
            ),
            child: Scaffold(
              key: _scaffoldKey,
              appBar: appBar,
              endDrawer: isMobile
                  ? widget.showFiltro == true
                        ? Drawer(child: pdfFiltros)
                        : null
                  : null,
              body: pdfLocal != null
                  ? PdfPreview(
                      allowSharing: false,
                      canChangePageFormat: false,
                      maxPageWidth: 800,
                      allowPrinting: true,
                      canChangeOrientation: false,
                      previewPageMargin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      onPrintError: (context, error) => Text(error),
                      build: (format) => pdfLocal!,
                      actions: _widgets,
                      actionBarTheme: PdfActionBarTheme(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  : const Center(
                      child: EmptyResult(title: 'Nada que mostrar!'),
                    ),
            ),
          ),
        ),
        if (!isMobile)
          widget.showFiltro == true ? pdfFiltros : const SizedBox.shrink(),
      ],
    );
  }

  void _export(String type) async {
    String? finalDir = '';
    String? path = '';
    String fileName = '${widget.filaName}.$type';

    List<int>? bytes = pdfLocal;

    if (bytes == null) {
      // Alert.show('No pudimos generar el archivo', Alert.ERROR);
      return;
    }

    if (type == 'xlsx') {
      bytes = await widget.geraXlsx?.call();
    }

    // Define una expresión regular para los caracteres no permitidos

    // Reemplaza los caracteres no permitidos por una cadena vacía
    fileName = sanitizeFileName(fileName);

    try {
      if (kIsWeb) {
        js.saveAs(bytes!, fileName);

        // js.useContext().callMethod("saveAs", <Object>[
        //   html.useBlob(<Object>[bytes]),
        //   fileName
        // ]);
      } else {
        if (Platform.isAndroid) {
          try {
            path = await createFolderInAppDocDir();
            finalDir = '$path/${widget.filaName}.$type';
            debugPrint(finalDir);
          } catch (e) {
            // Alert.show('No pudimos guardar el archivo', Alert.ERROR);
            return;
          }
          var file = await File(finalDir).writeAsBytes(bytes!);
          await Printing.sharePdf(
            bytes: file.readAsBytesSync(),
            filename: fileName,
          );
        } else {
          finalDir = await FilePicker.platform.saveFile(
            dialogTitle: 'Eliga una carpeta de destino:',
            fileName: fileName,
          );
          if (finalDir == null) {
            return;
          }
          //guardar
          await File(finalDir).writeAsBytes(bytes!);
          await OpenFile.open(finalDir);
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  String sanitizeFileName(String input) {
    // Reemplazar caracteres inválidos (incluye \n, \r, tabs, etc.)
    final invalidChars = RegExp(r'[<>:"/\\|?*\x00-\x1F]');
    var sanitized = input.replaceAll(invalidChars, " ");

    // Quitar espacios o puntos al final (no válidos en Windows)
    sanitized = sanitized.replaceAll(RegExp(r'[ .]+$'), "");

    // Evitar nombres reservados en Windows
    const reserved = {
      "CON",
      "PRN",
      "AUX",
      "NUL",
      "COM1",
      "COM2",
      "COM3",
      "COM4",
      "COM5",
      "COM6",
      "COM7",
      "COM8",
      "COM9",
      "LPT1",
      "LPT2",
      "LPT3",
      "LPT4",
      "LPT5",
      "LPT6",
      "LPT7",
      "LPT8",
      "LPT9",
    };
    if (reserved.contains(sanitized.toUpperCase())) {
      sanitized = "_$sanitized";
    }

    // Evitar vacío
    if (sanitized.isEmpty) sanitized = "archivo";

    // Limitar a 255 caracteres (típico máximo en FS)
    if (sanitized.length > 255) {
      sanitized = sanitized.substring(0, 255);
    }

    return sanitized;
  }

  Future<String> createFolderInAppDocDir() async {
    final Directory? appDocDir = await getExternalStorageDirectory();
    final Directory appDocDirFolder = Directory('${appDocDir!.path}/FlexPdv');

    if (await appDocDirFolder.exists()) {
      return appDocDirFolder.path;
    } else {
      final Directory appDocDirNewFolder = await appDocDirFolder.create(
        recursive: true,
      );
      debugPrint(appDocDirNewFolder.path);
      return appDocDirNewFolder.path;
    }
  }

  void _geraPeriodoPorDia(DateTime dtIni, DateTime? dtFim) {
    List<String> periodo = [
      sqlDateFormat(dtIni.toString().replaceRange(10, null, 'T00:00:00')),
      sqlDateFormat(dtFim.toString().replaceRange(10, null, 'T23:59:59')),
    ];
    widget.gerarRelatorio?.call(periodo);
  }

  void _compartir({required Uint8List bytes, required String fileName}) async {
    fileName = sanitizeFileName(fileName);

    Share.shareXFiles(
      [XFile.fromData(bytes, mimeType: 'application/pdf')],
      fileNameOverrides: ['$fileName.pdf'],
    );
  }
}
