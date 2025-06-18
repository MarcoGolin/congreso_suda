import 'package:congreso_evento/core/dio/api_rest_client.dart';
import 'package:congreso_evento/modules/auth/pages/login/login_ctrl.dart';
import 'package:congreso_evento/modules/auth/repositories/auth_repository.dart';
import 'package:congreso_evento/modules/auth/services/auth_service.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CoreModule extends Module {
  @override
  void exportedBinds(i) {
    // injector.add: Build an instance on demand (Factory).
    // i.add(AuthCtrl.new);
    // i.add(LoginService.new);
    // i.add(RecuperarCuentaRepository.new);
    // i.add(AuthRepository.new);
    // i.add(VersaoRepository.new);
    // i.add(FlutterSecureStorage.new);
    // i.add(LicenciaService.new);
    // i.add(CotacaoService.new);
    // injector.addSingleton: Build an instance only once when the module starts.
    // i.addSingleton(GlobalSearchCtrl.new);
    i.addSingleton(Api.new);
    i.addSingleton(FlutterSecureStorage.new);

    //Auht
    i.addLazySingleton(LoginCtrl.new);
    i.addSingleton(AuthService.new);
    i.addSingleton(AuthRepository.new);
    // i.addSingleton(AuthShared.new);

    // i.addSingleton(BancardPosService.new);
    // i.addSingleton(BancardPosRepository.new);

    // i.addSingleton(DinelcoPosService.new);
    // i.addSingleton(DinelcoPosRepository.new);

    // i.addLazySingleton(LicencaInativaCtrl.new);
    // i.addLazySingleton(BancardService.new);
    // i.addLazySingleton(BancardRepository.new);

    // i.addLazySingleton(PrintService.new);
    // injector.addLazySingleton: Build an instance only once when prompted.

    // injector.addInstance: Adds an existing instance.
  }
}
