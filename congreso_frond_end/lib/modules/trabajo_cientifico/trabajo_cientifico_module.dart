import 'package:congreso_evento/core_module.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/pages/trabajo_cientifico_registro.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/pages/trabajo_cientifico_registro_ctrl.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/trabajo_cientifico_repository.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/trabajo_cientifico_service.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TrabajoCientificoModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton(TrabajoCientificoRegistroCtrl.new);
    i.addLazySingleton(TrabajoCientificoService.new);
    i.addLazySingleton(TrabajoCientificoRepository.new);
  }

  @override
  List<Module> get imports => [CoreModule()];

  @override
  void routes(r) {
    r.child('/', child: (context) => TrabajoCientificoRegistro());
  }
}
