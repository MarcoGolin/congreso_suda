import 'package:congreso_evento/core_module.dart';
import 'package:congreso_evento/modules/sorteo/repositories/sorteo_repository.dart';
import 'package:congreso_evento/modules/sorteo/service/sorteo_service.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'sorteo_controller.dart';
import 'sorteo_page.dart';

class SorteoModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton(SorteoController.new);
    i.addLazySingleton(SorteoService.new);
    i.addLazySingleton(SorteoRepository.new);
  }

  @override
  List<Module> get imports => [CoreModule()];

  @override
  void routes(r) {
    r.child('/', child: (context) => const SorteoPage());
  }
}
