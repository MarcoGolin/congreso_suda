import 'dart:convert';

import 'package:congreso_evento/core/exception/service_exception.dart';
import 'package:congreso_evento/core/models/global_state_class.dart';
import 'package:congreso_evento/core/notifiier/default_state_notififier.dart';
import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/models/habilitacion_pagos.dart';
import 'package:congreso_evento/modules/home_admin/pages/pagos/models/resumen_cobrador.dart';
import 'package:congreso_evento/modules/home_admin/pages/pagos/services/pago_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobx/mobx.dart';

part 'pago_page_ctrl.g.dart';

enum FiltroEstado { todos, pagos, exonerados, pendientes }

enum FiltroPeriodo { hoy, ayer, mes, rango }

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

  @observable
  bool agruparPorCobrador = false;
  @observable
  List<ResumenCobrador> resumen = [];

  @observable
  FiltroEstado filtroEstado = FiltroEstado.todos;
  @observable
  FiltroPeriodo filtroPeriodo = FiltroPeriodo.hoy;
  @observable
  DateTimeRange? rangoPersonalizado; // cuando el periodo sea "rango"

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
        filtroEstado: filtroEstado,
        desde: _intervalo.desde,
        hasta: _intervalo.hasta,
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

  Future<void> cargarResumen() async {
    try {
      // BLOQUEO si no es admin y no puede cobrar
      if (!isAdmin && !puedeCobrar && agruparPorCobrador) {
        changeStatus(
          'No está habilitado para realizar pagos.',
          StatusEnumGlobal.errorAndAction,
        );
        return;
      }

      // if (_stateClass.status == StatusEnumGlobal.loadingList) {
      //   return; // Evita múltiples llamadas simultáneas
      // }
      changeStatus('', StatusEnumGlobal.loadingList);

      final response = await service.resumenCobrador(
        desde: _intervalo.desde,
        hasta: _intervalo.hasta,
      );
      final data = response.data;
      resumen = [];
      resumen.addAll(data);
      // cerrar loading
      changeStatus('', StatusEnumGlobal.loaded);
    } on ServiceException catch (e) {
      changeStatus(e.message, StatusEnumGlobal.errorDialog);
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

  @action
  Future<Usuario?> anularPago(Usuario u) async {
    try {
      // BLOQUEO si no es admin y no puede cobrar
      if (!isAdmin) {
        changeStatus(
          'La Cancelacion de cobros solo está permitida para administradores.',
          StatusEnumGlobal.errorAndAction,
        );
        return null;
      }
      if (_stateClass.status == StatusEnumGlobal.loading) {
        return null; // Evita múltiples llamadas simultáneas
      }
      changeStatus('', StatusEnumGlobal.loading);
      final response = await service.anularPago(id: u.id!);
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

  DateTime _startOfDay(DateTime d) => DateTime(d.year, d.month, d.day);
  DateTime _endOfDay(DateTime d) =>
      DateTime(d.year, d.month, d.day, 23, 59, 59);

  ({DateTime? desde, DateTime? hasta}) get _intervalo {
    final now = DateTime.now();
    switch (filtroPeriodo) {
      case FiltroPeriodo.hoy:
        return (desde: _startOfDay(now), hasta: _endOfDay(now));
      case FiltroPeriodo.ayer:
        final y = now.subtract(const Duration(days: 1));
        return (desde: _startOfDay(y), hasta: _endOfDay(y));
      case FiltroPeriodo.mes:
        final first = DateTime(now.year, now.month, 1);
        final next = DateTime(now.year, now.month + 1, 1);
        final last = next.subtract(const Duration(seconds: 1));
        return (desde: first, hasta: last);
      case FiltroPeriodo.rango:
        if (rangoPersonalizado == null) return (desde: null, hasta: null);
        return (
          desde: _startOfDay(rangoPersonalizado!.start),
          hasta: _endOfDay(rangoPersonalizado!.end),
        );
    }
  }
}
