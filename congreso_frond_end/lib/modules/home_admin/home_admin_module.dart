import 'package:congreso_evento/core_module.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/congresista_module.dart';
import 'package:congreso_evento/modules/home_admin/pages/home_admin_page.dart';
import 'package:congreso_evento/modules/home_admin/pages/pagos/pago_module.dart';
import 'package:congreso_evento/modules/home_admin/pages/trabajos_cientificos/admin_trabajos_cientificos_module.dart';
import 'package:congreso_evento/modules/sorteo/sorteo_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeAdminModule extends Module {
  @override
  void binds(i) {}

  @override
  List<Module> get imports => [CoreModule()];

  @override
  void routes(r) {
    r.child('/', child: (context) => HomeAdminPage());
    r.module(
      '/pagos',
      module: PagoModule(),
      transition: TransitionType.rightToLeft,
    );
    r.module(
      '/congresista',
      module: CongresistaModule(),
      transition: TransitionType.rightToLeft,
    );
    r.module(
      '/trabajos',
      module: AdminTrabajosCientificosModule(),
      transition: TransitionType.rightToLeft,
    );
    r.module(
      '/sorteo',
      module: SorteoModule(),
      transition: TransitionType.rightToLeft,
    );
  }
}
