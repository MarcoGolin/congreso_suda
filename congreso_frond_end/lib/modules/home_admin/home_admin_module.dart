import 'package:congreso_evento/core_module.dart';
import 'package:congreso_evento/modules/congresista/congresista_repository.dart';
import 'package:congreso_evento/modules/home_admin/pages/home_admin_page.dart';
import 'package:congreso_evento/modules/home_admin/pages/pagos/pago_page_ctrl.dart';
import 'package:congreso_evento/modules/home_admin/pages/pagos/pagos_page.dart';
import 'package:congreso_evento/modules/home_admin/pages/pagos/repositories/pago_repository.dart';
import 'package:congreso_evento/modules/home_admin/pages/pagos/services/pago_service.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeAdminModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton(PagoPageCtrl.new);
    i.addLazySingleton(PagoService.new);
    i.addLazySingleton(PagoRepository.new);
    i.addLazySingleton(CongresistaRepository.new);
  }

  @override
  List<Module> get imports => [CoreModule()];

  @override
  void routes(r) {
    r.child('/', child: (context) => HomeAdminPage());
    r.child('/pagos', child: (context) => const PagosPage());
  }
}
