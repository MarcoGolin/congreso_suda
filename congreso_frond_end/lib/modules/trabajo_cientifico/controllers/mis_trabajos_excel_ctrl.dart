import 'dart:io';

import 'package:congreso_evento/core/js_cross_platform/js_cross_platform.dart'
    as js;
import 'package:congreso_evento/modules/trabajo_cientifico/models/trabajo_cientifico.dart';
import 'package:excel/excel.dart' as xl;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

part 'mis_trabajos_excel_ctrl.g.dart';

class MisTrabajosCientificosExcelCtrl = MisTrabajosCientificosExcelCtrlBase
    with _$MisTrabajosCientificosExcelCtrl;

abstract class MisTrabajosCientificosExcelCtrlBase with Store {
  /// Construye la URL completa de Supabase a partir del path almacenado en la BD
  String _construirUrlSupabase(String pathBD) {
    const baseUrl =
        'https://lkuedzsknoimbhwlavcy.supabase.co/storage/v1/object/public';
    return '$baseUrl/$pathBD';
  }

  /// Categorías de columnas organizadas por tipo
  final Map<String, List<String>> categoriaColumnas = {
    'Información Básica': [
      'ID',
      'Título',
      'Modalidad',
      'Área Temática',
      'Área de Medicina',
    ],
    'Información del Autor': [
      'Autor Nombre',
      'Autor Email',
      'Autor Teléfono',
      'Autor Filiación',
    ],
    'Contenido': ['Resumen', 'Palabras Clave', 'Coautores'],
    'Archivos y Enlaces': ['Archivo Word URL', 'Archivo PDF URL'],
    'Información del Sistema': ['Fecha Registro', 'Fecha Actualización'],
  };

  /// Todas las columnas posibles
  final List<String> todasLasColumnas = [
    'ID',
    'Título',
    'Modalidad',
    'Área Temática',
    'Área de Medicina',
    'Autor Nombre',
    'Autor Email',
    'Autor Teléfono',
    'Autor Filiación',
    'Resumen',
    'Palabras Clave',
    'Coautores',
    'Archivo Word URL',
    'Archivo PDF URL',
    'Fecha Registro',
    'Fecha Actualización',
  ];

  /// Ordenamiento seleccionado
  @observable
  String ordenamientoSeleccionado = 'titulo_asc';

  /// Estado del diálogo de exportación
  @observable
  bool mostrarDialogoExportacion = false;

  /// Selección por categoría
  @observable
  ObservableMap<String, bool> categoriasSeleccionadas =
      ObservableMap<String, bool>();

  /// Columnas individuales seleccionadas por categoría
  @observable
  ObservableMap<String, ObservableList<String>> columnasPorCategoria =
      ObservableMap<String, ObservableList<String>>();

  /// Columnas seleccionadas para exportar
  @observable
  ObservableList<String> columnasSeleccionadas = ObservableList<String>();

  /// Estado de carga
  @observable
  bool isLoading = false;

  /// Opciones de ordenamiento
  final Map<String, String> opcionesOrdenamiento = {
    'Título (A-Z)': 'titulo_asc',
    'Título (Z-A)': 'titulo_desc',
    'Autor (A-Z)': 'autor_asc',
    'Autor (Z-A)': 'autor_desc',
    'Fecha Registro (Más reciente)': 'fechaRegistro_desc',
    'Fecha Registro (Más antiguo)': 'fechaRegistro_asc',
    'Modalidad': 'modalidad_asc',
    'Área Temática': 'areaTematica_asc',
  };

  /// Inicializa categorías y columnas seleccionadas
  @action
  void inicializarSeleccionColumnas() {
    categoriasSeleccionadas.clear();
    columnasPorCategoria.clear();
    columnasSeleccionadas.clear();

    // Inicializar todas las categorías como seleccionadas
    for (final categoria in categoriaColumnas.keys) {
      categoriasSeleccionadas[categoria] = true;
      columnasPorCategoria[categoria] = ObservableList<String>.of(
        categoriaColumnas[categoria]!,
      );
    }

    // Actualizar columnas seleccionadas
    _actualizarColumnasSeleccionadas();
  }

  /// Actualiza la lista de columnas seleccionadas basada en las categorías
  @action
  void _actualizarColumnasSeleccionadas() {
    columnasSeleccionadas.clear();
    for (final categoria in categoriaColumnas.keys) {
      if (categoriasSeleccionadas[categoria] == true) {
        final columnasCategoria = columnasPorCategoria[categoria] ?? [];
        for (final columna in categoriaColumnas[categoria]!) {
          if (columnasCategoria.contains(columna)) {
            columnasSeleccionadas.add(columna);
          }
        }
      }
    }
  }

  /// Selecciona/deselecciona una categoría completa
  @action
  void toggleCategoria(String categoria) {
    final isSelected = categoriasSeleccionadas[categoria] ?? false;
    categoriasSeleccionadas[categoria] = !isSelected;

    if (!isSelected) {
      // Si se selecciona la categoría, crear nueva lista con todas las columnas
      columnasPorCategoria[categoria] = ObservableList<String>.of(
        categoriaColumnas[categoria] ?? [],
      );
    } else {
      // Si se deselecciona, crear lista vacía
      columnasPorCategoria[categoria] = ObservableList<String>();
    }

    _actualizarColumnasSeleccionadas();
  }

  /// Selecciona/deselecciona una columna específica
  @action
  void toggleColumna(String categoria, String columna) {
    // Asegurar que la categoría tenga una lista inicializada
    if (columnasPorCategoria[categoria] == null) {
      columnasPorCategoria[categoria] = ObservableList<String>();
    }

    final columnasCategoria = columnasPorCategoria[categoria]!;

    if (columnasCategoria.contains(columna)) {
      columnasCategoria.remove(columna);
    } else {
      columnasCategoria.add(columna);
    }

    // Actualizar estado de la categoría
    categoriasSeleccionadas[categoria] = columnasCategoria.isNotEmpty;

    _actualizarColumnasSeleccionadas();
  }

  /// Selecciona todas las columnas
  @action
  void seleccionarTodasLasColumnas() {
    for (final categoria in categoriaColumnas.keys) {
      categoriasSeleccionadas[categoria] = true;
      columnasPorCategoria[categoria] = ObservableList<String>.of(
        categoriaColumnas[categoria] ?? [],
      );
    }
    _actualizarColumnasSeleccionadas();
  }

  /// Deselecciona todas las columnas
  @action
  void deseleccionarTodasLasColumnas() {
    for (final categoria in categoriaColumnas.keys) {
      categoriasSeleccionadas[categoria] = false;
      columnasPorCategoria[categoria] = ObservableList<String>();
    }
    _actualizarColumnasSeleccionadas();
  }

  /// Establece el ordenamiento seleccionado
  @action
  void setOrdenamientoSeleccionado(String ordenamiento) {
    ordenamientoSeleccionado = ordenamiento;
  }

  /// Muestra el diálogo de selección de columnas
  @action
  void mostrarDialogoSeleccionColumnas() {
    inicializarSeleccionColumnas();
    mostrarDialogoExportacion = true;
  }

  /// Oculta el diálogo de selección de columnas
  @action
  void ocultarDialogoSeleccionColumnas() {
    mostrarDialogoExportacion = false;
  }

  /// Confirma la exportación con las columnas seleccionadas
  @action
  Future<void> confirmarExportacion(List<TrabajoCientifico> trabajos) async {
    ocultarDialogoSeleccionColumnas();

    try {
      isLoading = true;
      await _generarExcelCompleto(trabajos);
    } catch (e) {
      debugPrint('Error al exportar: $e');
      rethrow;
    } finally {
      isLoading = false;
    }
  }

  /// Ordena la lista de trabajos según el criterio seleccionado
  List<TrabajoCientifico> _ordenarTrabajos(List<TrabajoCientifico> trabajos) {
    final trabajosOrdenados = List<TrabajoCientifico>.from(trabajos);

    switch (ordenamientoSeleccionado) {
      case 'titulo_asc':
        trabajosOrdenados.sort((a, b) => a.titulo.compareTo(b.titulo));
        break;
      case 'titulo_desc':
        trabajosOrdenados.sort((a, b) => b.titulo.compareTo(a.titulo));
        break;
      case 'autor_asc':
        trabajosOrdenados.sort(
          (a, b) => a.autorNombre.compareTo(b.autorNombre),
        );
        break;
      case 'autor_desc':
        trabajosOrdenados.sort(
          (a, b) => b.autorNombre.compareTo(a.autorNombre),
        );
        break;
      case 'fechaRegistro_desc':
        trabajosOrdenados.sort((a, b) {
          if (a.fechaRegistro == null && b.fechaRegistro == null) return 0;
          if (a.fechaRegistro == null) return 1;
          if (b.fechaRegistro == null) return -1;
          return b.fechaRegistro!.compareTo(a.fechaRegistro!);
        });
        break;
      case 'fechaRegistro_asc':
        trabajosOrdenados.sort((a, b) {
          if (a.fechaRegistro == null && b.fechaRegistro == null) return 0;
          if (a.fechaRegistro == null) return 1;
          if (b.fechaRegistro == null) return -1;
          return a.fechaRegistro!.compareTo(b.fechaRegistro!);
        });
        break;
      case 'modalidad_asc':
        trabajosOrdenados.sort((a, b) => a.modalidad.compareTo(b.modalidad));
        break;
      case 'areaTematica_asc':
        trabajosOrdenados.sort(
          (a, b) => a.areaTematica.compareTo(b.areaTematica),
        );
        break;
    }

    return trabajosOrdenados;
  }

  Future<void> _generarExcelCompleto(List<TrabajoCientifico> trabajos) async {
    // Crear nuevo Excel
    final excel = xl.Excel.createExcel();

    // Crear la sheet principal
    final sheet = excel['Trabajos Científicos'];

    // Ordenar trabajos según el criterio seleccionado
    final trabajosOrdenados = _ordenarTrabajos(trabajos);

    // Usar solo las columnas seleccionadas en el orden correcto
    final headers = <String>[];
    for (final categoria in categoriaColumnas.keys) {
      if (categoriasSeleccionadas[categoria] == true) {
        final columnasCategoria = columnasPorCategoria[categoria] ?? [];
        for (final columna in categoriaColumnas[categoria]!) {
          if (columnasCategoria.contains(columna)) {
            headers.add(columna);
          }
        }
      }
    }

    // Si no hay columnas seleccionadas, usar todas
    if (headers.isEmpty) {
      headers.addAll(todasLasColumnas);
    }

    // Escribir headers
    for (int i = 0; i < headers.length; i++) {
      final cell = sheet.cell(
        xl.CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
      );
      cell.value = xl.TextCellValue(headers[i]);
      cell.cellStyle = xl.CellStyle(
        backgroundColorHex: xl.ExcelColor.fromHexString('#387f4d'),
        fontColorHex: xl.ExcelColor.fromHexString('#FFFFFF'),
        bold: true,
      );
    }

    // Escribir datos
    for (int rowIndex = 0; rowIndex < trabajosOrdenados.length; rowIndex++) {
      final trabajo = trabajosOrdenados[rowIndex];
      final dataRow = rowIndex + 1;

      Map<String, dynamic> datos = {
        'ID': trabajo.id?.toString() ?? '',
        'Título': trabajo.titulo,
        'Modalidad': trabajo.modalidad,
        'Área Temática': trabajo.areaTematica,
        'Área de Medicina': trabajo.areaDeLaMedicina,
        'Autor Nombre': trabajo.autorNombre,
        'Autor Email': trabajo.autorEmail,
        'Autor Teléfono': trabajo.autorTelefono,
        'Autor Filiación': trabajo.autorFiliacion,
        'Resumen': trabajo.resumen ?? '',
        'Coautores': trabajo.coautores
            .map((c) => '${c.nombre} (${c.email})')
            .join('; '),
        'Archivo Word URL': trabajo.archivoWordUrl.isNotEmpty
            ? _construirUrlSupabase(trabajo.archivoWordUrl)
            : '',
        'Archivo PDF URL':
            trabajo.archivoPdfUrl != null && trabajo.archivoPdfUrl!.isNotEmpty
            ? _construirUrlSupabase(trabajo.archivoPdfUrl!)
            : '',
        'Fecha Registro': trabajo.fechaRegistro != null
            ? DateFormat('dd/MM/yyyy HH:mm').format(trabajo.fechaRegistro!)
            : '',
      };

      for (int colIndex = 0; colIndex < headers.length; colIndex++) {
        final columna = headers[colIndex];
        final cell = sheet.cell(
          xl.CellIndex.indexByColumnRow(
            columnIndex: colIndex,
            rowIndex: dataRow,
          ),
        );

        // Verificar si es una columna de URL para crear hipervínculo
        if ((columna == 'Archivo Word URL' || columna == 'Archivo PDF URL') &&
            datos[columna] != null &&
            datos[columna].toString().isNotEmpty) {
          final url = datos[columna].toString();
          final linkText = columna == 'Archivo Word URL'
              ? '📄 Descargar Word'
              : '📄 Descargar PDF';

          // Crear hipervínculo clicable usando la función correcta
          cell.value = xl.FormulaCellValue('HYPERLINK("$url", "$linkText")');
          cell.cellStyle = xl.CellStyle(
            fontColorHex: xl.ExcelColor.fromHexString('#0066CC'),
            underline: xl.Underline.Single,
            bold: false,
            backgroundColorHex: rowIndex % 2 == 0
                ? xl.ExcelColor.fromHexString('#F9FAFB')
                : xl.ExcelColor.none,
          );
        } else if (columna == 'Autor Email' &&
            datos[columna] != null &&
            datos[columna].toString().isNotEmpty) {
          // Crear hipervínculo mailto para emails
          final email = datos[columna].toString();
          cell.value = xl.FormulaCellValue(
            'HYPERLINK("mailto:$email", "$email")',
          );
          cell.cellStyle = xl.CellStyle(
            fontColorHex: xl.ExcelColor.fromHexString('#0066CC'),
            underline: xl.Underline.Single,
            backgroundColorHex: rowIndex % 2 == 0
                ? xl.ExcelColor.fromHexString('#F9FAFB')
                : xl.ExcelColor.none,
          );
        } else {
          // Para columnas normales
          cell.value = xl.TextCellValue(datos[columna]?.toString() ?? '');
          if (rowIndex % 2 == 0) {
            cell.cellStyle = xl.CellStyle(
              backgroundColorHex: xl.ExcelColor.fromHexString('#F9FAFB'),
            );
          }
        }
      }
    }

    for (int i = 0; i < headers.length; i++) {
      sheet.setColumnAutoFit(i);
    }

    // Eliminar la hoja por defecto 'Sheet1' si existe
    if (excel.sheets.containsKey('Sheet1')) {
      excel.delete('Sheet1');
    }

    final now = DateTime.now();
    final timestamp = DateFormat('yyyy-MM-dd_HHmm').format(now);
    final fileName = 'Trabajos_Cientificos_Admin_$timestamp.xlsx';
    final bytes = excel.encode();

    if (bytes != null) {
      if (kIsWeb) {
        js.saveAs(Uint8List.fromList(bytes), fileName);
      } else {
        try {
          final directory = await getApplicationDocumentsDirectory();
          debugPrint('Guardando archivo en: ${directory.path}\\$fileName');
          final finalDir = await FilePicker.platform.saveFile(
            dialogTitle: 'Eliga una carpeta de destino:',
            fileName: fileName,
          );
          if (finalDir == null) {
            return;
          }
          await File(finalDir).writeAsBytes(bytes);
          await OpenFile.open(finalDir);
        } catch (e) {
          debugPrint('Error al guardar el archivo: $e');
          rethrow;
        }
      }
    }
  }
}
