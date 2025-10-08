import 'dart:io';

import 'package:congreso_evento/core/exception/service_exception.dart';
import 'package:congreso_evento/core/js_cross_platform/js_cross_platform.dart'
    as js;
import 'package:congreso_evento/core/models/global_state_class.dart';
import 'package:congreso_evento/core/notifiier/default_state_notififier.dart';
import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/enums/tipo_usuario_enum.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/services/congresista_service.dart';
import 'package:excel/excel.dart' as xl;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

part 'congresista_ctrl.g.dart';

class CongresistaCtrl = CongresistaCtrlBase with _$CongresistaCtrl;

abstract class CongresistaCtrlBase with Store {
  final CongresistaService service;
  CongresistaCtrlBase(this.service);

  @readonly
  GlobalStateClass _stateClass = GlobalStateClass(
    status: StatusEnumGlobal.loaded,
    message: '',
  );

  @readonly
  int _pageNr = 1;

  @readonly
  int _pageSize = 10;

  @readonly
  bool _isLastPage = false;

  @readonly
  int _pageTotal = 0;

  @readonly
  int _totalRegistros = 0;

  @readonly
  int _pages = 0;

  @readonly
  int _size = 0;

  @readonly
  bool _isRefreshing = false;

  @observable
  ObservableList<Usuario> congresistas = ObservableList<Usuario>();

  @readonly
  String? _condicion;

  @readonly
  Usuario? _congresista;

  set setCongresista(Usuario? value) {
    _congresista = value;
  }

  set setEmail(String? value) {
    _congresista = _congresista?.copyWith(email: value);
  }

  set setTelefono(String? value) {
    _congresista = _congresista?.copyWith(telefono: value);
  }

  set setInstitucion(String? value) {
    _congresista = _congresista?.copyWith(institucion: value);
  }

  set setSemestre(String? value) {
    _congresista = _congresista?.copyWith(semestre: value);
  }

  set setSeccion(String? value) {
    _congresista = _congresista?.copyWith(seccion: value);
  }

  set setIsAdmin(bool? value) {
    _congresista = _congresista?.copyWith(isAdmin: value);
  }

  set setIsFinanciero(bool? value) {
    _congresista = _congresista?.copyWith(isFinanciero: value);
  }

  set setIsCongresista(bool? value) {
    _congresista = _congresista?.copyWith(isCongresista: value);
  }

  set setIsStaff(bool? value) {
    _congresista = _congresista?.copyWith(isStaff: value);
  }

  set setIsInvitado(bool? value) {
    _congresista = _congresista?.copyWith(isInvitado: value);
  }

  set setIsDisertante(bool? value) {
    _congresista = _congresista?.copyWith(isDisertante: value);
  }

  set setRegistroAcademico(String? value) {
    _congresista = _congresista?.copyWith(registroAcademico: value);
  }

  @action
  void changeStatus(String message, StatusEnumGlobal status) {
    _stateClass = _stateClass.copyWith(message: message, status: status);
  }

  Future<void> onRefresh() async {
    _isRefreshing = true;
    await consulta();
    _isRefreshing = false;
  }

  set setCondicion(String? value) {
    _condicion = value;
    primeraConsulta();
  }

  void primeraConsulta() {
    _pageNr = 1;
    _isLastPage = false;
    congresistas.clear();
    consulta();
  }

  void siguienteConsulta() {
    _pageNr++;
    consulta();
  }

  void setPaginaAtual(int p0) {
    _pageNr = p0;
    _isLastPage = false;
    congresistas.clear();
    consulta();
  }

  void setRefreshing(bool value) {
    _isRefreshing = value;
  }

  set setNombre(String? value) {
    _congresista = _congresista?.copyWith(nombreCompleto: value);
  }

  bool get isLoading => _stateClass.status == StatusEnumGlobal.loading;
  bool get isLoadingList => _stateClass.status == StatusEnumGlobal.loadingList;

  @action
  Future<void> guardar() async {
    try {
      changeStatus('Guardando congresista...', StatusEnumGlobal.loading);
      // Simular un proceso de guardado

      final response = await service.save(_congresista!);

      final data = response.data;
      final code = response.code;
      final message = response.message;

      if (code != 200) {
        changeStatus(message, StatusEnumGlobal.errorDialog);
        return;
      }
      _actualizaLista(data);
      changeStatus(
        'Congresista guardado exitosamente',
        StatusEnumGlobal.success,
      );
    } on ServiceException catch (e) {
      changeStatus(e.message, StatusEnumGlobal.error);
    }
  }

  @action
  Future<void> restablecerContrasenha() async {
    try {
      changeStatus('Restableciendo contraseña...', StatusEnumGlobal.loading);
      // Simular un proceso de restablecimiento

      final response = await service.restablecerContrasenha(_congresista!);

      final data = response.data;
      final code = response.code;
      final message = response.message;

      if (code != 200) {
        changeStatus(message, StatusEnumGlobal.errorDialog);
        return;
      }
      _actualizaLista(data);
      changeStatus(
        'Congresista restablecido exitosamente',
        StatusEnumGlobal.success,
      );
    } on ServiceException catch (e) {
      changeStatus(e.message, StatusEnumGlobal.error);
    }
  }

  @action
  Future<List<Usuario>> consulta() async {
    try {
      if (_stateClass.status == StatusEnumGlobal.loadingList) {
        return congresistas; // Evita múltiples llamadas simultáneas
      }
      if (_isLastPage) {
        return congresistas; // Evita llamadas si ya es la última página
      }
      changeStatus('', StatusEnumGlobal.loadingList);
      final response = await service.consultaDocumentosPorCondicionPaginado(
        buscador: _condicion,
        pageNr: _pageNr,
        pageSize: _pageSize,
      );

      final data = response.data;

      _totalRegistros = response.totalRegistros;
      _isLastPage = response.isLastPage;

      changeStatus('', StatusEnumGlobal.loaded);
      congresistas.addAll(data);
      return data;
    } on ServiceException catch (e) {
      changeStatus(e.message, StatusEnumGlobal.errorDialog);
      return [];
    }
  }

  void _actualizaLista(Usuario? data) {
    if (data == null) return;
    final index = congresistas.indexWhere((c) => c.id == data.id);
    if (index != -1) {
      congresistas[index] = data;
    } else {
      congresistas.add(data);
    }
  }

  @action
  Future<List<Usuario>> consultaCongresistaPorTipo(
    TipoUsuarioEnum tipoUsuario,
  ) async {
    try {
      if (_stateClass.status == StatusEnumGlobal.loading) {
        return []; // Evita múltiples llamadas simultáneas
      }
      changeStatus('', StatusEnumGlobal.loading);
      final response = await service.consultaCongresistaPorTipo(
        tipoUsuario,
        soloPagados: true,
      );
      final data = response.data;
      if (data.isEmpty) {
        changeStatus(
          'No se encontraron registros para ese tipo.',
          StatusEnumGlobal.errorDialog,
        );
        return [];
      }
      changeStatus('', StatusEnumGlobal.loaded);
      return data;
    } on ServiceException catch (e) {
      changeStatus(e.message, StatusEnumGlobal.errorDialog);
      return [];
    }
  }

  /// Consulta todos los usuarios sin paginación ni filtro
  Future<List<Usuario>> consultaTodosLosUsuarios() async {
    try {
      changeStatus('', StatusEnumGlobal.loading);
      final response = await service.consultaDocumentosPorCondicionPaginado(
        buscador: null,
        pageNr: 1,
        pageSize: 100000, // Un número suficientemente grande para traer todos
      );
      changeStatus('', StatusEnumGlobal.loaded);
      return response.data;
    } on ServiceException catch (e) {
      changeStatus(e.message, StatusEnumGlobal.errorDialog);
      return [];
    }
  }

  /// Categorías de columnas organizadas por tipo
  final Map<String, List<String>> categoriaColumnas = {
    'Información Básica': [
      'ID',
      'UUID',
      'Nombre Completo',
      'Email',
      'Teléfono',
      'País',
    ],
    'Información Académica': [
      'Institución',
      'Registro Académico',
      'Semestre',
      'Sección',
    ],
    'Roles y Permisos': [
      'Tipo Usuario',
      'Es Admin',
      'Es Staff',
      'Es Financiero',
      'Es Invitado',
      'Es Disertante',
      'Es Congresista',
    ],
    'Información de Pago': [
      'Es Exonerado',
      'Es Pago',
      'Monto Pago',
      'Fecha Pago',
      'Usuario Pago',
    ],
    'Información del Sistema': ['Fecha Registro'],
  };

  /// Opciones de ordenamiento
  final Map<String, String> opcionesOrdenamiento = {
    'Nombre Completo (A-Z)': 'nombreCompleto_asc',
    'Nombre Completo (Z-A)': 'nombreCompleto_desc',
    'Email (A-Z)': 'email_asc',
    'Email (Z-A)': 'email_desc',
    'Fecha Registro (Más reciente)': 'fechaRegistro_desc',
    'Fecha Registro (Más antiguo)': 'fechaRegistro_asc',
    'Tipo Usuario': 'tipoUsuario_asc',
    'Institución (A-Z)': 'institucion_asc',
    'Estado de Pago': 'estadoPago_desc',
  };

  /// Ordenamiento seleccionado
  @observable
  String ordenamientoSeleccionado = 'nombreCompleto_asc';

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

  /// Todas las columnas posibles
  final List<String> todasLasColumnas = [
    'ID',
    'UUID',
    'Nombre Completo',
    'Email',
    'Teléfono',
    'País',
    'Institución',
    'Registro Académico',
    'Semestre',
    'Sección',
    'Tipo Usuario',
    'Es Admin',
    'Es Staff',
    'Es Financiero',
    'Es Invitado',
    'Es Disertante',
    'Es Congresista',
    'Es Exonerado',
    'Es Pago',
    'Monto Pago',
    'Fecha Pago',
    'Usuario Pago',
    'Fecha Registro',
  ];

  /// Columnas seleccionadas para exportar
  @observable
  ObservableList<String> columnasSeleccionadas = ObservableList<String>();

  @action
  Future<void> exportarTodosAExcel() async {
    // Mostrar diálogo de selección de columnas
    mostrarDialogoSeleccionColumnas();
  }

  /// Inicializa categorías y columnas seleccionadas
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
      columnasPorCategoria[categoria]?.clear();
      columnasPorCategoria[categoria]?.addAll(
        categoriaColumnas[categoria] ?? [],
      );
    } else {
      columnasPorCategoria[categoria]?.clear();
    }

    _actualizarColumnasSeleccionadas();
  }

  /// Selecciona/deselecciona una columna específica
  @action
  void toggleColumna(String categoria, String columna) {
    final columnasCategoria = columnasPorCategoria[categoria];
    if (columnasCategoria == null) return;

    if (columnasCategoria.contains(columna)) {
      columnasCategoria.remove(columna);
    } else {
      columnasCategoria.add(columna);
    }

    categoriasSeleccionadas[categoria] = columnasCategoria.isNotEmpty;
    _actualizarColumnasSeleccionadas();
  }

  /// Selecciona todas las columnas
  @action
  void seleccionarTodasLasColumnas() {
    for (final categoria in categoriaColumnas.keys) {
      categoriasSeleccionadas[categoria] = true;
      columnasPorCategoria[categoria]?.clear();
      columnasPorCategoria[categoria]?.addAll(
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
      columnasPorCategoria[categoria]?.clear();
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

  /// Método para mostrar el diálogo desde la UI
  /// Oculta el diálogo de selección de columnas
  @action
  void ocultarDialogoSeleccionColumnas() {
    mostrarDialogoExportacion = false;
  }

  /// Confirma la exportación con las columnas seleccionadas
  @action
  Future<void> confirmarExportacion() async {
    ocultarDialogoSeleccionColumnas();

    try {
      changeStatus('Exportando datos...', StatusEnumGlobal.loading);
      final todosLosUsuarios = await consultaTodosLosUsuarios();
      await _generarExcelCompleto(todosLosUsuarios);
    } catch (e) {
      changeStatus('Error al exportar: $e', StatusEnumGlobal.errorDialog);
    } finally {
      changeStatus('', StatusEnumGlobal.loaded);
    }
  }

  /// Ordena la lista de usuarios según el criterio seleccionado
  List<Usuario> _ordenarUsuarios(List<Usuario> usuarios) {
    final usuariosOrdenados = List<Usuario>.from(usuarios);

    switch (ordenamientoSeleccionado) {
      case 'nombreCompleto_asc':
        usuariosOrdenados.sort(
          (a, b) => (a.nombreCompleto ?? '').compareTo(b.nombreCompleto ?? ''),
        );
        break;
      case 'nombreCompleto_desc':
        usuariosOrdenados.sort(
          (a, b) => (b.nombreCompleto ?? '').compareTo(a.nombreCompleto ?? ''),
        );
        break;
      case 'email_asc':
        usuariosOrdenados.sort(
          (a, b) => (a.email ?? '').compareTo(b.email ?? ''),
        );
        break;
      case 'email_desc':
        usuariosOrdenados.sort(
          (a, b) => (b.email ?? '').compareTo(a.email ?? ''),
        );
        break;
      case 'fechaRegistro_desc':
        usuariosOrdenados.sort((a, b) {
          if (a.fechaRegistro == null && b.fechaRegistro == null) return 0;
          if (a.fechaRegistro == null) return 1;
          if (b.fechaRegistro == null) return -1;
          return b.fechaRegistro!.compareTo(a.fechaRegistro!);
        });
        break;
      case 'fechaRegistro_asc':
        usuariosOrdenados.sort((a, b) {
          if (a.fechaRegistro == null && b.fechaRegistro == null) return 0;
          if (a.fechaRegistro == null) return 1;
          if (b.fechaRegistro == null) return -1;
          return a.fechaRegistro!.compareTo(b.fechaRegistro!);
        });
        break;
      case 'tipoUsuario_asc':
        usuariosOrdenados.sort(
          (a, b) => _getTipoUsuarioTexto(a).compareTo(_getTipoUsuarioTexto(b)),
        );
        break;
      case 'institucion_asc':
        usuariosOrdenados.sort(
          (a, b) => (a.institucion ?? '').compareTo(b.institucion ?? ''),
        );
        break;
      case 'estadoPago_desc':
        usuariosOrdenados.sort((a, b) {
          final aPago = a.isPago == true ? 1 : 0;
          final bPago = b.isPago == true ? 1 : 0;
          return bPago.compareTo(aPago);
        });
        break;
    }

    return usuariosOrdenados;
  }

  Future<void> _generarExcelCompleto(List<Usuario> usuarios) async {
    // Crear nuevo Excel
    final excel = xl.Excel.createExcel();

    // Crear la sheet principal
    final sheet = excel['Congresistas'];

    // Ordenar usuarios según el criterio seleccionado
    final usuariosOrdenados = _ordenarUsuarios(usuarios);

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
    for (int rowIndex = 0; rowIndex < usuariosOrdenados.length; rowIndex++) {
      final usuario = usuariosOrdenados[rowIndex];
      final dataRow = rowIndex + 1;

      Map<String, String> datos = {
        'ID': usuario.id?.toString() ?? '',
        'UUID': usuario.uuid ?? '',
        'Nombre Completo': usuario.nombreCompleto ?? '',
        'Email': usuario.email ?? '',
        'Teléfono': usuario.telefono ?? '',
        'País': usuario.pais ?? '',
        'Institución': usuario.institucion ?? '',
        'Registro Académico': usuario.registroAcademico ?? '',
        'Semestre': usuario.semestre ?? '',
        'Sección': usuario.seccion ?? '',
        'Tipo Usuario': _getTipoUsuarioTexto(usuario),
        'Es Admin': (usuario.isAdmin == true) ? 'Sí' : 'No',
        'Es Staff': (usuario.isStaff == true) ? 'Sí' : 'No',
        'Es Financiero': (usuario.isFinanciero == true) ? 'Sí' : 'No',
        'Es Invitado': (usuario.isInvitado == true) ? 'Sí' : 'No',
        'Es Disertante': (usuario.isDisertante == true) ? 'Sí' : 'No',
        'Es Congresista': (usuario.isCongresista == true) ? 'Sí' : 'No',
        'Es Exonerado': (usuario.isExonerado == true) ? 'Sí' : 'No',
        'Es Pago': (usuario.isPago == true) ? 'Sí' : 'No',
        'Monto Pago': usuario.montoPago?.toString() ?? '',
        'Fecha Pago': usuario.fechaPago != null
            ? DateFormat('dd/MM/yyyy HH:mm').format(usuario.fechaPago!)
            : '',
        'Usuario Pago': usuario.usuarioPago ?? '',
        'Fecha Registro': usuario.fechaRegistro != null
            ? DateFormat('dd/MM/yyyy HH:mm').format(usuario.fechaRegistro!)
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
        cell.value = xl.TextCellValue(datos[columna] ?? '');
        if (rowIndex % 2 == 0) {
          cell.cellStyle = xl.CellStyle(
            backgroundColorHex: xl.ExcelColor.fromHexString('#F9FAFB'),
          );
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
    final fileName = 'Congresistas_Completo_$timestamp.xlsx';
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
          changeStatus(
            'Error al guardar el archivo: $e',
            StatusEnumGlobal.errorDialog,
          );
          return;
        }
      }
      changeStatus(
        'Archivo Excel generado exitosamente.',
        StatusEnumGlobal.success,
      );
    }
  }

  String _getTipoUsuarioTexto(Usuario usuario) {
    if (usuario.isStaff == true) return 'Staff';
    if (usuario.isInvitado == true) return 'Invitado';
    if (usuario.isDisertante == true) return 'Disertante';
    if (usuario.isCongresista == true) return 'Congresista';
    return 'No definido';
  }
}
