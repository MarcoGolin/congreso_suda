import 'package:congreso_evento/core_module.dart';
import 'package:congreso_evento/modules/talleres/pages/taller_inscripcion_ctrl.dart';
import 'package:congreso_evento/modules/talleres/pages/taller_inscripcion_page.dart';
import 'package:congreso_evento/modules/talleres/repositories/taller_repository.dart';
import 'package:congreso_evento/modules/talleres/service/taller_service.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TallerModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton(TallerInscripcionCtrl.new);
    i.addLazySingleton(TallerService.new);
    i.addLazySingleton(TallerRepository.new);
  }

  @override
  List<Module> get imports => [CoreModule()];

  @override
  void routes(r) {
    r.child('/:id', child: (context) => TallerInscripcionPage());
  }
}
