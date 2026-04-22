import 'package:congreso_evento/core/exception/service_exception.dart';
import 'package:congreso_evento/core/models/global_state_class.dart';
import 'package:congreso_evento/core/notifiier/default_state_notififier.dart';
import 'package:congreso_evento/modules/home/model/organizadores.dart';
import 'package:congreso_evento/modules/home/service/organizadores_service.dart';
import 'package:congreso_evento/modules/talleres/models/taller.dart';
import 'package:congreso_evento/modules/talleres/services/taller_service.dart';
import 'package:mobx/mobx.dart';

part 'home_page_ctrl.g.dart';

class HomePageCtrl = HomePageCtrlBase with _$HomePageCtrl;

abstract class HomePageCtrlBase with Store {
  final OrganizadoresService organizadoresService;
  final TallerService tallerService;
  HomePageCtrlBase(this.organizadoresService, this.tallerService);

  @readonly
  GlobalStateClass _stateClass = GlobalStateClass(
    status: StatusEnumGlobal.loaded,
    message: '',
  );

  @observable
  ObservableList<Organizadores> organizadores = ObservableList<Organizadores>();

  @observable
  ObservableList<Taller> talleres = ObservableList<Taller>();

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
      final response = await organizadoresService.consultaTodos();

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

  @action
  Future<void> consultarTalleres() async {
    try {
      changeStatus('Consultando talleres...', StatusEnumGlobal.loadingOnly);
      final response = await tallerService.consultaTodos();

      final data = response.data;
      final code = response.code;
      final message = response.message;

      if (code == 200) {
        talleres = ObservableList<Taller>.of(data);
      } else {
        talleres = ObservableList<Taller>();
      }

      changeStatus(message, StatusEnumGlobal.loaded);
    } on ServiceException catch (e) {
      changeStatus(e.message, StatusEnumGlobal.error);
    }
  }

  Taller? obtenerTallerPorId(int id) {
    try {
      return talleres.firstWhere((taller) => taller.id == id);
    } catch (e) {
      return null;
    }
  }
}
