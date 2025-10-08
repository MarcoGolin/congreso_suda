import 'package:congreso_evento/core_module.dart';
import 'package:congreso_evento/modules/auth/auth_guard.dart';
import 'package:congreso_evento/modules/auth/pages/ingreso_restringido/ingreso_restringido_page.dart';
import 'package:congreso_evento/modules/auth/pages/login/auth/auth_loader_page.dart';
import 'package:congreso_evento/modules/auth/pages/login/login_page.dart';
import 'package:congreso_evento/modules/home/home_page.dart';
import 'package:congreso_evento/modules/home/home_page_ctrl.dart';
import 'package:congreso_evento/modules/home/repositories/organizadores_repository.dart';
import 'package:congreso_evento/modules/home/service/organizadores_service.dart';
import 'package:congreso_evento/modules/home_admin/home_admin_module.dart';
import 'package:congreso_evento/modules/home_congresista/home_congresista_module.dart';
import 'package:congreso_evento/modules/inscripcion/Inscripcion_module.dart';
import 'package:congreso_evento/modules/sorteo/sorteo_module.dart';
import 'package:congreso_evento/modules/talleres/repositories/taller_repository.dart';
import 'package:congreso_evento/modules/talleres/service/taller_service.dart';
import 'package:congreso_evento/modules/talleres/services/taller_inscripcion_service.dart';
import 'package:congreso_evento/modules/talleres/stores/mis_talleres_store.dart';
import 'package:congreso_evento/modules/talleres/taller_module.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/trabajo_cientifico_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'modules/checkin/controllers/checkin_ctrl.dart';
import 'modules/checkin/pages/checkin_page.dart';
import 'modules/checkin/repositories/checkin_repository.dart';
import 'modules/checkin/services/checkin_service.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton(HomePageCtrl.new);
    i.addLazySingleton(OrganizadoresService.new);
    i.addLazySingleton(OrganizadoresRepository.new);

    i.addLazySingleton(TallerService.new);
    i.addLazySingleton(TallerRepository.new);

    // Mis talleres
    i.addLazySingleton(TallerInscripcionService.new);
    i.addLazySingleton(MisTalleresStore.new);

    i.addLazySingleton(CheckinService.new);
    i.addLazySingleton(CheckinRepository.new);
    i.add(CheckinCtrl.new);
  }

  @override
  List<Module> get imports => [CoreModule()];

  @override
  void routes(r) {
    r.child('/', child: (context) => HomePage());
    r.child('/login_page', child: (context) => LoginPage());
    r.module(
      '/congresista',
      module: InscripcionModule(),
      transition: TransitionType.rightToLeft,
    );
    r.module(
      '/trabajo_cientifico',
      module: TrabajoCientificoModule(),
      guards: [AuthGuard()],
      transition: TransitionType.rightToLeft,
    );
    r.module(
      '/home_admin',
      module: HomeAdminModule(),
      guards: [AuthGuard()],
      transition: TransitionType.rightToLeft,
    );
    r.module(
      '/home_congresista',
      module: HomeCongresistaModule(),
      guards: [AuthGuard()],
      transition: TransitionType.rightToLeft,
    );
    r.module(
      '/taller_inscripcion',
      module: TallerModule(),
      guards: [AuthGuard()],
      transition: TransitionType.rightToLeft,
    );
    r.child('/auth_loader', child: (_) => const AuthLoaderPage());
    r.child(
      '/ingreso_restringido',
      child: (_) => const IngresoRestringidoPage(),
    );
    r.child(
      '/checkin',
      child: (_) => const CheckinPage(),
      guards: [AuthGuard()],
    );
    r.module('/sorteo', module: SorteoModule());
    // r.wildcard(child: (context) => const PaginaNoEncontradaPage());
  }
}
