// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trabajo_cientifico_registro_ctrl.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TrabajoCientificoRegistroCtrl
    on TrabajoCientificoRegistroCtrlBase, Store {
  late final _$_stateClassAtom = Atom(
    name: 'TrabajoCientificoRegistroCtrlBase._stateClass',
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

  late final _$saveAsyncAction = AsyncAction(
    'TrabajoCientificoRegistroCtrlBase.save',
    context: context,
  );

  @override
  Future<void> save() {
    return _$saveAsyncAction.run(() => super.save());
  }

  late final _$TrabajoCientificoRegistroCtrlBaseActionController =
      ActionController(
        name: 'TrabajoCientificoRegistroCtrlBase',
        context: context,
      );

  @override
  void changeStatus(String message, StatusEnumGlobal status) {
    final _$actionInfo = _$TrabajoCientificoRegistroCtrlBaseActionController
        .startAction(name: 'TrabajoCientificoRegistroCtrlBase.changeStatus');
    try {
      return super.changeStatus(message, status);
    } finally {
      _$TrabajoCientificoRegistroCtrlBaseActionController.endAction(
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
