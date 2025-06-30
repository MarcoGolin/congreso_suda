import 'package:congreso_evento/modules/trabajo_cientifico/pages/trabajo_cientifico_registro.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/pages/trabajo_cientifico_registro_ctrl.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TrabajoCientificoModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton(TrabajoCientificoRegistroCtrl.new);
    // i.addLazySingleton(CongresistaService.new);
    // i.addLazySingleton(CongresistaRepository.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => TrabajoCientificoRegistro());
  }
}
