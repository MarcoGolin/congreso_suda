import 'package:mobx/mobx.dart';

import 'default_state_notififier.dart';

part 'default_change_notifier.g.dart';

class DefaultChangeNotifier = DefaultChangeNotifierBase
    with _$DefaultChangeNotifier;

abstract class DefaultChangeNotifierBase with Store {
  @readonly
  StatusEnumGlobal _statusChange = StatusEnumGlobal.loaded;
  @readonly
  String _messageChange = '';

  void iniLoading() {
    _messageChange = '';
    _statusChange = StatusEnumGlobal.loading;
  }

  void iniLoadingList() {
    _messageChange = '';
    _statusChange = StatusEnumGlobal.loadingList;
  }

  void onSucces(String message) {
    _messageChange = message;
    _statusChange = StatusEnumGlobal.success;
  }

  void onSuccesAndBack(String message) {
    _messageChange = message;
    _statusChange = StatusEnumGlobal.successAndBack;
  }

  void onSuccesAndNavigateHome(String message) {
    _messageChange = message;
    _statusChange = StatusEnumGlobal.successAndNavigateHome;
  }

  void onSuccesAndNavigateAtivarNovaConta(String message) {
    _messageChange = message;
    _statusChange = StatusEnumGlobal.successAndNavigateAtivarNovaConta;
  }

  void onWarning(String message) {
    _messageChange = message;
    _statusChange = StatusEnumGlobal.warning;
  }

  void onError(String message) {
    _messageChange = message;
    _statusChange = StatusEnumGlobal.error;
  }

  void onErrorAndNavigateLogin(String message) {
    _messageChange = message;
    _statusChange = StatusEnumGlobal.errorAndNavigateLogin;
  }

  void resetState() {
    _messageChange = '';
    _statusChange = StatusEnumGlobal.loaded;
  }
}
