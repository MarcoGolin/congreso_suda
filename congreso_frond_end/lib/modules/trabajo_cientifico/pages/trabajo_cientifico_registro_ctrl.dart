import 'package:congreso_evento/core/exception/service_exception.dart';
import 'package:congreso_evento/core/models/global_state_class.dart';
import 'package:congreso_evento/core/notifiier/default_state_notififier.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/models/trabajo_cientifico.dart';
import 'package:congreso_evento/modules/trabajo_cientifico/trabajo_cientifico_service.dart';
import 'package:mobx/mobx.dart';

part 'trabajo_cientifico_registro_ctrl.g.dart';

class TrabajoCientificoRegistroCtrl = TrabajoCientificoRegistroCtrlBase
    with _$TrabajoCientificoRegistroCtrl;

abstract class TrabajoCientificoRegistroCtrlBase with Store {
  final TrabajoCientificoService service;
  TrabajoCientificoRegistroCtrlBase(this.service);

  @readonly
  GlobalStateClass _stateClass = GlobalStateClass(
    status: StatusEnumGlobal.loaded,
    message: '',
  );

  @action
  void changeStatus(String message, StatusEnumGlobal status) {
    _stateClass = _stateClass.copyWith(message: message, status: status);
  }

  @action
  Future<void> save(TrabajoCientifico trabajo) async {
    try {
      changeStatus('Guardando trabajo...', StatusEnumGlobal.loading);
      final response = await service.save(trabajo);

      // final data = response.data;
      final code = response.code;
      final message = response.message;

      if (code != 200) {
        changeStatus(message, StatusEnumGlobal.errorDialog);
        return;
      }
      changeStatus('Trabajo guardado correctamente', StatusEnumGlobal.success);
    } on ServiceException catch (e) {
      changeStatus(e.message, StatusEnumGlobal.error);
    }
  }
}
