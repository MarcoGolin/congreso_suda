import 'package:congreso_evento/modules/usuario/pages/congresista_registro_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class CongresistaModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/', child: (context) => CongresistaRegistroPage());
  }
}
