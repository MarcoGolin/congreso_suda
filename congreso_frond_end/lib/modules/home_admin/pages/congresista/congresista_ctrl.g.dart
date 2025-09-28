// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'congresista_ctrl.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CongresistaCtrl on CongresistaCtrlBase, Store {
  late final _$_stateClassAtom = Atom(
    name: 'CongresistaCtrlBase._stateClass',
    context: context,
  );

  GlobalStateClass get stateClass {
    _$_stateClassAtom.reportRead();
    return super._stateClass;
  }

  @override
  GlobalStateClass get _stateClass => stateClass;

  @override
  set _stateClass(GlobalStateClass value) {
    _$_stateClassAtom.reportWrite(value, super._stateClass, () {
      super._stateClass = value;
    });
  }

  late final _$_pageNrAtom = Atom(
    name: 'CongresistaCtrlBase._pageNr',
    context: context,
  );

  int get pageNr {
    _$_pageNrAtom.reportRead();
    return super._pageNr;
  }

  @override
  int get _pageNr => pageNr;

  @override
  set _pageNr(int value) {
    _$_pageNrAtom.reportWrite(value, super._pageNr, () {
      super._pageNr = value;
    });
  }

  late final _$_pageSizeAtom = Atom(
    name: 'CongresistaCtrlBase._pageSize',
    context: context,
  );

  int get pageSize {
    _$_pageSizeAtom.reportRead();
    return super._pageSize;
  }

  @override
  int get _pageSize => pageSize;

  @override
  set _pageSize(int value) {
    _$_pageSizeAtom.reportWrite(value, super._pageSize, () {
      super._pageSize = value;
    });
  }

  late final _$_isLastPageAtom = Atom(
    name: 'CongresistaCtrlBase._isLastPage',
    context: context,
  );

  bool get isLastPage {
    _$_isLastPageAtom.reportRead();
    return super._isLastPage;
  }

  @override
  bool get _isLastPage => isLastPage;

  @override
  set _isLastPage(bool value) {
    _$_isLastPageAtom.reportWrite(value, super._isLastPage, () {
      super._isLastPage = value;
    });
  }

  late final _$_pageTotalAtom = Atom(
    name: 'CongresistaCtrlBase._pageTotal',
    context: context,
  );

  int get pageTotal {
    _$_pageTotalAtom.reportRead();
    return super._pageTotal;
  }

  @override
  int get _pageTotal => pageTotal;

  @override
  set _pageTotal(int value) {
    _$_pageTotalAtom.reportWrite(value, super._pageTotal, () {
      super._pageTotal = value;
    });
  }

  late final _$_totalRegistrosAtom = Atom(
    name: 'CongresistaCtrlBase._totalRegistros',
    context: context,
  );

  int get totalRegistros {
    _$_totalRegistrosAtom.reportRead();
    return super._totalRegistros;
  }

  @override
  int get _totalRegistros => totalRegistros;

  @override
  set _totalRegistros(int value) {
    _$_totalRegistrosAtom.reportWrite(value, super._totalRegistros, () {
      super._totalRegistros = value;
    });
  }

  late final _$_pagesAtom = Atom(
    name: 'CongresistaCtrlBase._pages',
    context: context,
  );

  int get pages {
    _$_pagesAtom.reportRead();
    return super._pages;
  }

  @override
  int get _pages => pages;

  @override
  set _pages(int value) {
    _$_pagesAtom.reportWrite(value, super._pages, () {
      super._pages = value;
    });
  }

  late final _$_sizeAtom = Atom(
    name: 'CongresistaCtrlBase._size',
    context: context,
  );

  int get size {
    _$_sizeAtom.reportRead();
    return super._size;
  }

  @override
  int get _size => size;

  @override
  set _size(int value) {
    _$_sizeAtom.reportWrite(value, super._size, () {
      super._size = value;
    });
  }

  late final _$_isRefreshingAtom = Atom(
    name: 'CongresistaCtrlBase._isRefreshing',
    context: context,
  );

  bool get isRefreshing {
    _$_isRefreshingAtom.reportRead();
    return super._isRefreshing;
  }

  @override
  bool get _isRefreshing => isRefreshing;

  @override
  set _isRefreshing(bool value) {
    _$_isRefreshingAtom.reportWrite(value, super._isRefreshing, () {
      super._isRefreshing = value;
    });
  }

  late final _$congresistasAtom = Atom(
    name: 'CongresistaCtrlBase.congresistas',
    context: context,
  );

  @override
  ObservableList<Usuario> get congresistas {
    _$congresistasAtom.reportRead();
    return super.congresistas;
  }

  @override
  set congresistas(ObservableList<Usuario> value) {
    _$congresistasAtom.reportWrite(value, super.congresistas, () {
      super.congresistas = value;
    });
  }

  late final _$_condicionAtom = Atom(
    name: 'CongresistaCtrlBase._condicion',
    context: context,
  );

  String? get condicion {
    _$_condicionAtom.reportRead();
    return super._condicion;
  }

  @override
  String? get _condicion => condicion;

  @override
  set _condicion(String? value) {
    _$_condicionAtom.reportWrite(value, super._condicion, () {
      super._condicion = value;
    });
  }

  late final _$_congresistaAtom = Atom(
    name: 'CongresistaCtrlBase._congresista',
    context: context,
  );

  Usuario? get congresista {
    _$_congresistaAtom.reportRead();
    return super._congresista;
  }

  @override
  Usuario? get _congresista => congresista;

  @override
  set _congresista(Usuario? value) {
    _$_congresistaAtom.reportWrite(value, super._congresista, () {
      super._congresista = value;
    });
  }

  late final _$guardarAsyncAction = AsyncAction(
    'CongresistaCtrlBase.guardar',
    context: context,
  );

  @override
  Future<void> guardar() {
    return _$guardarAsyncAction.run(() => super.guardar());
  }

  late final _$restablecerContrasenhaAsyncAction = AsyncAction(
    'CongresistaCtrlBase.restablecerContrasenha',
    context: context,
  );

  @override
  Future<void> restablecerContrasenha() {
    return _$restablecerContrasenhaAsyncAction.run(
      () => super.restablecerContrasenha(),
    );
  }

  late final _$consultaAsyncAction = AsyncAction(
    'CongresistaCtrlBase.consulta',
    context: context,
  );

  @override
  Future<List<Usuario>> consulta() {
    return _$consultaAsyncAction.run(() => super.consulta());
  }

  late final _$consultaCongresistaPorTipoAsyncAction = AsyncAction(
    'CongresistaCtrlBase.consultaCongresistaPorTipo',
    context: context,
  );

  @override
  Future<List<Usuario>> consultaCongresistaPorTipo(
    TipoUsuarioEnum tipoUsuario,
  ) {
    return _$consultaCongresistaPorTipoAsyncAction.run(
      () => super.consultaCongresistaPorTipo(tipoUsuario),
    );
  }

  late final _$CongresistaCtrlBaseActionController = ActionController(
    name: 'CongresistaCtrlBase',
    context: context,
  );

  @override
  void changeStatus(String message, StatusEnumGlobal status) {
    final _$actionInfo = _$CongresistaCtrlBaseActionController.startAction(
      name: 'CongresistaCtrlBase.changeStatus',
    );
    try {
      return super.changeStatus(message, status);
    } finally {
      _$CongresistaCtrlBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
congresistas: ${congresistas}
    ''';
  }
}
