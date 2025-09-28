import 'package:congreso_evento/core/exception/service_exception.dart';
import 'package:congreso_evento/core/models/global_state_class.dart';
import 'package:congreso_evento/core/notifiier/default_state_notififier.dart';
import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/enums/tipo_usuario_enum.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/services/congresista_service.dart';
import 'package:mobx/mobx.dart';

part 'congresista_ctrl.g.dart';

class CongresistaCtrl = CongresistaCtrlBase with _$CongresistaCtrl;

abstract class CongresistaCtrlBase with Store {
  final CongresistaService service;
  CongresistaCtrlBase(this.service);

  @readonly
  GlobalStateClass _stateClass = GlobalStateClass(
    status: StatusEnumGlobal.loaded,
    message: '',
  );

  @readonly
  int _pageNr = 1;

  @readonly
  int _pageSize = 10;

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

  @readonly
  bool _isRefreshing = false;

  @observable
  ObservableList<Usuario> congresistas = ObservableList<Usuario>();

  @readonly
  String? _condicion;

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

  Future<void> onRefresh() async {
    _isRefreshing = true;
    await consulta();
    _isRefreshing = false;
  }

  set setCondicion(String? value) {
    _condicion = value;
    primeraConsulta();
  }

  void primeraConsulta() {
    _pageNr = 1;
    _isLastPage = false;
    congresistas.clear();
    consulta();
  }

  void siguienteConsulta() {
    _pageNr++;
    consulta();
  }

  void setPaginaAtual(int p0) {
    _pageNr = p0;
    _isLastPage = false;
    congresistas.clear();
    consulta();
  }

  void setRefreshing(bool value) {
    _isRefreshing = value;
  }

  set setNombre(String? value) {
    _congresista = _congresista?.copyWith(nombreCompleto: value);
  }

  bool get isLoading => _stateClass.status == StatusEnumGlobal.loading;
  bool get isLoadingList => _stateClass.status == StatusEnumGlobal.loadingList;

  @action
  Future<void> guardar() async {
    try {
      changeStatus('Guardando congresista...', StatusEnumGlobal.loading);
      // Simular un proceso de guardado

      final response = await service.save(_congresista!);

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
  Future<void> restablecerContrasenha() async {
    try {
      changeStatus('Restableciendo contraseña...', StatusEnumGlobal.loading);
      // Simular un proceso de restablecimiento

      final response = await service.restablecerContrasenha(_congresista!);

      final data = response.data;
      final code = response.code;
      final message = response.message;

      if (code != 200) {
        changeStatus(message, StatusEnumGlobal.errorDialog);
        return;
      }
      _actualizaLista(data);
      changeStatus(
        'Congresista restablecido exitosamente',
        StatusEnumGlobal.success,
      );
    } on ServiceException catch (e) {
      changeStatus(e.message, StatusEnumGlobal.error);
    }
  }

  @action
  Future<List<Usuario>> consulta() async {
    try {
      if (_stateClass.status == StatusEnumGlobal.loadingList) {
        return congresistas; // Evita múltiples llamadas simultáneas
      }
      if (_isLastPage) {
        return congresistas; // Evita llamadas si ya es la última página
      }
      changeStatus('', StatusEnumGlobal.loadingList);
      final response = await service.consultaDocumentosPorCondicionPaginado(
        buscador: _condicion,
        pageNr: _pageNr,
        pageSize: _pageSize,
      );

      final data = response.data;

      _totalRegistros = response.totalRegistros;
      _isLastPage = response.isLastPage;

      changeStatus('', StatusEnumGlobal.loaded);
      congresistas.addAll(data);
      return data;
    } on ServiceException catch (e) {
      changeStatus(e.message, StatusEnumGlobal.errorDialog);
      return [];
    }
  }

  void _actualizaLista(Usuario? data) {
    if (data == null) return;
    final index = congresistas.indexWhere((c) => c.id == data.id);
    if (index != -1) {
      congresistas[index] = data;
    } else {
      congresistas.add(data);
    }
  }

  @action
  Future<List<Usuario>> consultaCongresistaPorTipo(
    TipoUsuarioEnum tipoUsuario,
  ) async {
    try {
      if (_stateClass.status == StatusEnumGlobal.loading) {
        return []; // Evita múltiples llamadas simultáneas
      }
      changeStatus('', StatusEnumGlobal.loading);
      final response = await service.consultaCongresistaPorTipo(tipoUsuario);
      final data = response.data;
      if (data.isEmpty) {
        changeStatus(
          'No se encontraron registros para ese tipo.',
          StatusEnumGlobal.errorDialog,
        );
        return [];
      }
      changeStatus('', StatusEnumGlobal.loaded);
      return data;
    } on ServiceException catch (e) {
      changeStatus(e.message, StatusEnumGlobal.errorDialog);
      return [];
    }
  }
}
