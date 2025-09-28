// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_congresista_ctrl.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeCongresistaCtrl on HomeCongresistaCtrlBase, Store {
  late final _$_stateClassAtom = Atom(
    name: 'HomeCongresistaCtrlBase._stateClass',
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

  late final _$_congresistaAtom = Atom(
    name: 'HomeCongresistaCtrlBase._congresista',
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

  late final _$consultaCongresistaPorIdAsyncAction = AsyncAction(
    'HomeCongresistaCtrlBase.consultaCongresistaPorId',
    context: context,
  );

  @override
  Future<Usuario?> consultaCongresistaPorId(int idUsuario) {
    return _$consultaCongresistaPorIdAsyncAction.run(
      () => super.consultaCongresistaPorId(idUsuario),
    );
  }

  late final _$HomeCongresistaCtrlBaseActionController = ActionController(
    name: 'HomeCongresistaCtrlBase',
    context: context,
  );

  @override
  void changeStatus(String message, StatusEnumGlobal status) {
    final _$actionInfo = _$HomeCongresistaCtrlBaseActionController.startAction(
      name: 'HomeCongresistaCtrlBase.changeStatus',
    );
    try {
      return super.changeStatus(message, status);
    } finally {
      _$HomeCongresistaCtrlBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
