import 'package:congreso_evento/core/exception/service_exception.dart';
import 'package:congreso_evento/core/models/global_state_class.dart';
import 'package:congreso_evento/core/notifiier/default_state_notififier.dart';
import 'package:congreso_evento/modules/home/model/organizadores.dart';
import 'package:congreso_evento/modules/home/service/organizadores_service.dart';
import 'package:mobx/mobx.dart';

part 'home_page_ctrl.g.dart';

class HomePageCtrl = HomePageCtrlBase with _$HomePageCtrl;

abstract class HomePageCtrlBase with Store {
  final OrganizadoresService service;
  HomePageCtrlBase(this.service);

  @readonly
  GlobalStateClass _stateClass = GlobalStateClass(
    status: StatusEnumGlobal.loaded,
    message: '',
  );

  @observable
  ObservableList<Organizadores> organizadores = ObservableList<Organizadores>();

  @action
  void changeStatus(String message, StatusEnumGlobal status) {
    _stateClass = _stateClass.copyWith(message: message, status: status);
  }

  bool get isLoading => _stateClass.status == StatusEnumGlobal.loadingOnly;

  @action
  Future<void> consultarOrganizadores() async {
    try {
      changeStatus(
        'Consultando organizadores...',
        StatusEnumGlobal.loadingOnly,
      );
      final response = await service.consultaTodos();

      final data = response.data;
      final code = response.code;
      final message = response.message;

      if (code == 200) {
        organizadores = ObservableList<Organizadores>.of(data);
      } else {
        organizadores = ObservableList<Organizadores>();
      }

      changeStatus(message, StatusEnumGlobal.loaded);
    } on ServiceException catch (e) {
      changeStatus(e.message, StatusEnumGlobal.error);
    }
  }
}
