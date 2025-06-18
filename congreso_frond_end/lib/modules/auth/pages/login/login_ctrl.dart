import 'package:congreso_evento/core/exception/service_exception.dart';
import 'package:congreso_evento/modules/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'login_ctrl.g.dart';

class LoginCtrl = LoginCtrlBase with _$LoginCtrl;

enum AuthStatus {
  initial,
  loading,
  isLogged,
  noLogged,
  noRecordarPassword,
  error,
}

abstract class LoginCtrlBase with Store {
  final AuthService service;

  LoginCtrlBase(this.service);

  @readonly
  AuthStatus _status = AuthStatus.initial;

  @readonly
  String _message = '';

  @action
  Future<void> login(String email, String contrasenha, bool recordar) async {
    try {
      var response = await service.autenticar(email, contrasenha, recordar);
      final data = response.data;
      final code = response.code;
      final message = response.message;

      debugPrint('Response: ${data.jwttoken}, Code: $code, Message: $message');

      if (code == 301) {
        // _status = StatusEnumGlobal.loaded;
        return;
      }

      if (code == 201) {
        // isPendienteActivacion = true;
        // currentIndex = 2;
        // _message = 'Autenticado con éxito, pendiente de Activación';
        // _status = StatusEnumGlobal.success;
        return;
      }
      if (code != 200) {
        // _message = message;
        // _status = StatusEnumGlobal.errorDialog;
        return;
      }

      // _message = 'Autenticado con éxito';
      // _status = StatusEnumGlobal.success;
      return;
    } on ServiceException catch (e) {
      // _message = e.message;
      // _status = StatusEnumGlobal.error;
      return;
    }
  }

  Future<void> logout() async {
    await service.logout();
    return;
  }

  Future<String> getVersion() async {
    return await service.getVersion();
  }
}
