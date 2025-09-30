// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mis_trabajos_excel_ctrl.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MisTrabajosCientificosExcelCtrl
    on MisTrabajosCientificosExcelCtrlBase, Store {
  late final _$ordenamientoSeleccionadoAtom = Atom(
    name: 'MisTrabajosCientificosExcelCtrlBase.ordenamientoSeleccionado',
    context: context,
  );

  @override
  String get ordenamientoSeleccionado {
    _$ordenamientoSeleccionadoAtom.reportRead();
    return super.ordenamientoSeleccionado;
  }

  @override
  set ordenamientoSeleccionado(String value) {
    _$ordenamientoSeleccionadoAtom.reportWrite(
      value,
      super.ordenamientoSeleccionado,
      () {
        super.ordenamientoSeleccionado = value;
      },
    );
  }

  late final _$mostrarDialogoExportacionAtom = Atom(
    name: 'MisTrabajosCientificosExcelCtrlBase.mostrarDialogoExportacion',
    context: context,
  );

  @override
  bool get mostrarDialogoExportacion {
    _$mostrarDialogoExportacionAtom.reportRead();
    return super.mostrarDialogoExportacion;
  }

  @override
  set mostrarDialogoExportacion(bool value) {
    _$mostrarDialogoExportacionAtom.reportWrite(
      value,
      super.mostrarDialogoExportacion,
      () {
        super.mostrarDialogoExportacion = value;
      },
    );
  }

  late final _$categoriasSeleccionadasAtom = Atom(
    name: 'MisTrabajosCientificosExcelCtrlBase.categoriasSeleccionadas',
    context: context,
  );

  @override
  ObservableMap<String, bool> get categoriasSeleccionadas {
    _$categoriasSeleccionadasAtom.reportRead();
    return super.categoriasSeleccionadas;
  }

  @override
  set categoriasSeleccionadas(ObservableMap<String, bool> value) {
    _$categoriasSeleccionadasAtom.reportWrite(
      value,
      super.categoriasSeleccionadas,
      () {
        super.categoriasSeleccionadas = value;
      },
    );
  }

  late final _$columnasPorCategoriaAtom = Atom(
    name: 'MisTrabajosCientificosExcelCtrlBase.columnasPorCategoria',
    context: context,
  );

  @override
  ObservableMap<String, ObservableList<String>> get columnasPorCategoria {
    _$columnasPorCategoriaAtom.reportRead();
    return super.columnasPorCategoria;
  }

  @override
  set columnasPorCategoria(
    ObservableMap<String, ObservableList<String>> value,
  ) {
    _$columnasPorCategoriaAtom.reportWrite(
      value,
      super.columnasPorCategoria,
      () {
        super.columnasPorCategoria = value;
      },
    );
  }

  late final _$columnasSeleccionadasAtom = Atom(
    name: 'MisTrabajosCientificosExcelCtrlBase.columnasSeleccionadas',
    context: context,
  );

  @override
  ObservableList<String> get columnasSeleccionadas {
    _$columnasSeleccionadasAtom.reportRead();
    return super.columnasSeleccionadas;
  }

  @override
  set columnasSeleccionadas(ObservableList<String> value) {
    _$columnasSeleccionadasAtom.reportWrite(
      value,
      super.columnasSeleccionadas,
      () {
        super.columnasSeleccionadas = value;
      },
    );
  }

  late final _$isLoadingAtom = Atom(
    name: 'MisTrabajosCientificosExcelCtrlBase.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$confirmarExportacionAsyncAction = AsyncAction(
    'MisTrabajosCientificosExcelCtrlBase.confirmarExportacion',
    context: context,
  );

  @override
  Future<void> confirmarExportacion(List<TrabajoCientifico> trabajos) {
    return _$confirmarExportacionAsyncAction.run(
      () => super.confirmarExportacion(trabajos),
    );
  }

  late final _$MisTrabajosCientificosExcelCtrlBaseActionController =
      ActionController(
        name: 'MisTrabajosCientificosExcelCtrlBase',
        context: context,
      );

  @override
  void inicializarSeleccionColumnas() {
    final _$actionInfo = _$MisTrabajosCientificosExcelCtrlBaseActionController
        .startAction(
          name:
              'MisTrabajosCientificosExcelCtrlBase.inicializarSeleccionColumnas',
        );
    try {
      return super.inicializarSeleccionColumnas();
    } finally {
      _$MisTrabajosCientificosExcelCtrlBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  void _actualizarColumnasSeleccionadas() {
    final _$actionInfo = _$MisTrabajosCientificosExcelCtrlBaseActionController
        .startAction(
          name:
              'MisTrabajosCientificosExcelCtrlBase._actualizarColumnasSeleccionadas',
        );
    try {
      return super._actualizarColumnasSeleccionadas();
    } finally {
      _$MisTrabajosCientificosExcelCtrlBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  void toggleCategoria(String categoria) {
    final _$actionInfo = _$MisTrabajosCientificosExcelCtrlBaseActionController
        .startAction(
          name: 'MisTrabajosCientificosExcelCtrlBase.toggleCategoria',
        );
    try {
      return super.toggleCategoria(categoria);
    } finally {
      _$MisTrabajosCientificosExcelCtrlBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  void toggleColumna(String categoria, String columna) {
    final _$actionInfo = _$MisTrabajosCientificosExcelCtrlBaseActionController
        .startAction(name: 'MisTrabajosCientificosExcelCtrlBase.toggleColumna');
    try {
      return super.toggleColumna(categoria, columna);
    } finally {
      _$MisTrabajosCientificosExcelCtrlBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  void seleccionarTodasLasColumnas() {
    final _$actionInfo = _$MisTrabajosCientificosExcelCtrlBaseActionController
        .startAction(
          name:
              'MisTrabajosCientificosExcelCtrlBase.seleccionarTodasLasColumnas',
        );
    try {
      return super.seleccionarTodasLasColumnas();
    } finally {
      _$MisTrabajosCientificosExcelCtrlBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  void deseleccionarTodasLasColumnas() {
    final _$actionInfo = _$MisTrabajosCientificosExcelCtrlBaseActionController
        .startAction(
          name:
              'MisTrabajosCientificosExcelCtrlBase.deseleccionarTodasLasColumnas',
        );
    try {
      return super.deseleccionarTodasLasColumnas();
    } finally {
      _$MisTrabajosCientificosExcelCtrlBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  void setOrdenamientoSeleccionado(String ordenamiento) {
    final _$actionInfo = _$MisTrabajosCientificosExcelCtrlBaseActionController
        .startAction(
          name:
              'MisTrabajosCientificosExcelCtrlBase.setOrdenamientoSeleccionado',
        );
    try {
      return super.setOrdenamientoSeleccionado(ordenamiento);
    } finally {
      _$MisTrabajosCientificosExcelCtrlBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  void mostrarDialogoSeleccionColumnas() {
    final _$actionInfo = _$MisTrabajosCientificosExcelCtrlBaseActionController
        .startAction(
          name:
              'MisTrabajosCientificosExcelCtrlBase.mostrarDialogoSeleccionColumnas',
        );
    try {
      return super.mostrarDialogoSeleccionColumnas();
    } finally {
      _$MisTrabajosCientificosExcelCtrlBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  void ocultarDialogoSeleccionColumnas() {
    final _$actionInfo = _$MisTrabajosCientificosExcelCtrlBaseActionController
        .startAction(
          name:
              'MisTrabajosCientificosExcelCtrlBase.ocultarDialogoSeleccionColumnas',
        );
    try {
      return super.ocultarDialogoSeleccionColumnas();
    } finally {
      _$MisTrabajosCientificosExcelCtrlBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  String toString() {
    return '''
ordenamientoSeleccionado: ${ordenamientoSeleccionado},
mostrarDialogoExportacion: ${mostrarDialogoExportacion},
categoriasSeleccionadas: ${categoriasSeleccionadas},
columnasPorCategoria: ${columnasPorCategoria},
columnasSeleccionadas: ${columnasSeleccionadas},
isLoading: ${isLoading}
    ''';
  }
}
