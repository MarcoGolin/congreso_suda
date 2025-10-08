// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sorteo_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SorteoController on SorteoControllerBase, Store {
  late final _$isLoadingAtom = Atom(
    name: 'SorteoControllerBase.isLoading',
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

  late final _$auspicianteSeleccionadoAtom = Atom(
    name: 'SorteoControllerBase.auspicianteSeleccionado',
    context: context,
  );

  @override
  Auspiciante? get auspicianteSeleccionado {
    _$auspicianteSeleccionadoAtom.reportRead();
    return super.auspicianteSeleccionado;
  }

  @override
  set auspicianteSeleccionado(Auspiciante? value) {
    _$auspicianteSeleccionadoAtom.reportWrite(
      value,
      super.auspicianteSeleccionado,
      () {
        super.auspicianteSeleccionado = value;
      },
    );
  }

  late final _$ganadorAtom = Atom(
    name: 'SorteoControllerBase.ganador',
    context: context,
  );

  @override
  Usuario? get ganador {
    _$ganadorAtom.reportRead();
    return super.ganador;
  }

  @override
  set ganador(Usuario? value) {
    _$ganadorAtom.reportWrite(value, super.ganador, () {
      super.ganador = value;
    });
  }

  late final _$nombreSorteandoseAtom = Atom(
    name: 'SorteoControllerBase.nombreSorteandose',
    context: context,
  );

  @override
  String get nombreSorteandose {
    _$nombreSorteandoseAtom.reportRead();
    return super.nombreSorteandose;
  }

  @override
  set nombreSorteandose(String value) {
    _$nombreSorteandoseAtom.reportWrite(value, super.nombreSorteandose, () {
      super.nombreSorteandose = value;
    });
  }

  late final _$tipoSorteoAtom = Atom(
    name: 'SorteoControllerBase.tipoSorteo',
    context: context,
  );

  @override
  String get tipoSorteo {
    _$tipoSorteoAtom.reportRead();
    return super.tipoSorteo;
  }

  @override
  set tipoSorteo(String value) {
    _$tipoSorteoAtom.reportWrite(value, super.tipoSorteo, () {
      super.tipoSorteo = value;
    });
  }

  late final _$_stateClassAtom = Atom(
    name: 'SorteoControllerBase._stateClass',
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

  late final _$sortearAsyncAction = AsyncAction(
    'SorteoControllerBase.sortear',
    context: context,
  );

  @override
  Future<void> sortear() {
    return _$sortearAsyncAction.run(() => super.sortear());
  }

  late final _$consultaCongresistaDisponiblesSorteoAsyncAction = AsyncAction(
    'SorteoControllerBase.consultaCongresistaDisponiblesSorteo',
    context: context,
  );

  @override
  Future<List<Usuario>> consultaCongresistaDisponiblesSorteo() {
    return _$consultaCongresistaDisponiblesSorteoAsyncAction.run(
      () => super.consultaCongresistaDisponiblesSorteo(),
    );
  }

  late final _$SorteoControllerBaseActionController = ActionController(
    name: 'SorteoControllerBase',
    context: context,
  );

  @override
  void changeStatus(String message, StatusEnumGlobal status) {
    final _$actionInfo = _$SorteoControllerBaseActionController.startAction(
      name: 'SorteoControllerBase.changeStatus',
    );
    try {
      return super.changeStatus(message, status);
    } finally {
      _$SorteoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void seleccionarAuspiciante(Auspiciante auspiciante) {
    final _$actionInfo = _$SorteoControllerBaseActionController.startAction(
      name: 'SorteoControllerBase.seleccionarAuspiciante',
    );
    try {
      return super.seleccionarAuspiciante(auspiciante);
    } finally {
      _$SorteoControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
auspicianteSeleccionado: ${auspicianteSeleccionado},
ganador: ${ganador},
nombreSorteandose: ${nombreSorteandose},
tipoSorteo: ${tipoSorteo}
    ''';
  }
}
