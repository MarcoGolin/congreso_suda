import 'package:congreso_evento/core_module.dart';
import 'package:congreso_evento/modules/home_admin/pages/pagos/pago_page_ctrl.dart';
import 'package:congreso_evento/modules/home_admin/pages/pagos/pagos_page.dart';
import 'package:congreso_evento/modules/home_admin/pages/pagos/repositories/habilitacion_pagos_repository.dart';
import 'package:congreso_evento/modules/home_admin/pages/pagos/repositories/pago_repository.dart';
import 'package:congreso_evento/modules/home_admin/pages/pagos/services/pago_service.dart';
import 'package:congreso_evento/modules/inscripcion/inscripcion_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';

class PagoModule extends Module {
  @override
  void binds(i) {
    i.add(PagoPageCtrl.new);
    i.addLazySingleton(PagoService.new);
    i.addLazySingleton(PagoRepository.new);
    i.addLazySingleton(InscripcionRepository.new);
    i.addLazySingleton(HabilitacionPagosRepository.new);
  }

  @override
  List<Module> get imports => [CoreModule()];

  @override
  void routes(r) {
    r.child('/', child: (context) => PagosPage());
  }
}
