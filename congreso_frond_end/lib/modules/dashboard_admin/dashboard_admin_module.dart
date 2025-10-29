import 'package:congreso_evento/core_module.dart';
import 'package:congreso_evento/modules/dashboard_admin/pages/home_admin_dashboard_page.dart';
import 'package:congreso_evento/modules/dashboard_admin/services/dashboard_admin_api.dart';
import 'package:congreso_evento/modules/dashboard_admin/stores/home_admin_dashboard_store.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DashboardAdminModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton(DashboardAdminApi.new);
    i.addLazySingleton(HomeAdminDashboardStore.new);
  }

  @override
  List<Module> get imports => [CoreModule()];

  @override
  void routes(r) {
    r.child('/', child: (context) => HomeAdminDashboardPage());
  }

  // @override
  // List<Bind> get binds => [
  //   Bind.lazySingleton((i) => DashboardAdminApi(i())),
  //   Bind.lazySingleton((i) => HomeAdminDashboardStore(i())),
  // ];

  // @override
  // List<ModularRoute> get routes => [
  //   ChildRoute('/', child: (_, __) => const HomeAdminDashboardPage()),
  // ];
}
