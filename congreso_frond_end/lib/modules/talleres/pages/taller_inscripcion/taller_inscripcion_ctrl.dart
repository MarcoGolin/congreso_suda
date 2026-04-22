import 'package:congreso_evento/core/exception/service_exception.dart';
import 'package:congreso_evento/core/models/global_state_class.dart';
import 'package:congreso_evento/core/notifiier/default_state_notififier.dart';
import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/services/congresista_service.dart';
import 'package:congreso_evento/modules/talleres/models/taller.dart';
import 'package:congreso_evento/modules/talleres/models/taller_inscripto.dart';
import 'package:congreso_evento/modules/talleres/services/taller_inscripto_service.dart';
import 'package:congreso_evento/modules/talleres/services/taller_service.dart';
import 'package:mobx/mobx.dart';

part 'taller_inscripcion_ctrl.g.dart';

class TallerInscripcionCtrl = TallerInscripcionCtrlBase
    with _$TallerInscripcionCtrl;

abstract class TallerInscripcionCtrlBase with Store {
  final TallerService tallerService;
  final CongresistaService congresistaService;
  final TallerInscriptoService tallerInscriptoService;
  TallerInscripcionCtrlBase(
    this.tallerService,
    this.congresistaService,
    this.tallerInscriptoService,
  );

  @readonly
  TallerInscripto? _tallerInscripto;

  @readonly
  Taller? _taller;

  @readonly
  Usuario? _congresista;

  @readonly
  int _pageNr = 1;

  @readonly
  int _pageSize = 100;

  @readonly
  bool _isLastPage = false;

  @readonly
  int _pageTotal = 0;

  @readonly
  int _totalRegistros = 0;

  @readonly
  int _pages = 0;

  @readonly
  int _size = 0;

  @observable
  ObservableList<TallerInscripto> inscriptos =
      ObservableList<TallerInscripto>.of([]);

  @readonly
  GlobalStateClass _stateClass = GlobalStateClass(
    status: StatusEnumGlobal.loaded,
    message: '',
  );

  @action
  void changeStatus(String message, StatusEnumGlobal status) {
    _stateClass = _stateClass.copyWith(message: message, status: status);
  }

  set setTaller(Taller? taller) {
    _taller = taller;
    _pageNr = 1;
    _isLastPage = false;
    consultaParticipantesDelTaller();
  }

  set setCongresista(Usuario? congresista) => _congresista = congresista;

  set setTallerInscripto(TallerInscripto? tallerInscripto) =>
      _tallerInscripto = tallerInscripto;

  set setIsJuntaDirectiva(bool isJuntaDirectiva) {
    _tallerInscripto = _tallerInscripto?.copyWith(
      isJuntaDirectiva: isJuntaDirectiva,
    );
  }

  bool get isLoading => _stateClass.status == StatusEnumGlobal.loadingOnly;

  @action
  Future<TallerInscripto?> verificarInscripto({required int idTaller}) async {
    try {
      changeStatus('Verificando Inscripcion...', StatusEnumGlobal.loadingOnly);
      final response = await tallerService.verificarInscripto(
        idTaller: idTaller,
      );

      final data = response.data;
      final code = response.code;
      final message = response.message;

      if (code != 200) {
        // No está inscripto
      }

      changeStatus(message, StatusEnumGlobal.loaded);
      return data;
    } on ServiceException catch (e) {
      changeStatus(e.message, StatusEnumGlobal.error);
      return null;
    }
  }

  @action
  Future<List<Taller>> consultaTallerByDescripcion({
    required String descripcion,
  }) async {
    try {
      changeStatus('Verificando Inscripcion...', StatusEnumGlobal.loadingOnly);
      final response = await tallerService.consultaTallerByDescripcion(
        descripcion: descripcion,
      );

      final data = response.data;
      final message = response.message;

      changeStatus(message, StatusEnumGlobal.loaded);
      return data;
    } on ServiceException catch (e) {
      changeStatus(e.message, StatusEnumGlobal.error);
      return [];
    }
  }

  @action
  Future<List<Usuario>> consultaCongresistaPorNombre({
    required String buscador,
  }) async {
    try {
      changeStatus('Verificando Inscripcion...', StatusEnumGlobal.loadingOnly);
      final response = await congresistaService
          .consultaDocumentosPorCondicionPaginado(
            buscador: buscador,
            pageNr: 1,
            pageSize: 100,
          );

      final data = response.data;
      final message = response.message;

      changeStatus(message, StatusEnumGlobal.loaded);
      return data;
    } on ServiceException catch (e) {
      changeStatus(e.message, StatusEnumGlobal.error);
      return [];
    }
  }

  @action
  Future<TallerInscripto?> inscribir({required bool isJuntaDirectiva}) async {
    try {
      if (_taller == null || _congresista == null) {
        changeStatus(
          'Taller o congresista no seleccionado',
          StatusEnumGlobal.errorDialog,
        );
        return null;
      }
      changeStatus('Verificando Inscripcion...', StatusEnumGlobal.loadingOnly);
      final response = await tallerInscriptoService.inscribir(
        idUsuario: _congresista!.id!,
        idTaller: _taller!.id,
        isJuntaDirectiva: isJuntaDirectiva,
      );

      final data = response.data;
      final message = response.message;
      final code = response.code;
      if (code != 200) {
        changeStatus(message, StatusEnumGlobal.errorDialog);
        return null;
      }

      changeStatus(message, StatusEnumGlobal.success);

      _addInscriptoToList(data);

      // Limpiar el campo del congresista después de inscribir
      _congresista = null;

      return data;
    } on ServiceException catch (e) {
      changeStatus(e.message, StatusEnumGlobal.errorDialog);
      return null;
    }
  }

  @action
  Future<List<TallerInscripto>> consultaParticipantesDelTaller() async {
    try {
      if (_stateClass.status == StatusEnumGlobal.loadingList) {
        return inscriptos; // Evita múltiples llamadas simultáneas
      }
      if (_isLastPage) {
        return inscriptos; // Evita llamadas si ya es la última página
      }
      changeStatus('', StatusEnumGlobal.loadingList);
      final response = await tallerInscriptoService
          .consultaParticipantesDelTaller(
            idTaller: _taller!.id,
            pageNr: _pageNr,
            pageSize: _pageSize,
          );

      final data = response.data;

      _totalRegistros = response.totalRegistros;
      _isLastPage = response.isLastPage;

      changeStatus('', StatusEnumGlobal.loaded);
      inscriptos.clear();
      inscriptos.addAll(data);
      return data;
    } on ServiceException catch (e) {
      changeStatus(e.message, StatusEnumGlobal.errorDialog);
      return [];
    }
  }

  void _addInscriptoToList(TallerInscripto? data) {
    if (data != null) {
      inscriptos.add(data);
    }
  }

  @action
  Future<Taller?> consultaTallerById({required int idTaller}) async {
    try {
      changeStatus('Verificando Inscripcion...', StatusEnumGlobal.loading);
      final response = await tallerService.consultaTallerById(
        idTaller: idTaller,
      );
      final data = response.data;
      final message = response.message;
      changeStatus(message, StatusEnumGlobal.loaded);
      setTaller = data;
      return data;
    } on ServiceException catch (e) {
      changeStatus(e.message, StatusEnumGlobal.error);
      return null;
    }
  }

  //remover

  @action
  Future<bool> remover({required int idInscripto}) async {
    try {
      changeStatus('Removiendo Inscripto...', StatusEnumGlobal.loadingOnly);
      final response = await tallerInscriptoService.remover(
        idInscripto: idInscripto,
      );

      final message = response.message;
      final code = response.code;
      if (code != 200) {
        changeStatus(message, StatusEnumGlobal.errorDialog);
        return false;
      }

      inscriptos.removeWhere((inscripto) => inscripto.id == idInscripto);

      changeStatus(message, StatusEnumGlobal.success);
      return true;
    } on ServiceException catch (e) {
      changeStatus(e.message, StatusEnumGlobal.errorDialog);
      return false;
    }
  }
}
