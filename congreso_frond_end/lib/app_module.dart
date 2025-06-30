import 'package:congreso_evento/core_module.dart';
import 'package:congreso_evento/modules/auth/auth_guard.dart';
import 'package:congreso_evento/modules/auth/pages/login/auth/auth_loader_page.dart';
import 'package:congreso_evento/modules/auth/pages/login/login_page.dart';
import 'package:congreso_evento/modules/congresista/congresista_module.dart';
import 'package:congreso_evento/modules/home/home_page.dart';
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
      module: CongresistaModule(),
      transition: TransitionType.rightToLeft,
    );
    r.module(
      '/trabajo_cientifico',
      module: TrabajoCientificoModule(),
      guards: [AuthGuard()],
      transition: TransitionType.rightToLeft,
    );
    r.child('/auth_loader', child: (_) => const AuthLoaderPage());
  }
}
