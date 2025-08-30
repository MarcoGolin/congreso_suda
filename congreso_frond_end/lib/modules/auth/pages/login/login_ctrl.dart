import 'package:congreso_evento/core/exception/service_exception.dart';
import 'package:congreso_evento/core/models/global_state_class.dart';
import 'package:congreso_evento/core/notifiier/default_state_notififier.dart';
import 'package:congreso_evento/modules/auth/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  final FlutterSecureStorage storage;

  LoginCtrlBase(this.service, this.storage);

  @readonly
  AuthStatus _status = AuthStatus.initial;

  @readonly
  String _message = '';

  @readonly
  GlobalStateClass _stateClass = GlobalStateClass(
    status: StatusEnumGlobal.loaded,
    message: '',
  );

  @action
  void changeStatus(String message, StatusEnumGlobal status) {
    _stateClass = _stateClass.copyWith(message: message, status: status);
  }

  @action
  Future<void> login(String email, String contrasenha, bool recordar) async {
    try {
      changeStatus('Cargando...', StatusEnumGlobal.loading);

      var response = await service.autenticar(email, contrasenha, recordar);
      final data = response.data;
      final code = response.code;
      final message = response.message;

      if (code == 301) {
        // _status = StatusEnumGlobal.loaded;
        return;
      }

      if (code == 201) {
        // isPendienteActivacion = true;
        // currentIndex = 2;
        // _message = 'Autenticado con éxito, pendiente de Activación';
        // _status = StatusEnumGlobal.success;
        changeStatus(message, StatusEnumGlobal.success);
        return;
      }
      if (code != 200) {
        changeStatus(message, StatusEnumGlobal.errorDialog);
        return;
      }

      changeStatus('Autenticado con éxito', StatusEnumGlobal.success);

      // final storage = const FlutterSecureStorage();
      // Por ejemplo: verificás si hay un token válido en SharedPreferences
      // final token = await storage.read(key: 'jwttoken');

      // _message = 'Autenticado con éxito';
      // _status = StatusEnumGlobal.success;

      final redirectPath = await storage.read(key: 'redirect_path') ?? '/';

      debugPrint('Redirecting to: $redirectPath');

      Modular.to.pushNamedAndRemoveUntil(
        redirectPath,
        ModalRoute.withName('/'), // mantiene solo el home como ruta previa
      );

      return;
    } on ServiceException catch (e) {
      changeStatus(e.message, StatusEnumGlobal.errorDialog);
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
