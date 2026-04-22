// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taller_asignar_responsable_ctrl.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TallerAsignarResponsableCtrl
    on TallerAsignarResponsableCtrlBase, Store {
  late final _$_tallerInscriptoAtom = Atom(
    name: 'TallerAsignarResponsableCtrlBase._tallerInscripto',
    context: context,
  );

  TallerInscripto? get tallerInscripto {
    _$_tallerInscriptoAtom.reportRead();
    return super._tallerInscripto;
  }

  @override
  TallerInscripto? get _tallerInscripto => tallerInscripto;

  @override
  set _tallerInscripto(TallerInscripto? value) {
    _$_tallerInscriptoAtom.reportWrite(value, super._tallerInscripto, () {
      super._tallerInscripto = value;
    });
  }

  late final _$_tallerAtom = Atom(
    name: 'TallerAsignarResponsableCtrlBase._taller',
    context: context,
  );

  Taller? get taller {
    _$_tallerAtom.reportRead();
    return super._taller;
  }

  @override
  Taller? get _taller => taller;

  @override
  set _taller(Taller? value) {
    _$_tallerAtom.reportWrite(value, super._taller, () {
      super._taller = value;
    });
  }

  late final _$_congresistaAtom = Atom(
    name: 'TallerAsignarResponsableCtrlBase._congresista',
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

  late final _$_stateClassAtom = Atom(
    name: 'TallerAsignarResponsableCtrlBase._stateClass',
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

  late final _$consultaTallerByDescripcionAsyncAction = AsyncAction(
    'TallerAsignarResponsableCtrlBase.consultaTallerByDescripcion',
    context: context,
  );

  @override
  Future<List<Taller>> consultaTallerByDescripcion({
    required String descripcion,
  }) {
    return _$consultaTallerByDescripcionAsyncAction.run(
      () => super.consultaTallerByDescripcion(descripcion: descripcion),
    );
  }

  late final _$consultaCongresistaPorNombreAsyncAction = AsyncAction(
    'TallerAsignarResponsableCtrlBase.consultaCongresistaPorNombre',
    context: context,
  );

  @override
  Future<List<Usuario>> consultaCongresistaPorNombre({
    required String buscador,
  }) {
    return _$consultaCongresistaPorNombreAsyncAction.run(
      () => super.consultaCongresistaPorNombre(buscador: buscador),
    );
  }

  late final _$asignarResponsableAsyncAction = AsyncAction(
    'TallerAsignarResponsableCtrlBase.asignarResponsable',
    context: context,
  );

  @override
  Future<void> asignarResponsable() {
    return _$asignarResponsableAsyncAction.run(
      () => super.asignarResponsable(),
    );
  }

  late final _$TallerAsignarResponsableCtrlBaseActionController =
      ActionController(
        name: 'TallerAsignarResponsableCtrlBase',
        context: context,
      );

  @override
  void changeStatus(String message, StatusEnumGlobal status) {
    final _$actionInfo = _$TallerAsignarResponsableCtrlBaseActionController
        .startAction(name: 'TallerAsignarResponsableCtrlBase.changeStatus');
    try {
      return super.changeStatus(message, status);
    } finally {
      _$TallerAsignarResponsableCtrlBaseActionController.endAction(
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
