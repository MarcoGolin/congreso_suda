import 'package:congreso_evento/core_module.dart';
import 'package:congreso_evento/modules/home_congresista/pages/home_congresista_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeCongresistaModule extends Module {
  @override
  void binds(i) {
    // i.addLazySingleton(CongresistaRegistroCtrl.new);
    // i.addLazySingleton(CongresistaService.new);
    // i.addLazySingleton(CongresistaRepository.new);
  }

  @override
  List<Module> get imports => [CoreModule()];

  @override
  void routes(r) {
    r.child('/', child: (context) => HomeCongresistaPage());
  }
}
