// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'congresista_registro_ctrl.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CongresistaRegistroCtrl on CongresistaRegistroCtrlBase, Store {
  late final _$_usuarioAtom = Atom(
    name: 'CongresistaRegistroCtrlBase._usuario',
    context: context,
  );

  Usuario? get usuario {
    _$_usuarioAtom.reportRead();
    return super._usuario;
  }

  @override
  Usuario? get _usuario => usuario;

  @override
  set _usuario(Usuario? value) {
    _$_usuarioAtom.reportWrite(value, super._usuario, () {
      super._usuario = value;
    });
  }

  late final _$_stateClassAtom = Atom(
    name: 'CongresistaRegistroCtrlBase._stateClass',
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

  late final _$saveCongresistaAsyncAction = AsyncAction(
    'CongresistaRegistroCtrlBase.saveCongresista',
    context: context,
  );

  @override
  Future<void> saveCongresista({
    required String nombreCompleto,
    required String email,
    required String senha,
    required String telefone,
    required String institucion,
    required String registroAcademico,
    required String semestre,
    required String seccion,
    required String pais,
  }) {
    return _$saveCongresistaAsyncAction.run(
      () => super.saveCongresista(
        nombreCompleto: nombreCompleto,
        email: email,
        senha: senha,
        telefone: telefone,
        institucion: institucion,
        registroAcademico: registroAcademico,
        semestre: semestre,
        seccion: seccion,
        pais: pais,
      ),
    );
  }

  late final _$CongresistaRegistroCtrlBaseActionController = ActionController(
    name: 'CongresistaRegistroCtrlBase',
    context: context,
  );

  @override
  void changeStatus(String message, StatusEnumGlobal status) {
    final _$actionInfo = _$CongresistaRegistroCtrlBaseActionController
        .startAction(name: 'CongresistaRegistroCtrlBase.changeStatus');
    try {
      return super.changeStatus(message, status);
    } finally {
      _$CongresistaRegistroCtrlBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
