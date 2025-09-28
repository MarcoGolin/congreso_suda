import 'package:congreso_evento/core/exception/service_exception.dart';
import 'package:congreso_evento/core/models/global_state_class.dart';
import 'package:congreso_evento/core/notifiier/default_state_notififier.dart';
import 'package:congreso_evento/modules/talleres/models/taller.dart';
import 'package:congreso_evento/modules/talleres/models/taller_inscripto.dart';
import 'package:congreso_evento/modules/talleres/service/taller_service.dart';
import 'package:mobx/mobx.dart';

part 'taller_inscripcion_ctrl.g.dart';

class TallerInscripcionCtrl = TallerInscripcionCtrlBase
    with _$TallerInscripcionCtrl;

abstract class TallerInscripcionCtrlBase with Store {
  final TallerService tallerService;
  TallerInscripcionCtrlBase(this.tallerService);

  @readonly
  TallerInscripto? _tallerInscripto;

  @readonly
  Taller? _taller;

  @readonly
  GlobalStateClass _stateClass = GlobalStateClass(
    status: StatusEnumGlobal.loaded,
    message: '',
  );

  @action
  void changeStatus(String message, StatusEnumGlobal status) {
    _stateClass = _stateClass.copyWith(message: message, status: status);
  }

  set setTaller(Taller? taller) => _taller = taller;

  bool get isLoading => _stateClass.status == StatusEnumGlobal.loadingOnly;

  @action
  Future<TallerInscripto?> inscribir({required int idTaller}) async {
    try {
      changeStatus('Inscribiendo...', StatusEnumGlobal.loadingOnly);
      final response = await tallerService.inscribir(idTaller: idTaller);

      final data = response.data;
      final message = response.message;
      _tallerInscripto = data;
      changeStatus(message, StatusEnumGlobal.success);
      return data;
    } on ServiceException catch (e) {
      changeStatus(e.message, StatusEnumGlobal.errorDialog);
      return null;
    }
  }

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
}
