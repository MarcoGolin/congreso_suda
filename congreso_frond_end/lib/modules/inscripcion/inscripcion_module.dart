import 'package:congreso_evento/core_module.dart';
import 'package:congreso_evento/modules/inscripcion/inscripcion_repository.dart';
import 'package:congreso_evento/modules/inscripcion/inscripcion_service.dart';
import 'package:congreso_evento/modules/inscripcion/pages/inscripcion_registro_ctrl.dart';
import 'package:congreso_evento/modules/inscripcion/pages/inscripcion_registro_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class InscripcionModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton(InscripcionRegistroCtrl.new);
    i.addLazySingleton(InscripcionService.new);
    i.addLazySingleton(InscripcionRepository.new);
  }

  @override
  List<Module> get imports => [CoreModule()];

  @override
  void routes(r) {
    r.child('/', child: (context) => InscripcionRegistroPage());
  }
}
