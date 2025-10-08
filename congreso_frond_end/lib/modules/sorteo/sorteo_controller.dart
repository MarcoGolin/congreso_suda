import 'dart:async';
import 'dart:math';

import 'package:congreso_evento/core/exception/service_exception.dart';
import 'package:congreso_evento/core/models/global_state_class.dart';
import 'package:congreso_evento/core/notifiier/default_state_notififier.dart';
import 'package:congreso_evento/modules/auspiciantes/model/auspiciante.dart';
import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:congreso_evento/modules/sorteo/service/sorteo_service.dart';
import 'package:mobx/mobx.dart';

part 'sorteo_controller.g.dart';

class SorteoController = SorteoControllerBase with _$SorteoController;

abstract class SorteoControllerBase with Store {
  final SorteoService service;

  // --- MOCK DATA ---
  final List<Auspiciante> auspiciantes = Auspiciante.all();

  final List<Usuario> _congresistas = [];
  // --- END MOCK DATA ---

  SorteoControllerBase(this.service) {
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
  Usuario? ganador;

  @observable
  String nombreSorteandose = '';

  @observable
  String tipoSorteo = 'Congresista';

  Timer? _animationTimer;

  @readonly
  GlobalStateClass _stateClass = GlobalStateClass(
    status: StatusEnumGlobal.loaded,
    message: '',
  );

  @action
  void changeStatus(String message, StatusEnumGlobal status) {
    _stateClass = _stateClass.copyWith(message: message, status: status);
  }

  void setTipoSorteo(String? value) {
    if (value != null) {
      tipoSorteo = value;
    }
  }

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
  Future<void> sortear() async {
    final random = Random();

    // Inicia la animación "Slot Machine"
    _animationTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
      final randomIndex = random.nextInt(_congresistas.length);
      nombreSorteandose = _congresistas[randomIndex].nombreCompleto!;
    });

    // Espera 3 segundos mientras la animación se ejecuta
    await Future.delayed(const Duration(seconds: 5));

    // Detiene la animación y selecciona al ganador final
    _animationTimer?.cancel();
    if (_congresistas.isNotEmpty) {
      final ganadorIndex = random.nextInt(_congresistas.length);
      ganador = _congresistas[ganadorIndex];
      _guardarGanador(ganador!);
    }

    nombreSorteandose = '';
    isLoading = false;
  }

  @action
  Future<List<Usuario>> consultaCongresistaDisponiblesSorteo() async {
    try {
      if (isLoading) return [];

      isLoading = true;
      ganador = null;
      final response = await service.consultaCongresistaDisponiblesSorteo(
        tipoSorteo,
      );
      final data = response.data;
      changeStatus('', StatusEnumGlobal.loaded);
      _congresistas.clear();
      _congresistas.addAll(data);
      sortear();
      return data;
    } on ServiceException catch (e) {
      isLoading = false;
      changeStatus(e.message, StatusEnumGlobal.errorDialog);
      return [];
    }
  }

  void _guardarGanador(Usuario usuario) async {
    try {
      service.guardarGanador(usuario, auspicianteSeleccionado!);
      return;
    } on ServiceException catch (e) {
      changeStatus(e.message, StatusEnumGlobal.errorDialog);
      return;
    }
  }
}
