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

part 'taller_asignar_responsable_ctrl.g.dart';

class TallerAsignarResponsableCtrl = TallerAsignarResponsableCtrlBase
    with _$TallerAsignarResponsableCtrl;

abstract class TallerAsignarResponsableCtrlBase with Store {
  final TallerService tallerService;
  final CongresistaService congresistaService;
  final TallerInscriptoService tallerInscriptoService;
  TallerAsignarResponsableCtrlBase(
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
    _congresista = _taller?.responsable;
  }

  set setCongresista(Usuario? congresista) {
    _congresista = congresista;
    if (_taller != null) {
      asignarResponsable();
    }
  }

  set setTallerInscripto(TallerInscripto? tallerInscripto) =>
      _tallerInscripto = tallerInscripto;

  bool get isLoading => _stateClass.status == StatusEnumGlobal.loadingOnly;

  @action
  Future<List<Taller>> consultaTallerByDescripcion({
    required String descripcion,
  }) async {
    try {
      final response = await tallerService.consultaTallerByDescripcion(
        descripcion: descripcion,
      );

      final data = response.data;

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
      final response = await congresistaService
          .consultaDocumentosPorCondicionPaginado(
            buscador: buscador,
            pageNr: 1,
            pageSize: 100,
          );

      final data = response.data;

      return data;
    } on ServiceException catch (e) {
      changeStatus(e.message, StatusEnumGlobal.error);
      return [];
    }
  }

  @action
  Future<void> asignarResponsable() async {
    try {
      int? idCongresista;
      if (_congresista != null) {
        idCongresista = _congresista!.id;
      }

      changeStatus('Verificando Inscripcion...', StatusEnumGlobal.loadingOnly);
      final response = await tallerService.asignarResponsable(
        idTaller: _taller!.id,
        idUsuario: idCongresista,
      );

      final message = response.message;
      final code = response.code;
      if (code != 200) {
        changeStatus(message, StatusEnumGlobal.errorDialog);
        return;
      }

      return;
    } on ServiceException catch (e) {
      changeStatus(e.message, StatusEnumGlobal.errorDialog);
      return;
    } finally {
      changeStatus('', StatusEnumGlobal.success);
    }
  }
}
