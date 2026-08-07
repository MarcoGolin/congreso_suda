import 'package:congreso_evento/core_module.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/repositories/congresista_repository.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/services/congresista_service.dart';
import 'package:congreso_evento/modules/talleres/pages/taller_inscripcion/taller_inscripcion_ctrl.dart';
import 'package:congreso_evento/modules/talleres/pages/taller_inscripcion/taller_inscripcion_page.dart';
import 'package:congreso_evento/modules/talleres/pages/tallet_asignar_responsable/taller_asignar_responsable_ctrl.dart';
import 'package:congreso_evento/modules/talleres/pages/tallet_asignar_responsable/taller_asignar_responsable_page.dart';
import 'package:congreso_evento/modules/talleres/repositories/taller_inscripto_repository.dart';
import 'package:congreso_evento/modules/talleres/repositories/taller_repository.dart';
import 'package:congreso_evento/modules/talleres/services/taller_inscripto_service.dart';
import 'package:congreso_evento/modules/talleres/services/taller_service.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TallerModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton(TallerInscripcionCtrl.new);
    i.addLazySingleton(TallerService.new);
    i.addLazySingleton(TallerRepository.new);

    i.addLazySingleton(TallerAsignarResponsableCtrl.new);
    i.addLazySingleton(CongresistaService.new);
    i.addLazySingleton(CongresistaRepository.new);

    i.addLazySingleton(TallerInscriptoService.new);
    i.addLazySingleton(TallerInscriptoRepository.new);
  }

  @override
  List<Module> get imports => [CoreModule()];

  @override
  void routes(r) {
    r.child('/', child: (context) => const TallerInscripcionPage());
    r.child('/:idTaller', child: (context) => const TallerInscripcionPage());
    r.child(
      '/asignar_responsable/:idTaller',
      child: (context) => TallerAsignarResponsablePage(),
    );
  }
}
