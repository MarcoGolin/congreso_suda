import 'package:congreso_evento/core_module.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/repositories/congresista_repository.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/services/congresista_service.dart';
import 'package:congreso_evento/modules/home_congresista/pages/home_congresista_ctrl.dart';
import 'package:congreso_evento/modules/home_congresista/pages/home_congresista_page.dart';
import 'package:congreso_evento/modules/home_congresista/pages/home_menu_congresista_page.dart';
import 'package:congreso_evento/modules/talleres/pages/mis_talleres_page.dart';
import 'package:congreso_evento/modules/talleres/services/taller_inscripto_service.dart';
import 'package:congreso_evento/modules/talleres/stores/mis_talleres_store.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/pages/mis_trabajos_cientificos_page.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/services/mis_trabajos_cientificos_service.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/stores/mis_trabajos_cientificos_store.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/trabajo_cientifico_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeCongresistaModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton(HomeCongresistaCtrl.new);
    i.addLazySingleton(CongresistaService.new);
    i.addLazySingleton(CongresistaRepository.new);

    // Talleres inscriptos
    i.addLazySingleton(TallerInscriptoService.new);
    i.addLazySingleton(MisTalleresStore.new);

    i.addLazySingleton(MisTrabajosCientificosStore.new);
    i.addLazySingleton(MisTrabajosCientificosService.new);
    i.addLazySingleton(TrabajoCientificoRepository.new);
  }

  @override
  List<Module> get imports => [CoreModule()];

  @override
  void routes(r) {
    r.child('/', child: (context) => const HomeMenuCongresistaPage());
    r.child('/perfil', child: (context) => const HomeCongresistaPage());
    r.child(
      '/mis_talleres',
      child: (_) => const MisTalleresPage(),
      transition: TransitionType.rightToLeft,
    );
    r.child(
      '/mis_trabajos_cientificos',
      child: (_) => const MisTrabajosCientificosPage(),
      transition: TransitionType.rightToLeft,
    );
  }
}
