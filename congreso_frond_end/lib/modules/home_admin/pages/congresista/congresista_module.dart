import 'package:congreso_evento/core_module.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/congresista_ctrl.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/congresista_page.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/repositories/congresista_repository.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/services/congresista_service.dart';
import 'package:congreso_evento/modules/home_admin/pages/habilitar_para_pagos/habilitacion_pagos_ctrl.dart';
import 'package:congreso_evento/modules/home_admin/pages/pagos/repositories/habilitacion_pagos_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../pagos/services/habilitacion_pagos_service.dart';

class CongresistaModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton(CongresistaCtrl.new);
    i.addLazySingleton(CongresistaService.new);
    i.addLazySingleton(CongresistaRepository.new);

    i.add(HabilitacionPagosCtrl.new);
    i.addLazySingleton(HabilitacionPagosService.new);
    i.addLazySingleton(HabilitacionPagosRepository.new);
  }

  @override
  List<Module> get imports => [CoreModule()];

  @override
  void routes(r) {
    r.child('/', child: (context) => CongresistaPage());
  }
}
