import 'package:congreso_evento/core/exception/service_exception.dart';
import 'package:congreso_evento/core/models/global_state_class.dart';
import 'package:congreso_evento/core/notifiier/default_state_notififier.dart';
import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/services/congresista_service.dart';
import 'package:mobx/mobx.dart';

part 'home_congresista_ctrl.g.dart';

class HomeCongresistaCtrl = HomeCongresistaCtrlBase with _$HomeCongresistaCtrl;

abstract class HomeCongresistaCtrlBase with Store {
  final CongresistaService service;
  HomeCongresistaCtrlBase(this.service);

  @readonly
  GlobalStateClass _stateClass = GlobalStateClass(
    status: StatusEnumGlobal.loaded,
    message: '',
  );

  @readonly
  Usuario? _congresista;

  set setCongresista(Usuario? value) {
    _congresista = value;
  }

  set setEmail(String? value) {
    _congresista = _congresista?.copyWith(email: value);
  }

  set setTelefono(String? value) {
    _congresista = _congresista?.copyWith(telefono: value);
  }

  set setInstitucion(String? value) {
    _congresista = _congresista?.copyWith(institucion: value);
  }

  set setSemestre(String? value) {
    _congresista = _congresista?.copyWith(semestre: value);
  }

  set setSeccion(String? value) {
    _congresista = _congresista?.copyWith(seccion: value);
  }

  set setIsAdmin(bool? value) {
    _congresista = _congresista?.copyWith(isAdmin: value);
  }

  set setIsFinanciero(bool? value) {
    _congresista = _congresista?.copyWith(isFinanciero: value);
  }

  set setIsCongresista(bool? value) {
    _congresista = _congresista?.copyWith(isCongresista: value);
  }

  set setIsStaff(bool? value) {
    _congresista = _congresista?.copyWith(isStaff: value);
  }

  set setIsInvitado(bool? value) {
    _congresista = _congresista?.copyWith(isInvitado: value);
  }

  set setIsDisertante(bool? value) {
    _congresista = _congresista?.copyWith(isDisertante: value);
  }

  @action
  void changeStatus(String message, StatusEnumGlobal status) {
    _stateClass = _stateClass.copyWith(message: message, status: status);
  }

  set setNombre(String? value) {
    _congresista = _congresista?.copyWith(nombreCompleto: value);
  }

  bool get isLoading => _stateClass.status == StatusEnumGlobal.loading;
  bool get isLoadingList => _stateClass.status == StatusEnumGlobal.loadingList;

  @action
  Future<Usuario?> consultaCongresistaPorId(int idUsuario) async {
    try {
      changeStatus('Guardando congresista...', StatusEnumGlobal.loading);
      // Simular un proceso de guardado

      final response = await service.consultaCongresistaPorId(idUsuario);

      final data = response.data;
      final code = response.code;
      final message = response.message;

      if (code != 200) {
        changeStatus(message, StatusEnumGlobal.errorDialog);
        return null;
      }
      changeStatus(
        'Congresista guardado exitosamente',
        StatusEnumGlobal.success,
      );
      return data;
    } on ServiceException catch (e) {
      changeStatus(e.message, StatusEnumGlobal.error);
      return null;
    }
  }
}
