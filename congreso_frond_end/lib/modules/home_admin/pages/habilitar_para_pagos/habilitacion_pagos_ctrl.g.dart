// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habilitacion_pagos_ctrl.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HabilitacionPagosCtrl on HabilitacionPagosCtrlBase, Store {
  late final _$listaHabilitacionPagosAtom = Atom(
    name: 'HabilitacionPagosCtrlBase.listaHabilitacionPagos',
    context: context,
  );

  @override
  ObservableList<HabilitacionPagos> get listaHabilitacionPagos {
    _$listaHabilitacionPagosAtom.reportRead();
    return super.listaHabilitacionPagos;
  }

  @override
  set listaHabilitacionPagos(ObservableList<HabilitacionPagos> value) {
    _$listaHabilitacionPagosAtom.reportWrite(
      value,
      super.listaHabilitacionPagos,
      () {
        super.listaHabilitacionPagos = value;
      },
    );
  }

  late final _$_stateClassAtom = Atom(
    name: 'HabilitacionPagosCtrlBase._stateClass',
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

  late final _$habilitarAsyncAction = AsyncAction(
    'HabilitacionPagosCtrlBase.habilitar',
    context: context,
  );

  @override
  Future<void> habilitar({required HabilitacionPagos habilitar}) {
    return _$habilitarAsyncAction.run(
      () => super.habilitar(habilitar: habilitar),
    );
  }

  late final _$consultaHorariosAsyncAction = AsyncAction(
    'HabilitacionPagosCtrlBase.consultaHorarios',
    context: context,
  );

  @override
  Future<void> consultaHorarios({required int idUsuario}) {
    return _$consultaHorariosAsyncAction.run(
      () => super.consultaHorarios(idUsuario: idUsuario),
    );
  }

  late final _$HabilitacionPagosCtrlBaseActionController = ActionController(
    name: 'HabilitacionPagosCtrlBase',
    context: context,
  );

  @override
  void changeStatus(String message, StatusEnumGlobal status) {
    final _$actionInfo = _$HabilitacionPagosCtrlBaseActionController
        .startAction(name: 'HabilitacionPagosCtrlBase.changeStatus');
    try {
      return super.changeStatus(message, status);
    } finally {
      _$HabilitacionPagosCtrlBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
listaHabilitacionPagos: ${listaHabilitacionPagos}
    ''';
  }
}
