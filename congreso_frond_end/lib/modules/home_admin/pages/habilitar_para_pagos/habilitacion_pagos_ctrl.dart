import 'package:congreso_evento/core/exception/service_exception.dart';
import 'package:congreso_evento/core/models/global_state_class.dart';
import 'package:congreso_evento/core/notifiier/default_state_notififier.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/models/habilitacion_pagos.dart';
import 'package:congreso_evento/modules/home_admin/pages/pagos/services/habilitacion_pagos_service.dart';
import 'package:mobx/mobx.dart';

part 'habilitacion_pagos_ctrl.g.dart';

class HabilitacionPagosCtrl = HabilitacionPagosCtrlBase
    with _$HabilitacionPagosCtrl;

abstract class HabilitacionPagosCtrlBase with Store {
  final HabilitacionPagosService service;
  HabilitacionPagosCtrlBase(this.service);

  @observable
  ObservableList<HabilitacionPagos> listaHabilitacionPagos =
      ObservableList<HabilitacionPagos>.of([]);

  @readonly
  GlobalStateClass _stateClass = GlobalStateClass(
    status: StatusEnumGlobal.loaded,
    message: '',
  );

  @action
  void changeStatus(String message, StatusEnumGlobal status) {
    _stateClass = _stateClass.copyWith(message: message, status: status);
  }

  bool get isLoading => _stateClass.status == StatusEnumGlobal.loadingList;

  @action
  Future<void> habilitar({required HabilitacionPagos habilitar}) async {
    try {
      changeStatus('Guardando congresista...', StatusEnumGlobal.loading);
      // Simular un proceso de guardado

      final response = await service.habilitar(habilitar);

      final data = response.data;
      final code = response.code;
      final message = response.message;

      if (code != 200) {
        changeStatus(message, StatusEnumGlobal.errorDialog);
        return;
      }
      _actualizaLista(data);
      changeStatus(
        'Congresista guardado exitosamente',
        StatusEnumGlobal.success,
      );
    } on ServiceException catch (e) {
      changeStatus(e.message, StatusEnumGlobal.error);
    }
  }

  @action
  Future<void> consultaHorarios({required int idUsuario}) async {
    try {
      changeStatus('Consultando horarios...', StatusEnumGlobal.loadingList);
      // Simular un proceso de guardado

      final response = await service.consultaHorarios(idUsuario: idUsuario);

      final data = response.data;
      final code = response.code;
      final message = response.message;

      listaHabilitacionPagos = ObservableList<HabilitacionPagos>.of(data);

      if (code != 200) {
        changeStatus(message, StatusEnumGlobal.errorDialog);
        return;
      }
      changeStatus(message, StatusEnumGlobal.success);
    } on ServiceException catch (e) {
      changeStatus(e.message, StatusEnumGlobal.error);
    }
  }

  void _actualizaLista(HabilitacionPagos? data) {
    if (data == null) return;
    final index = listaHabilitacionPagos.indexWhere((c) => c.id == data.id);
    if (index != -1) {
      listaHabilitacionPagos[index] = data;
    } else {
      listaHabilitacionPagos.add(data);
    }
  }
}
