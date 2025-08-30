import 'dart:core';

import 'package:congreso_evento/core/exception/exception_utils.dart';
import 'package:congreso_evento/core/exception/service_exception.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/models/habilitacion_pagos.dart';
import 'package:congreso_evento/modules/home_admin/pages/pagos/repositories/habilitacion_pagos_repository.dart';

class HabilitacionPagosService {
  final HabilitacionPagosRepository repository;

  HabilitacionPagosService(this.repository);

  Future<({HabilitacionPagos? data, int code, String message})> habilitar(
    HabilitacionPagos habilitar,
  ) async {
    try {
      var response = await repository.habilitar(habilitar);
      HabilitacionPagos? p = response.object != null
          ? HabilitacionPagos.fromJson(response.object)
          : null;
      return (data: p, code: response.code, message: response.message);
    } on Exception catch (e) {
      throw ServiceException(message: ExceptionUtils.getExceptionMessage(e));
    }
  }

  Future<({List<HabilitacionPagos> data, int code, String message})>
  consultaHorarios({required int idUsuario}) async {
    try {
      var response = await repository.consultaHorarios(idUsuario: idUsuario);
      List<HabilitacionPagos> list = response?.object != null
          ? (response?.object as List)
                .map((e) => HabilitacionPagos.fromJson(e))
                .toList()
          : [];
      return (
        data: list,
        code: response?.code ?? 0,
        message: response?.message ?? '',
      );
    } on Exception catch (e) {
      throw ServiceException(message: ExceptionUtils.getExceptionMessage(e));
    }
  }

  Future<({HabilitacionPagos? data, int code, String message})>
  consultarSiEstaHabilitado({required int idUsuario}) async {
    try {
      var response = await repository.consultarSiEstaHabilitado(
        idUsuario: idUsuario,
      );
      HabilitacionPagos? p = response?.object != null
          ? HabilitacionPagos.fromJson(response!.object)
          : null;
      return (
        data: p,
        code: response?.code ?? 0,
        message: response?.message ?? '',
      );
    } on Exception catch (e) {
      throw ServiceException(message: ExceptionUtils.getExceptionMessage(e));
    }
  }
}
