import 'package:congreso_evento/core/exception/exception_utils.dart';
import 'package:congreso_evento/core/exception/service_exception.dart';
import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:congreso_evento/modules/auth/models/usuario_pageable.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/models/habilitacion_pagos.dart';
import 'package:congreso_evento/modules/home_admin/pages/pagos/models/resumen_cobrador_turno.dart';
import 'package:congreso_evento/modules/home_admin/pages/pagos/pago_page_ctrl.dart';
import 'package:congreso_evento/modules/home_admin/pages/pagos/repositories/habilitacion_pagos_repository.dart';
import 'package:congreso_evento/modules/home_admin/pages/pagos/repositories/pago_repository.dart';
import 'package:congreso_evento/modules/inscripcion/inscripcion_repository.dart';

class PagoService {
  final PagoRepository pagoRepository;
  final InscripcionRepository congresistaRepository;
  final HabilitacionPagosRepository habilitacionPagosRepository;

  PagoService(
    this.congresistaRepository,
    this.pagoRepository,
    this.habilitacionPagosRepository,
  );

  Future<
    ({
      List<Usuario> data,
      int code,
      String message,
      int pages,
      int size,
      bool isLastPage,
      bool isFirstPage,
      int totalRegistros,
    })
  >
  consultaDocumentosPorCondicionPaginado({
    String? buscador,
    required int pageNr,
    required int pageSize,
    required FiltroEstado filtroEstado,
    required DateTime? desde,
    required DateTime? hasta,
  }) async {
    try {
      String estadoStr;
      switch (filtroEstado) {
        case FiltroEstado.pagos:
          estadoStr = 'PAGOS';
          break;
        case FiltroEstado.exonerados:
          estadoStr = 'EXONERADOS';
          break;
        case FiltroEstado.pendientes:
          estadoStr = 'PENDIENTES';
          break;
        default:
          estadoStr = 'TODOS';
      }

      String? nombre;
      String? registroAcademico;
      if (buscador != null && buscador.isNotEmpty) {
        if (RegExp(r'^\d+$').hasMatch(buscador)) {
          registroAcademico = buscador;
        } else {
          nombre = buscador;
        }
      }

      var response = await pagoRepository.consultaConFiltros(
        nombre: nombre,
        registroAcademico: registroAcademico,
        estado: estadoStr,
        desde: desde,
        hasta: hasta,
        pageNr: pageNr,
        pageSize: pageSize,
      );

      if (response == null) {
        throw ServiceException(
          message: 'No se encontró información del congresista',
        );
      }
      if (response.code != 200) {
        throw ServiceException(message: response.message);
      }

      UsuarioPageable? pageable = response.object != null
          ? UsuarioPageable.fromJson(response.object)
          : null;

      var isLastPage = false;
      var isFirstPage = false;
      var totalRegistros = 0;
      var size = pageable?.size ?? 0;
      var pages = pageable?.pages ?? 0;
      isLastPage = pageable?.isLastPage ?? false;
      isFirstPage = pageable?.isFirstPage ?? false;
      totalRegistros = pageable?.total ?? 0;

      return (
        data: pageable?.list ?? [],
        code: response.code,
        message: response.message,
        pages: pages,
        size: size,
        isLastPage: isLastPage,
        isFirstPage: isFirstPage,
        totalRegistros: totalRegistros,
      );
    } on Exception catch (e) {
      throw ServiceException(message: ExceptionUtils.getExceptionMessage(e));
    }
  }

  Future<({Usuario? data, int code, String message})> confirmar({
    required int idCongresista,
    required bool isExonerado,
  }) async {
    try {
      var response = await pagoRepository.confirmar(
        idCongresista: idCongresista,
        isExonerado: isExonerado,
      );
      Usuario? p = response.object != null
          ? Usuario.fromJson(response.object)
          : null;
      return (data: p, code: response.code, message: response.message);
    } on Exception catch (e) {
      throw ServiceException(message: ExceptionUtils.getExceptionMessage(e));
    }
  }

  Future<({Usuario? data, int code, String message})> anularPago({
    required int id,
  }) async {
    try {
      var response = await pagoRepository.anularPago(idCongresista: id);
      Usuario? p = response.object != null
          ? Usuario.fromJson(response.object)
          : null;
      return (data: p, code: response.code, message: response.message);
    } on Exception catch (e) {
      throw ServiceException(message: ExceptionUtils.getExceptionMessage(e));
    }
  }

  Future<({HabilitacionPagos? data, int code, String message})>
  consultarSiEstaHabilitado({required int idUsuario}) async {
    try {
      var response = await habilitacionPagosRepository
          .consultarSiEstaHabilitado(idUsuario: idUsuario);
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

  Future<({List<ResumenCobradorTurno> data, int code, String message})>
  resumenCobradorPorTurno({
    required DateTime? desde,
    required DateTime? hasta,
  }) async {
    try {
      final response = await pagoRepository.resumenCobradorTurno(
        desde: desde,
        hasta: hasta,
      );

      List<ResumenCobradorTurno> p = [];
      if (response?.object != null) {
        p = (response!.object as List)
            .map((e) => ResumenCobradorTurno.fromJson(e))
            .toList();
      }

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
