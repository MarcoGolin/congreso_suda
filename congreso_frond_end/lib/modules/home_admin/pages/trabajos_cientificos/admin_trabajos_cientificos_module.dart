import 'package:congreso_evento/core_module.dart';
import 'package:congreso_evento/modules/home_admin/pages/trabajos_cientificos/admin_trabajos_cientificos_page.dart';
import 'package:congreso_evento/modules/home_admin/pages/trabajos_cientificos/detalle_trabajo_cientifico_page.dart';
import 'package:congreso_evento/modules/home_admin/pages/trabajos_cientificos/services/admin_trabajos_cientificos_service.dart';
import 'package:congreso_evento/modules/home_admin/pages/trabajos_cientificos/stores/admin_trabajos_cientificos_store.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/trabajo_cientifico_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AdminTrabajosCientificosModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton(TrabajoCientificoRepository.new);
    i.addLazySingleton(AdminTrabajosCientificosService.new);
    i.addLazySingleton(AdminTrabajosCientificosStore.new);
  }

  @override
  List<Module> get imports => [CoreModule()];

  @override
  void routes(r) {
    r.child('/', child: (context) => const AdminTrabajosCientificosPage());
    r.child(
      '/detalle/:trabajoId',
      child: (context) {
        // Obtener el ID del trabajo desde los parámetros de la ruta
        final trabajoId = int.tryParse(r.args.params['trabajoId'] ?? '');

        if (trabajoId == null) {
          throw Exception('ID de trabajo inválido');
        }

        // Obtener el store y buscar el trabajo por ID
        final store = Modular.get<AdminTrabajosCientificosStore>();
        final trabajo = store.obtenerTrabajoPorId(trabajoId);

        if (trabajo == null) {
          throw Exception('Trabajo científico no encontrado');
        }

        return DetalleTrabajoCientificoPage(trabajo: trabajo);
      },
    );
  }
}
