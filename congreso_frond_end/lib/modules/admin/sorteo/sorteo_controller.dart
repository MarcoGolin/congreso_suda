import 'dart:async';
import 'dart:math';

import 'package:congreso_evento/modules/auspiciantes/model/auspiciante.dart';
import 'package:mobx/mobx.dart';

import 'models/congresista_model.dart';

part 'sorteo_controller.g.dart';

class SorteoController = _SorteoControllerBase with _$SorteoController;

abstract class _SorteoControllerBase with Store {
  // --- MOCK DATA ---
  final List<Auspiciante> auspiciantes = Auspiciante.all();

  final List<Congresista> _congresistas = [
    Congresista(id: '1', nombre: 'Ana García'),
    Congresista(id: '2', nombre: 'Carlos Rodríguez'),
    Congresista(id: '3', nombre: 'María Fernández'),
    Congresista(id: '4', nombre: 'José Martínez'),
    Congresista(id: '5', nombre: 'Laura Pérez'),
    Congresista(id: '6', nombre: 'Sofía Gómez'),
    Congresista(id: '7', nombre: 'Luis Hernández'),
    Congresista(id: '8', nombre: 'Valeria Torres'),
  ];
  // --- END MOCK DATA ---

  _SorteoControllerBase() {
    // Ordenamos la lista de auspiciantes alfabéticamente
    auspiciantes.sort((a, b) => a.name.compareTo(b.name));
    // Seleccionamos un auspiciante por defecto al iniciar
    seleccionarAuspiciante(auspiciantes.first);
  }

  @observable
  bool isLoading = false;

  @observable
  Auspiciante? auspicianteSeleccionado;

  @observable
  Congresista? ganador;

  @observable
  String nombreSorteandose = '';

  Timer? _animationTimer;

  @action
  void seleccionarAuspiciante(Auspiciante auspiciante) {
    auspicianteSeleccionado = auspiciante;
    ganador = null;
  }

  Future<List<Auspiciante>> getAuspiciantes(String query) async {
    // Simula una llamada a una base de datos o API
    await Future.delayed(const Duration(milliseconds: 500));
    return auspiciantes;
  }

  @action
  Future<void> realizarSorteo() async {
    if (isLoading) return;

    isLoading = true;
    ganador = null;
    final random = Random();

    // Inicia la animación "Slot Machine"
    _animationTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      final randomIndex = random.nextInt(_congresistas.length);
      nombreSorteandose = _congresistas[randomIndex].nombre;
    });

    // Espera 3 segundos mientras la animación se ejecuta
    await Future.delayed(const Duration(seconds: 3));

    // Detiene la animación y selecciona al ganador final
    _animationTimer?.cancel();
    if (_congresistas.isNotEmpty) {
      final ganadorIndex = random.nextInt(_congresistas.length);
      ganador = _congresistas[ganadorIndex];
    }

    nombreSorteandose = '';
    isLoading = false;
  }
}
