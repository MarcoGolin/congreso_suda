// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_ctrl.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoginCtrl on LoginCtrlBase, Store {
  late final _$_statusAtom = Atom(
    name: 'LoginCtrlBase._status',
    context: context,
  );

  AuthStatus get status {
    _$_statusAtom.reportRead();
    return super._status;
  }

  @override
  AuthStatus get _status => status;

  @override
  set _status(AuthStatus value) {
    _$_statusAtom.reportWrite(value, super._status, () {
      super._status = value;
    });
  }

  late final _$_messageAtom = Atom(
    name: 'LoginCtrlBase._message',
    context: context,
  );

  String get message {
    _$_messageAtom.reportRead();
    return super._message;
  }

  @override
  String get _message => message;

  @override
  set _message(String value) {
    _$_messageAtom.reportWrite(value, super._message, () {
      super._message = value;
    });
  }

  late final _$_stateClassAtom = Atom(
    name: 'LoginCtrlBase._stateClass',
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

  late final _$loginAsyncAction = AsyncAction(
    'LoginCtrlBase.login',
    context: context,
  );

  @override
  Future<void> login(String email, String contrasenha, bool recordar) {
    return _$loginAsyncAction.run(
      () => super.login(email, contrasenha, recordar),
    );
  }

  late final _$LoginCtrlBaseActionController = ActionController(
    name: 'LoginCtrlBase',
    context: context,
  );

  @override
  void changeStatus(String message, StatusEnumGlobal status) {
    final _$actionInfo = _$LoginCtrlBaseActionController.startAction(
      name: 'LoginCtrlBase.changeStatus',
    );
    try {
      return super.changeStatus(message, status);
    } finally {
      _$LoginCtrlBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
