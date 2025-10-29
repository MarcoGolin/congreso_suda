import 'dart:io';

import 'package:congreso_evento/core/exception/service_exception.dart';
import 'package:congreso_evento/core/js_cross_platform/js_cross_platform.dart'
    as js;
import 'package:congreso_evento/core/models/global_state_class.dart';
import 'package:congreso_evento/core/notifiier/default_state_notififier.dart';
import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:congreso_evento/modules/checkin/enums/checkin_enums.dart';
import 'package:congreso_evento/modules/checkin/models/checkin.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/enums/tipo_usuario_enum.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/services/congresista_service.dart';
import 'package:excel/excel.dart' as xl;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:open_file/open_file.dart';

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
    final excel = xl.Excel.createExcel();

    // === Buffer de alertas (días abiertos) ===
    final List<Map<String, dynamic>> alertas = [];

    // ===== utilidades =====
    DateTime dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);
    String fmtDT(DateTime? dt) =>
        dt == null ? '' : DateFormat('dd/MM/yyyy HH:mm').format(dt);
    String fmtH(DateTime? dt) =>
        dt == null ? '' : DateFormat('HH:mm').format(dt);
    String fmtHM(Duration d) =>
        '${d.inHours}:${d.inMinutes.remainder(60).toString().padLeft(2, '0')}';
    String fmtHMOrEmpty(Duration? d) => d == null ? '' : fmtHM(d);

    String tipoLabel(CheckinTipo? t) {
      if (t == null) return '';
      switch (t) {
        case CheckinTipo.CONGRESO_ASISTENCIA:
          return 'Acreditación';
        case CheckinTipo.KIT_ENTREGADO:
          return 'Kit Bienvenida';
        case CheckinTipo.COFFEE_BREAK_ENTREGADO:
          return 'Coffee break';
      }
    }

    String coffeeLabel(CoffeeBreak? c) {
      if (c == null) return '';
      switch (c) {
        case CoffeeBreak.MANHANA:
          return 'Mañana';
        case CoffeeBreak.TARDE:
          return 'Tarde';
      }
    }

    // ===== suma por tramos alternados =====
    _AsistCalc _sumarTramos(List<DateTime> marcasOrdenadas) {
      int totalMin = 0;
      int tramos = 0;
      for (int i = 0; i + 1 < marcasOrdenadas.length; i += 2) {
        final a = marcasOrdenadas[i];
        final b = marcasOrdenadas[i + 1];
        if (b.isAfter(a)) {
          totalMin += b.difference(a).inMinutes;
          tramos++;
        }
      }
      final lecturas = marcasOrdenadas.length;
      final abierto = lecturas.isOdd;
      return _AsistCalc(Duration(minutes: totalMin), lecturas, tramos, abierto);
    }

    // ===== DEDUP: elimina lecturas consecutivas con delta < threshold =====
    List<DateTime> _dedupMarcas(
      List<DateTime> marcas, {
      Duration threshold = const Duration(minutes: 2),
    }) {
      if (marcas.isEmpty) return const <DateTime>[];
      marcas.sort();
      final out = <DateTime>[marcas.first];
      for (int i = 1; i < marcas.length; i++) {
        final curr = marcas[i];
        if (curr.difference(out.last) >= threshold) {
          out.add(curr);
        }
      }
      return out;
    }

    // ===== días detectados dinámicamente a partir de TODOS los checkins =====
    final diasSet = <DateTime>{};
    for (final u in usuarios) {
      final list = u.checkin;
      if (list == null || list.isEmpty) continue;
      for (final c in list) {
        final fr = c.fechaRegistro;
        if (fr != null) diasSet.add(dateOnly(fr));
      }
    }
    final diasOrdenados = diasSet.toList()..sort();

    // ===== Hoja principal: Congresistas =====
    final sheet = excel['Congresistas'];
    final usuariosOrdenados = _ordenarUsuarios(usuarios);

    // Armado de headers base (tu lógica existente)
    final headers = <String>[];
    for (final categoria in categoriaColumnas.keys) {
      if (categoriasSeleccionadas[categoria] == true) {
        final columnasCategoria = columnasPorCategoria[categoria] ?? [];
        for (final columna in categoriaColumnas[categoria]!) {
          if (columnasCategoria.contains(columna)) headers.add(columna);
        }
      }
    }
    if (headers.isEmpty) headers.addAll(todasLasColumnas);

    void ensure(String h) {
      if (!headers.contains(h)) headers.add(h);
    }

    ensure('Checkins (total)');
    ensure('Primer Checkin');
    ensure('Último Checkin');
    ensure('Total Horas (h:mm)'); // total general

    // === columnas dinámicas por día ===
    final colsPorDia = <String>[];
    final etiquetasDias = <String>[];
    for (int i = 0; i < diasOrdenados.length; i++) {
      final d = diasOrdenados[i];
      final etiqueta = 'D${i + 1} (${DateFormat('dd/MM').format(d)})';
      etiquetasDias.add(etiqueta);
      colsPorDia.addAll(<String>[
        '$etiqueta Ingreso',
        '$etiqueta Salida',
        '$etiqueta Asist. #lecturas',
        '$etiqueta Asist. #tramos',
        '$etiqueta Asist. abierto',
        '$etiqueta Horas (h:mm)',
        '$etiqueta Kit',
        '$etiqueta Coffee Mañana',
        '$etiqueta Coffee Tarde',
      ]);
    }
    headers.addAll(colsPorDia);

    // Pintar headers
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

    // Índice de headers para acceso O(1)
    final headerIndex = <String, int>{};
    for (int i = 0; i < headers.length; i++) {
      headerIndex[headers[i]] = i;
    }

    // Preconstruimos por día los índices de columnas que se pintarán en rojo si está "abierto"
    final colsDiaIndex = <int, List<int>>{};
    for (int i = 0; i < etiquetasDias.length; i++) {
      final e = etiquetasDias[i];
      colsDiaIndex[i] = <int>[
        headerIndex['$e Ingreso']!,
        headerIndex['$e Salida']!,
        headerIndex['$e Asist. #lecturas']!,
        headerIndex['$e Asist. #tramos']!,
        headerIndex['$e Asist. abierto']!,
        headerIndex['$e Horas (h:mm)']!,
      ];
    }

    // Estilos
    final rojoFondo = xl.ExcelColor.fromHexString('#FFEBEE'); // rojo claro
    final rojoTexto = xl.ExcelColor.fromHexString('#B71C1C'); // rojo intenso
    final zebra = xl.ExcelColor.fromHexString('#F9FAFB');

    // Escribir filas
    for (int rowIndex = 0; rowIndex < usuariosOrdenados.length; rowIndex++) {
      final u = usuariosOrdenados[rowIndex];
      final checks = u.checkin ?? const <Checkin>[];

      // Preordenamos una vez por fecha
      final checksSorted = [...checks]
        ..sort(
          (a, b) => (a.fechaRegistro ?? DateTime(1970)).compareTo(
            b.fechaRegistro ?? DateTime(1970),
          ),
        );

      // Resumen global
      final total = checksSorted.length;
      final first = checksSorted.isNotEmpty
          ? checksSorted.first.fechaRegistro
          : null;
      final last = checksSorted.isNotEmpty
          ? checksSorted.last.fechaRegistro
          : null;

      final datos = <String, String>{
        'ID': u.id?.toString() ?? '',
        'UUID': u.uuid ?? '',
        'Nombre Completo': u.nombreCompleto ?? '',
        'Email': u.email ?? '',
        'Teléfono': u.telefono ?? '',
        'País': u.pais ?? '',
        'Institución': u.institucion ?? '',
        'Registro Académico': u.registroAcademico ?? '',
        'Semestre': u.semestre ?? '',
        'Sección': u.seccion ?? '',
        'Tipo Usuario': _getTipoUsuarioTexto(u),
        'Es Admin': (u.isAdmin == true) ? 'Sí' : 'No',
        'Es Staff': (u.isStaff == true) ? 'Sí' : 'No',
        'Es Financiero': (u.isFinanciero == true) ? 'Sí' : 'No',
        'Es Invitado': (u.isInvitado == true) ? 'Sí' : 'No',
        'Es Disertante': (u.isDisertante == true) ? 'Sí' : 'No',
        'Es Congresista': (u.isCongresista == true) ? 'Sí' : 'No',
        'Es Exonerado': (u.isExonerado == true) ? 'Sí' : 'No',
        'Es Pago': (u.isPago == true) ? 'Sí' : 'No',
        'Monto Pago': u.montoPago?.toString() ?? '',
        'Fecha Pago': fmtDT(u.fechaPago),
        'Usuario Pago': u.usuarioPago ?? '',
        'Fecha Registro': fmtDT(u.fechaRegistro),
        'Checkins (total)': '$total',
        'Primer Checkin': fmtDT(first),
        'Último Checkin': fmtDT(last),
      };

      int totalMinutos = 0;
      // Guardamos por día si quedó abierto para pintar
      final diasAbiertos = <int, bool>{};

      for (int i = 0; i < diasOrdenados.length; i++) {
        final d = diasOrdenados[i];

        // Filtrado del día (ya ordenado)
        final delDia = <Checkin>[];
        for (final c in checksSorted) {
          final fr = c.fechaRegistro;
          if (fr == null) continue;
          if (dateOnly(fr) == d) delDia.add(c);
          if (dateOnly(fr).isAfter(d)) break; // corto temprano
        }

        // Asistencia: dedup de marcas (delta < 2 min) ANTES de sumar tramos
        final asistMarcas = <DateTime>[];
        for (final c in delDia) {
          if (c.tipo == CheckinTipo.CONGRESO_ASISTENCIA &&
              c.fechaRegistro != null) {
            asistMarcas.add(c.fechaRegistro!);
          }
        }
        final marcasDedup = _dedupMarcas(
          asistMarcas,
          threshold: const Duration(minutes: 2),
        );
        final calc = _sumarTramos(marcasDedup);

        final ingreso = marcasDedup.isNotEmpty ? marcasDedup.first : null;
        final salida = marcasDedup.isNotEmpty ? marcasDedup.last : null;

        // Kit / Coffee: si hay múltiples, tomamos la PRIMERA ocurrencia real del día
        DateTime? kitHora;
        DateTime? coffeeManhaHora;
        DateTime? coffeeTardeHora;
        for (final c in delDia) {
          if (c.tipo == CheckinTipo.KIT_ENTREGADO && kitHora == null) {
            kitHora = c.fechaRegistro;
          } else if (c.tipo == CheckinTipo.COFFEE_BREAK_ENTREGADO &&
              c.refriSlot == CoffeeBreak.MANHANA &&
              coffeeManhaHora == null) {
            coffeeManhaHora = c.fechaRegistro;
          } else if (c.tipo == CheckinTipo.COFFEE_BREAK_ENTREGADO &&
              c.refriSlot == CoffeeBreak.TARDE &&
              coffeeTardeHora == null) {
            coffeeTardeHora = c.fechaRegistro;
          }
        }

        totalMinutos += calc.duracion.inMinutes;

        final e = etiquetasDias[i];
        datos['$e Ingreso'] = fmtH(ingreso);
        datos['$e Salida'] = fmtH(salida);
        datos['$e Asist. #lecturas'] = calc.lecturas == 0
            ? ''
            : '${calc.lecturas}';
        datos['$e Asist. #tramos'] = calc.tramos == 0 ? '' : '${calc.tramos}';
        datos['$e Asist. abierto'] = calc.abierto ? 'Sí' : '';
        datos['$e Horas (h:mm)'] = fmtHMOrEmpty(calc.duracion);
        datos['$e Kit'] = fmtH(kitHora);
        datos['$e Coffee Mañana'] = fmtH(coffeeManhaHora);
        datos['$e Coffee Tarde'] = fmtH(coffeeTardeHora);

        if (calc.abierto) {
          diasAbiertos[i] = true;
          alertas.add({
            'usuarioId': u.id,
            'nombre': u.nombreCompleto ?? '',
            'uuid': u.uuid ?? '',
            'dia': d,
            'etiqueta': e,
            'lecturas': calc.lecturas,
            'tramos': calc.tramos,
            'primer': ingreso,
            'ultimo': salida,
            'duracion': calc.duracion,
          });
        }
      }

      // Total general
      final totalHoras = Duration(minutes: totalMinutos);
      datos['Total Horas (h:mm)'] = fmtHM(totalHoras);

      // Escribir fila
      final dataRow = rowIndex + 1;
      for (int colIndex = 0; colIndex < headers.length; colIndex++) {
        final h = headers[colIndex];
        final cell = sheet.cell(
          xl.CellIndex.indexByColumnRow(
            columnIndex: colIndex,
            rowIndex: dataRow,
          ),
        );
        cell.value = xl.TextCellValue(datos[h] ?? '');
        if (rowIndex.isEven) {
          cell.cellStyle = xl.CellStyle(backgroundColorHex: zebra);
        }
      }

      // Pintar en rojo los días abiertos
      diasAbiertos.forEach((iDia, _) {
        for (final colIdx in colsDiaIndex[iDia]!) {
          final cell = sheet.cell(
            xl.CellIndex.indexByColumnRow(
              columnIndex: colIdx,
              rowIndex: dataRow,
            ),
          );
          cell.cellStyle = xl.CellStyle(
            backgroundColorHex: rojoFondo,
            fontColorHex: rojoTexto,
            bold: true,
          );
        }
      });
    }

    // Autofit
    for (int i = 0; i < headers.length; i++) {
      sheet.setColumnAutoFit(i);
    }

    // ===== Hoja de Alertas (días abiertos) =====
    final shAlert = excel['Alertas'];
    final alertHeaders = <String>[
      'Usuario ID',
      'Nombre',
      'UUID',
      'Día',
      'Etiqueta',
      'Asist. #lecturas',
      'Asist. #tramos',
      'Primer',
      'Último',
      'Horas (h:mm)',
      'Observación',
    ];

    for (int i = 0; i < alertHeaders.length; i++) {
      final cell = shAlert.cell(
        xl.CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
      );
      cell.value = xl.TextCellValue(alertHeaders[i]);
      cell.cellStyle = xl.CellStyle(
        backgroundColorHex: xl.ExcelColor.fromHexString('#387f4d'),
        fontColorHex: xl.ExcelColor.fromHexString('#FFFFFF'),
        bold: true,
      );
    }

    if (alertas.isEmpty) {
      final cell = shAlert.cell(
        xl.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1),
      );
      cell.value = xl.TextCellValue('Sin días abiertos');
      for (int i = 0; i < alertHeaders.length; i++) {
        shAlert.setColumnAutoFit(i);
      }
    } else {
      alertas.sort((a, b) {
        final n1 = (a['nombre'] as String).toLowerCase();
        final n2 = (b['nombre'] as String).toLowerCase();
        final c = n1.compareTo(n2);
        if (c != 0) return c;
        final d1 = a['dia'] as DateTime;
        final d2 = b['dia'] as DateTime;
        return d1.compareTo(d2);
      });

      final zebra = xl.ExcelColor.fromHexString('#F9FAFB');
      final rojoFondo = xl.ExcelColor.fromHexString('#FFEBEE');
      final rojoTexto = xl.ExcelColor.fromHexString('#B71C1C');

      int rr = 1;
      for (final a in alertas) {
        final rowVals = <String>[
          (a['usuarioId']?.toString() ?? ''),
          (a['nombre'] as String?) ?? '',
          (a['uuid'] as String?) ?? '',
          DateFormat('dd/MM').format(a['dia'] as DateTime),
          (a['etiqueta'] as String?) ?? '',
          (a['lecturas']?.toString() ?? ''),
          (a['tramos']?.toString() ?? ''),
          fmtDT(a['primer'] as DateTime?),
          fmtDT(a['ultimo'] as DateTime?),
          fmtHM((a['duracion'] as Duration?) ?? Duration.zero),
          'Abierto: faltó marcar salida/pareja',
        ];

        for (int i = 0; i < rowVals.length; i++) {
          final cell = shAlert.cell(
            xl.CellIndex.indexByColumnRow(columnIndex: i, rowIndex: rr),
          );
          cell.value = xl.TextCellValue(rowVals[i]);
        }
        // resaltar toda la fila en rojo
        for (int i = 0; i < alertHeaders.length; i++) {
          final cell = shAlert.cell(
            xl.CellIndex.indexByColumnRow(columnIndex: i, rowIndex: rr),
          );
          cell.cellStyle = xl.CellStyle(
            backgroundColorHex: rojoFondo,
            fontColorHex: rojoTexto,
            bold: true,
          );
        }
        rr++;
      }

      for (int i = 0; i < alertHeaders.length; i++) {
        shAlert.setColumnAutoFit(i);
      }
    }

    // ===== Hoja Detalle por Usuario =====
    final det = excel['Detalle por Usuario'];
    final detHeaders = <String>[
      'Usuario ID',
      'RA',
      'Nombre',
      'Fecha',
      'Día',
      'Tipo',
      'Coffee',
      'Operador',
      'Taller ID',
    ];
    for (int i = 0; i < detHeaders.length; i++) {
      final cell = det.cell(
        xl.CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
      );
      cell.value = xl.TextCellValue(detHeaders[i]);
      cell.cellStyle = xl.CellStyle(
        backgroundColorHex: xl.ExcelColor.fromHexString('#387f4d'),
        fontColorHex: xl.ExcelColor.fromHexString('#FFFFFF'),
        bold: true,
      );
    }

    int r = 1;
    for (final u in usuariosOrdenados) {
      final titulo =
          '${u.nombreCompleto ?? ''}  (ID:${u.id ?? ''}  UUID:${u.uuid ?? ''})';
      final cellTitle = det.cell(
        xl.CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: r),
      );
      cellTitle.value = xl.TextCellValue(titulo);
      cellTitle.cellStyle = xl.CellStyle(
        bold: true,
        backgroundColorHex: xl.ExcelColor.fromHexString('#E8F5E9'),
      );
      r++;

      final list = (u.checkin ?? const <Checkin>[])
        ..sort(
          (a, b) => (a.fechaRegistro ?? DateTime(1970)).compareTo(
            b.fechaRegistro ?? DateTime(1970),
          ),
        );

      for (final c in list) {
        final fecha = c.fechaRegistro;
        final dia = fecha == null
            ? ''
            : DateFormat('dd/MM').format(dateOnly(fecha));
        final row = <String>[
          u.id?.toString() ?? '',
          u.registroAcademico ?? '',
          u.nombreCompleto ?? '',
          fmtDT(fecha),
          dia,
          tipoLabel(c.tipo),
          coffeeLabel(c.refriSlot),
          (c as dynamic)?.usuarioOperador?.nombreCompleto ?? '',
          c.tallerId?.toString() ?? '',
        ];
        for (int i = 0; i < row.length; i++) {
          final cell = det.cell(
            xl.CellIndex.indexByColumnRow(columnIndex: i, rowIndex: r),
          );
          cell.value = xl.TextCellValue(row[i]);
        }
        if (r.isOdd) {
          for (int i = 0; i < detHeaders.length; i++) {
            det
                .cell(
                  xl.CellIndex.indexByColumnRow(columnIndex: i, rowIndex: r),
                )
                .cellStyle = xl.CellStyle(
              backgroundColorHex: zebra,
            );
          }
        }
        r++;
      }
      r++; // separador
    }

    for (int i = 0; i < detHeaders.length; i++) {
      det.setColumnAutoFit(i);
    }

    // Remover Sheet1
    if (excel.sheets.containsKey('Sheet1')) {
      excel.delete('Sheet1');
    }

    // Guardado
    final now = DateTime.now();
    final timestamp = DateFormat('yyyy-MM-dd_HHmm').format(now);
    final fileName = 'Congresistas_Completo_$timestamp.xlsx';
    final bytes = excel.encode();

    if (bytes != null) {
      if (kIsWeb) {
        js.saveAs(Uint8List.fromList(bytes), fileName);
      } else {
        try {
          final finalDir = await FilePicker.platform.saveFile(
            dialogTitle: 'Eliga una carpeta de destino:',
            fileName: fileName,
          );
          if (finalDir == null) return;
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

class _AsistCalc {
  final Duration duracion; // suma de pares
  final int lecturas; // cantidad de marcas del día
  final int tramos; // cantidad de pares (intervalos)
  final bool abierto; // true si quedó una marca "colgada" (impar)
  _AsistCalc(this.duracion, this.lecturas, this.tramos, this.abierto);
}

_AsistCalc _sumarTramos(List<DateTime> marcasOrdenadas) {
  int totalMin = 0;
  int tramos = 0;
  for (int i = 0; i + 1 < marcasOrdenadas.length; i += 2) {
    final a = marcasOrdenadas[i];
    final b = marcasOrdenadas[i + 1];
    if (b.isAfter(a)) {
      totalMin += b.difference(a).inMinutes;
      tramos++;
    }
  }
  final lecturas = marcasOrdenadas.length;
  final abierto = lecturas.isOdd;
  return _AsistCalc(Duration(minutes: totalMin), lecturas, tramos, abierto);
}
