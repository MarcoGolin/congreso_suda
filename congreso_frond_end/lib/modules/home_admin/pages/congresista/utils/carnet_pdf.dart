// ignore_for_file: constant_identifier_names

import 'package:congreso_evento/core/pdf/pdf_render.dart';
import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

const double _CARD_W = 10.5; // cm
const double _CARD_H = 14.8; // cm

const _assetCarnetParticipante = 'assets/carnet/participante.webp';
const _assetCarnetStaff = 'assets/carnet/staff.webp';

/// ---------- (A) WIDGET REUTILIZABLE DEL CARNET 10x15 ----------
pw.Widget _buildCarnetWidget(
  Usuario user, {
  required pw.ImageProvider fondo,
  required _PdfFonts fonts,
}) {
  final uuid = (user.uuid?.trim().isNotEmpty ?? false)
      ? user.uuid!.trim()
      : 'UUID-NO-DISPONIBLE';

  return pw.SizedBox(
    width: _CARD_W * PdfPageFormat.cm,
    height: _CARD_H * PdfPageFormat.cm,
    child: pw.Container(
      // Fondo de la tarjeta
      decoration: pw.BoxDecoration(
        image: pw.DecorationImage(image: fondo, fit: pw.BoxFit.cover),
        border: pw.Border(
          bottom: pw.BorderSide(color: PdfColors.blue, width: 0.5),
          right: pw.BorderSide(color: PdfColors.blue, width: 0.5),
        ),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Container(
            margin: const pw.EdgeInsets.only(top: 183),
            child: pw.Text(
              user.getTipo(),
              style: pw.TextStyle(
                fontSize: 28,
                fontWeight: pw.FontWeight.bold,
                font: fonts.montserratBold,
                color: PdfColor.fromInt(0xFFFFFFFF),
              ),
            ),
          ),

          pw.Container(
            width: 260,
            margin: const pw.EdgeInsets.only(top: 40),
            padding: const pw.EdgeInsets.all(10.0),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromInt(0xFFFFFFFF),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Row(
              children: [
                pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: uuid,
                  width: 3 * PdfPageFormat.cm,
                  height: 3 * PdfPageFormat.cm,
                ),
                pw.SizedBox(width: 5),
                pw.Expanded(
                  child: pw.Text(
                    user.nombreCompleto?.trim().isNotEmpty == true
                        ? user.nombreCompleto!.trim()
                        : 'Sin nombre',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      font: fonts.montserratBold,
                      color: PdfColor.fromInt(0xFF000000),
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// Usa tu _buildCarnetWidget(Usuario) existente (10x15 cm)

/// Genera 4 carnets por hoja (2x2) y ajusta la escala SOLO si hace falta.
/// Para ajuste perfecto sin escala, usá sheetFormat = PdfPageFormat(20cm, 30cm).
Future<Uint8List> buildCarnetsGridExactPdf(
  List<Usuario> users, {
  PdfPageFormat sheetFormat = PdfPageFormat.a4, // A4 por defecto
  bool showCropMarks = true,
}) async {
  final pdf = pw.Document();

  // Conversión práctica
  final gutter = 10.0; // mm -> cm

  // Área útil de la hoja (en cm)

  // Celdas deseadas (2x2)
  const cols = 2;
  const rows = 2;

  // Tamaño teórico de cada celda si NO escalamos

  // Factor de escala necesario para encajar en el área útil

  // No queremos escalar hacia arriba (respeta 10x15 o reduce si es necesario)

  // Tamaño de la celda final en cm considerando la escala aplicada
  final cellWcm = _CARD_W;
  final cellHcm = _CARD_H;

  final fondos = await _loadFondosCarnet();

  final fonts = await _loadPdfFonts();

  // Coordenadas helper
  pw.Widget cell(Usuario u) {
    final fondo = u.isStaff! ? fondos.staff : fondos.participante;
    return _buildCarnetWidget(u, fondo: fondo, fonts: fonts);
  }

  // Guías de corte finas (opcionales)

  // Render por páginas de 4 en 4
  for (var i = 0; i < users.length; i += 4) {
    final slice = users.sublist(
      i,
      (i + 4 > users.length) ? users.length : i + 4,
    );

    pdf.addPage(
      pw.Page(
        pageFormat: sheetFormat,
        build: (context) {
          // Grilla 2x2
          final children = <pw.Widget>[];
          for (var r = 0; r < rows; r++) {
            final rowChildren = <pw.Widget>[];
            for (var c = 0; c < cols; c++) {
              final idx = r * cols + c;
              rowChildren.add(
                pw.Container(
                  child: idx < slice.length
                      ? cell(slice[idx])
                      : pw.SizedBox(
                          width: cellWcm * PdfPageFormat.cm,
                          height: cellHcm * PdfPageFormat.cm,
                        ),
                ),
              );
            }
            children.add(pw.Row(children: rowChildren));
          }
          return pw.Column(children: children);
        },
      ),
    );
  }

  return pdf.save();
}

/// ---------- (B) PDF DE UN SOLO CARNET (igual que tenías) ----------
Future<Uint8List> buildCarnetPdf(Usuario user) async {
  final fondos = await _loadFondosCarnet();
  final fondo = user.isStaff! ? fondos.staff : fondos.participante;
  final fonts = await _loadPdfFonts();

  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(0),

      build: (_) => _buildCarnetWidget(user, fondo: fondo, fonts: fonts),
    ),
  );
  return pdf.save();
}

/// Abre el preview (tu flujo actual)
Future<void> printOrShareCarnet(Usuario user) async {
  final bytes = await buildCarnetPdf(user);
  Modular.to.push(
    MaterialPageRoute(
      builder: (_) => PdfRender(
        filaName: '${user.nombreCompleto}',
        pdf: bytes,
        isLoading: false,
        showFiltro: false,
      ),
    ),
  );
}

/// ---------- (C) PDF LOTE: 1 CARNET POR PÁGINA (igual que tenías) ----------
Future<Uint8List> buildCarnetsLotePdf(List<Usuario> users) async {
  final fondos = await _loadFondosCarnet();
  final fonts = await _loadPdfFonts();

  final pdf = pw.Document();
  for (final u in users) {
    final fondo = u.isStaff! ? fondos.staff : fondos.participante;
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(
          10 * PdfPageFormat.cm,
          14 * PdfPageFormat.cm,
          marginAll: 0,
        ),
        build: (_) => _buildCarnetWidget(u, fondo: fondo, fonts: fonts),
      ),
    );
  }
  return pdf.save();
}

Future<void> printOrShareCarnetsLote(List<Usuario> users) async {
  final bytes = await buildCarnetsLotePdf(users);
  await Printing.sharePdf(bytes: bytes, filename: 'carnets_congreso.pdf');
}

/// ---------- (D) NUEVO: PDF EN HOJAS CON 4 CARNETS POR HOJA ----------
Future<Uint8List> buildCarnetsGridPdf(
  List<Usuario> users, {
  PdfPageFormat sheetFormat = PdfPageFormat.a4, // A4 por defecto
  int columns = 2,
  int rows = 2,
  double cellPadding = 0, // espacio entre celdas/carnets
}) async {
  final pdf = pw.Document();
  final perPage = columns * rows;
  final fondos = await _loadFondosCarnet();
  final fonts = await _loadPdfFonts();

  for (var i = 0; i < users.length; i += perPage) {
    final slice = users.sublist(
      i,
      (i + perPage > users.length) ? users.length : i + perPage,
    );

    pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.all(0),
        pageFormat: sheetFormat,
        build: (context) {
          // Construimos una tabla rows x columns
          return pw.Column(
            children: List.generate(rows, (r) {
              return pw.Expanded(
                child: pw.Row(
                  children: List.generate(columns, (c) {
                    final idx = r * columns + c;
                    final hasData = idx < slice.length;

                    return pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(
                          color: PdfColors.blue,
                          width: 0.5,
                        ),
                      ),
                      child: hasData
                          ? pw.Center(
                              child: pw.FittedBox(
                                fit: pw.BoxFit.contain,
                                child: _buildCarnetWidget(
                                  slice[idx],
                                  fondo: (slice[idx].isStaff ?? false)
                                      ? fondos.staff
                                      : fondos.participante,
                                  fonts: fonts,
                                ),
                              ),
                            )
                          : pw.SizedBox.shrink(),
                    );
                  }),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  return pdf.save();
}

/// Atajo para abrir/compartir el PDF con 4 por hoja
Future<void> printOrShareCarnetsGrid(
  List<Usuario> users,
  String pdfName,
) async {
  if (users.isEmpty) return;
  final bytes = await buildCarnetsGridPdf(
    users,
    sheetFormat: PdfPageFormat.a4, // podés pasar PdfPageFormat.letter si querés
    columns: 2,
    rows: 2,
  );

  Modular.to.push(
    MaterialPageRoute(
      builder: (_) => PdfRender(
        filaName: pdfName,
        pdf: bytes,
        isLoading: false,
        showFiltro: false,
      ),
    ),
  );
}

class _FondosCarnet {
  final pw.MemoryImage participante;
  final pw.MemoryImage staff;
  _FondosCarnet({required this.participante, required this.staff});
}

Future<_FondosCarnet> _loadFondosCarnet() async {
  final pBytes = (await rootBundle.load(
    _assetCarnetParticipante,
  )).buffer.asUint8List();
  final sBytes = (await rootBundle.load(
    _assetCarnetStaff,
  )).buffer.asUint8List();
  return _FondosCarnet(
    participante: pw.MemoryImage(pBytes),
    staff: pw.MemoryImage(sBytes),
  );
}

class _PdfFonts {
  final pw.Font montserrat;
  final pw.Font montserratBold;
  _PdfFonts({required this.montserrat, required this.montserratBold});
}

_PdfFonts? _cachedFonts;
Future<_PdfFonts> _loadPdfFonts() async {
  if (_cachedFonts != null) return _cachedFonts!;
  _cachedFonts = _PdfFonts(
    montserrat: await PdfGoogleFonts.montserratRegular(),
    montserratBold: await PdfGoogleFonts.montserratBold(),
  );
  return _cachedFonts!;
}
