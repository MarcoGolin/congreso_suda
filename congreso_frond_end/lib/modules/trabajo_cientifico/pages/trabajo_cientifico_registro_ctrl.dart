import 'package:congreso_evento/core/exception/service_exception.dart';
import 'package:congreso_evento/core/models/global_state_class.dart';
import 'package:mobx/mobx.dart';

part 'trabajo_cientifico_registro_ctrl.g.dart';

class TrabajoCientificoRegistroCtrl = TrabajoCientificoRegistroCtrlBase
    with _$TrabajoCientificoRegistroCtrl;

abstract class TrabajoCientificoRegistroCtrlBase with Store {
  TrabajoCientificoRegistroCtrlBase();

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
  Future<void> save() async {
    try {
      changeStatus('Guardando congresista...', StatusEnumGlobal.loading);
      // Simular un proceso de guardado

      // final response = await service.save(
      //   Usuario(
      //     nombreCompleto: nombreCompleto,
      //     email: email,
      //     senha: senha,
      //     telefono: telefone,
      //     institucion: institucion,
      //     registroAcademico: registroAcademico,
      //     semestre: semestre,
      //     seccion: seccion,
      //     pais: pais,
      //   ),
      // );
      // final data = response.data;
      // final code = response.code;
      // final message = response.message;

      // if (code != 200) {
      //   changeStatus(message, StatusEnumGlobal.errorDialog);
      //   return;
      // }

      // debugPrint('Congresista guardado: ${data?.toJson()}');

      changeStatus(
        'Congresista guardado exitosamente',
        StatusEnumGlobal.success,
      );
    } on ServiceException catch (e) {
      changeStatus(e.message, StatusEnumGlobal.error);
    }
  }
}
