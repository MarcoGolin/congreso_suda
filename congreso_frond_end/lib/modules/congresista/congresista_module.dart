import 'package:congreso_evento/core_module.dart';
import 'package:congreso_evento/modules/congresista/congresista_repository.dart';
import 'package:congreso_evento/modules/congresista/congresista_service.dart';
import 'package:congreso_evento/modules/congresista/pages/congresista_registro_ctrl.dart';
import 'package:congreso_evento/modules/congresista/pages/congresista_registro_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CongresistaModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton(CongresistaRegistroCtrl.new);
    i.addLazySingleton(CongresistaService.new);
    i.addLazySingleton(CongresistaRepository.new);
  }

  @override
  List<Module> get imports => [CoreModule()];

  @override
  void routes(r) {
    r.child('/', child: (context) => CongresistaRegistroPage());
  }
}
