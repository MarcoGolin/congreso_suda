import 'package:congreso_evento/modules/home/home_page.dart';
import 'package:congreso_evento/modules/usuario/congresista_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/', child: (context) => HomePage());
    r.module('/congresista', module: CongresistaModule());
  }
}
