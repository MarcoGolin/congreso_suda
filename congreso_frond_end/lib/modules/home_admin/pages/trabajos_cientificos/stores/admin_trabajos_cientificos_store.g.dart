// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_trabajos_cientificos_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AdminTrabajosCientificosStore
    on AdminTrabajosCientificosStoreBase, Store {
  late final _$_loadingAtom = Atom(
    name: 'AdminTrabajosCientificosStoreBase._loading',
    context: context,
  );

  bool get loading {
    _$_loadingAtom.reportRead();
    return super._loading;
  }

  @override
  bool get _loading => loading;

  @override
  set _loading(bool value) {
    _$_loadingAtom.reportWrite(value, super._loading, () {
      super._loading = value;
    });
  }

  late final _$_errorMessageAtom = Atom(
    name: 'AdminTrabajosCientificosStoreBase._errorMessage',
    context: context,
  );

  String? get errorMessage {
    _$_errorMessageAtom.reportRead();
    return super._errorMessage;
  }

  @override
  String? get _errorMessage => errorMessage;

  @override
  set _errorMessage(String? value) {
    _$_errorMessageAtom.reportWrite(value, super._errorMessage, () {
      super._errorMessage = value;
    });
  }

  late final _$_itemsAtom = Atom(
    name: 'AdminTrabajosCientificosStoreBase._items',
    context: context,
  );

  ObservableList<TrabajoCientifico> get items {
    _$_itemsAtom.reportRead();
    return super._items;
  }

  @override
  ObservableList<TrabajoCientifico> get _items => items;

  @override
  set _items(ObservableList<TrabajoCientifico> value) {
    _$_itemsAtom.reportWrite(value, super._items, () {
      super._items = value;
    });
  }

  late final _$_filtroTextoAtom = Atom(
    name: 'AdminTrabajosCientificosStoreBase._filtroTexto',
    context: context,
  );

  String get filtroTexto {
    _$_filtroTextoAtom.reportRead();
    return super._filtroTexto;
  }

  @override
  String get _filtroTexto => filtroTexto;

  @override
  set _filtroTexto(String value) {
    _$_filtroTextoAtom.reportWrite(value, super._filtroTexto, () {
      super._filtroTexto = value;
    });
  }

  late final _$_filtroModalidadAtom = Atom(
    name: 'AdminTrabajosCientificosStoreBase._filtroModalidad',
    context: context,
  );

  String get filtroModalidad {
    _$_filtroModalidadAtom.reportRead();
    return super._filtroModalidad;
  }

  @override
  String get _filtroModalidad => filtroModalidad;

  @override
  set _filtroModalidad(String value) {
    _$_filtroModalidadAtom.reportWrite(value, super._filtroModalidad, () {
      super._filtroModalidad = value;
    });
  }

  late final _$_filtroAreaAtom = Atom(
    name: 'AdminTrabajosCientificosStoreBase._filtroArea',
    context: context,
  );

  String get filtroArea {
    _$_filtroAreaAtom.reportRead();
    return super._filtroArea;
  }

  @override
  String get _filtroArea => filtroArea;

  @override
  set _filtroArea(String value) {
    _$_filtroAreaAtom.reportWrite(value, super._filtroArea, () {
      super._filtroArea = value;
    });
  }

  late final _$_trabajoSeleccionadoAtom = Atom(
    name: 'AdminTrabajosCientificosStoreBase._trabajoSeleccionado',
    context: context,
  );

  TrabajoCientifico? get trabajoSeleccionado {
    _$_trabajoSeleccionadoAtom.reportRead();
    return super._trabajoSeleccionado;
  }

  @override
  TrabajoCientifico? get _trabajoSeleccionado => trabajoSeleccionado;

  @override
  set _trabajoSeleccionado(TrabajoCientifico? value) {
    _$_trabajoSeleccionadoAtom.reportWrite(
      value,
      super._trabajoSeleccionado,
      () {
        super._trabajoSeleccionado = value;
      },
    );
  }

  late final _$cargarTodosAsyncAction = AsyncAction(
    'AdminTrabajosCientificosStoreBase.cargarTodos',
    context: context,
  );

  @override
  Future<void> cargarTodos() {
    return _$cargarTodosAsyncAction.run(() => super.cargarTodos());
  }

  late final _$AdminTrabajosCientificosStoreBaseActionController =
      ActionController(
        name: 'AdminTrabajosCientificosStoreBase',
        context: context,
      );

  @override
  void setFiltroTexto(String texto) {
    final _$actionInfo = _$AdminTrabajosCientificosStoreBaseActionController
        .startAction(name: 'AdminTrabajosCientificosStoreBase.setFiltroTexto');
    try {
      return super.setFiltroTexto(texto);
    } finally {
      _$AdminTrabajosCientificosStoreBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  void setFiltroModalidad(String modalidad) {
    final _$actionInfo = _$AdminTrabajosCientificosStoreBaseActionController
        .startAction(
          name: 'AdminTrabajosCientificosStoreBase.setFiltroModalidad',
        );
    try {
      return super.setFiltroModalidad(modalidad);
    } finally {
      _$AdminTrabajosCientificosStoreBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  void setFiltroArea(String area) {
    final _$actionInfo = _$AdminTrabajosCientificosStoreBaseActionController
        .startAction(name: 'AdminTrabajosCientificosStoreBase.setFiltroArea');
    try {
      return super.setFiltroArea(area);
    } finally {
      _$AdminTrabajosCientificosStoreBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  void limpiarFiltros() {
    final _$actionInfo = _$AdminTrabajosCientificosStoreBaseActionController
        .startAction(name: 'AdminTrabajosCientificosStoreBase.limpiarFiltros');
    try {
      return super.limpiarFiltros();
    } finally {
      _$AdminTrabajosCientificosStoreBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  void seleccionarTrabajo(TrabajoCientifico trabajo) {
    final _$actionInfo = _$AdminTrabajosCientificosStoreBaseActionController
        .startAction(
          name: 'AdminTrabajosCientificosStoreBase.seleccionarTrabajo',
        );
    try {
      return super.seleccionarTrabajo(trabajo);
    } finally {
      _$AdminTrabajosCientificosStoreBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  TrabajoCientifico? obtenerTrabajoPorId(int id) {
    final _$actionInfo = _$AdminTrabajosCientificosStoreBaseActionController
        .startAction(
          name: 'AdminTrabajosCientificosStoreBase.obtenerTrabajoPorId',
        );
    try {
      return super.obtenerTrabajoPorId(id);
    } finally {
      _$AdminTrabajosCientificosStoreBaseActionController.endAction(
        _$actionInfo,
      );
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
