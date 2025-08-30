import 'package:congreso_evento/core_module.dart';
import 'package:congreso_evento/modules/auth/auth_guard.dart';
import 'package:congreso_evento/modules/auth/pages/ingreso_restringido/ingreso_restringido_page.dart';
import 'package:congreso_evento/modules/auth/pages/login/auth/auth_loader_page.dart';
import 'package:congreso_evento/modules/auth/pages/login/login_page.dart';
import 'package:congreso_evento/modules/home/home_page.dart';
import 'package:congreso_evento/modules/home_admin/home_admin_module.dart';
import 'package:congreso_evento/modules/home_congresista/home_congresista_module.dart';
import 'package:congreso_evento/modules/inscripcion/Inscripcion_module.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/trabajo_cientifico_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  void binds(i) {}

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
    r.child('/auth_loader', child: (_) => const AuthLoaderPage());
    r.child(
      '/ingreso_restringido',
      child: (_) => const IngresoRestringidoPage(),
    );
    // r.wildcard(child: (context) => const PaginaNoEncontradaPage());
  }
}
