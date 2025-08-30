import 'dart:convert';

import 'package:congreso_evento/core/exception/service_exception.dart';
import 'package:congreso_evento/core/models/global_state_class.dart';
import 'package:congreso_evento/core/notifiier/default_state_notififier.dart';
import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/models/habilitacion_pagos.dart';
import 'package:congreso_evento/modules/home_admin/pages/pagos/services/pago_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobx/mobx.dart';

part 'pago_page_ctrl.g.dart';

class PagoPageCtrl = PagoPageCtrlBase with _$PagoPageCtrl;

abstract class PagoPageCtrlBase with Store {
  final PagoService service;
  PagoPageCtrlBase(this.service);

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
  Usuario? _usuario;

  @readonly
  HabilitacionPagos? _habilitacionPagos;

  bool get isAdmin => _usuario?.isAdmin == true;

  Future<void> init() async {
    await _loadUser();
    if (!isAdmin) {
      await consultarSiEstaHabilitado();
    }
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
    init();
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

  bool get isLoading => _stateClass.status == StatusEnumGlobal.loadingList;

  @action
  Future<List<Usuario>> consulta() async {
    try {
      // BLOQUEO si no es admin y no puede cobrar
      if (!isAdmin && !puedeCobrar) {
        changeStatus(
          'No está habilitado para realizar pagos.',
          StatusEnumGlobal.errorAndAction,
        );
        return [];
      }

      if (_stateClass.status == StatusEnumGlobal.loadingList) {
        return congresistas; // Evita múltiples llamadas simultáneas
      }
      if (_isLastPage) {
        return congresistas; // Evita llamadas si ya es la última página
      }
      changeStatus('', StatusEnumGlobal.loadingList);

      if (!isAdmin) {
        if (_condicion == null || _condicion!.isEmpty) {
          changeStatus('', StatusEnumGlobal.loaded);
          return [];
        }
      }

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

  Future<void> _loadUser() async {
    final storage = const FlutterSecureStorage();
    try {
      final raw = await storage.read(key: 'usuario_json');
      if (raw != null) {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        _usuario = Usuario.fromJson(map);
      }
    } on ServiceException catch (e) {
      changeStatus(e.message, StatusEnumGlobal.errorDialog);
      return;
    }
  }

  @action
  Future<Usuario?> confirmar(
    int idCongresista, {
    bool? isExonerado = false,
  }) async {
    try {
      // BLOQUEO si no es admin y no puede cobrar
      if (!isAdmin && !puedeCobrar) {
        changeStatus(
          'La habilitación de cobros expiró.',
          StatusEnumGlobal.errorAndAction,
        );
        return null;
      }
      if (_stateClass.status == StatusEnumGlobal.loading) {
        return null; // Evita múltiples llamadas simultáneas
      }
      changeStatus('', StatusEnumGlobal.loading);
      final response = await service.confirmar(
        idCongresista: idCongresista,
        isExonerado: isExonerado!,
      );
      final data = response.data;
      _actualizaLista(data);
      changeStatus('', StatusEnumGlobal.success);
      return data;
    } on ServiceException catch (e) {
      changeStatus(e.message, StatusEnumGlobal.errorDialog);
      return null;
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
  Future<HabilitacionPagos?> consultarSiEstaHabilitado() async {
    try {
      if (_stateClass.status == StatusEnumGlobal.loading) {
        return null; // Evita múltiples llamadas simultáneas
      }
      changeStatus('', StatusEnumGlobal.loading);
      final response = await service.consultarSiEstaHabilitado(
        idUsuario: _usuario?.id ?? 0,
      );

      final data = response.data;

      if (data == null) {
        changeStatus(
          'No está habilitado para realizar pagos!',
          StatusEnumGlobal.errorAndAction,
        );
        return null;
      }

      _habilitacionPagos = data;

      changeStatus('', StatusEnumGlobal.loaded);
      return data;
    } on ServiceException catch (e) {
      changeStatus(e.message, StatusEnumGlobal.errorDialog);
      return null;
    }
  }

  bool get puedeCobrar {
    final h = _habilitacionPagos;
    if (h == null) return false;
    final now = DateTime.now();
    return !now.isBefore(h.inicio) && !now.isAfter(h.fin);
  }

  Duration? get restanteCobro {
    final h = _habilitacionPagos;
    if (h == null) return null;
    final now = DateTime.now();
    if (now.isAfter(h.fin)) return Duration.zero;
    if (now.isBefore(h.inicio)) return h.inicio.difference(now);
    return h.fin.difference(now);
  }

  @action
  void verificarVigenciaYCancelarSiExpira() {
    final h = _habilitacionPagos;
    if (h == null) return;
    if (!puedeCobrar) {
      // Limpia si querés forzar re-consulta futura
      // _habilitacionPagos = null;
      changeStatus(
        'La habilitación de cobros expiró.',
        StatusEnumGlobal.errorAndAction,
      );
    }
  }
}
