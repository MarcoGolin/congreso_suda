// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taller_inscripcion_ctrl.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TallerInscripcionCtrl on TallerInscripcionCtrlBase, Store {
  late final _$_tallerInscriptoAtom = Atom(
    name: 'TallerInscripcionCtrlBase._tallerInscripto',
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
    name: 'TallerInscripcionCtrlBase._taller',
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

  late final _$_stateClassAtom = Atom(
    name: 'TallerInscripcionCtrlBase._stateClass',
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

  late final _$inscribirAsyncAction = AsyncAction(
    'TallerInscripcionCtrlBase.inscribir',
    context: context,
  );

  @override
  Future<TallerInscripto?> inscribir({required int idTaller}) {
    return _$inscribirAsyncAction.run(
      () => super.inscribir(idTaller: idTaller),
    );
  }

  late final _$verificarInscriptoAsyncAction = AsyncAction(
    'TallerInscripcionCtrlBase.verificarInscripto',
    context: context,
  );

  @override
  Future<TallerInscripto?> verificarInscripto({required int idTaller}) {
    return _$verificarInscriptoAsyncAction.run(
      () => super.verificarInscripto(idTaller: idTaller),
    );
  }

  late final _$TallerInscripcionCtrlBaseActionController = ActionController(
    name: 'TallerInscripcionCtrlBase',
    context: context,
  );

  @override
  void changeStatus(String message, StatusEnumGlobal status) {
    final _$actionInfo = _$TallerInscripcionCtrlBaseActionController
        .startAction(name: 'TallerInscripcionCtrlBase.changeStatus');
    try {
      return super.changeStatus(message, status);
    } finally {
      _$TallerInscripcionCtrlBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
