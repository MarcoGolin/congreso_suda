import 'package:flutter_modular/flutter_modular.dart';
import 'sorteo_controller.dart';
import 'sorteo_page.dart';

class SorteoModule extends Module {
  @override
  void binds(i) {
    i.addLazySingleton(SorteoController.new);
  }

  @override
  void routes(r) {
    r.child('/', child: (context) => const SorteoPage());
  }
}
