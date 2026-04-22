import 'dart:core';

import 'package:congreso_evento/core/exception/exception_utils.dart';
import 'package:congreso_evento/core/exception/service_exception.dart';
import 'package:congreso_evento/modules/talleres/models/taller_inscripto.dart';
import 'package:congreso_evento/modules/talleres/models/taller_inscripto_pageable.dart';
import 'package:congreso_evento/modules/talleres/repositories/taller_inscripto_repository.dart';

class TallerInscriptoService {
  final TallerInscriptoRepository repository;

  TallerInscriptoService(this.repository);

  /// Consulta talleres inscriptos por usuario ID usando endpoint real
  /// Corresponde al endpoint: GET /api/tallerInscripto/consultarTalleresPorUsuario
  Future<({List<TallerInscripto> data, int code, String message})>
  findByUsuarioId(String usuarioId) async {
    try {
      // Llamada real al backend usando el repositorio existente
      var response = await repository.consultarTalleresPorUsuario(
        usuarioId: int.parse(usuarioId),
      );

      List<TallerInscripto> list = response?.object != null
          ? (response?.object as List)
                .map((e) => TallerInscripto.fromJson(e))
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

  Future<({TallerInscripto? data, int code, String message})> inscribir({
    required int? idUsuario,
    required int idTaller,
    required bool isJuntaDirectiva,
  }) async {
    try {
      var response = await repository.inscribir(
        idUsuario: idUsuario,
        idTaller: idTaller,
        isJuntaDirectiva: isJuntaDirectiva,
      );
      TallerInscripto? list = response?.object != null
          ? TallerInscripto.fromJson(response!.object)
          : null;
      return (
        data: list,
        code: response?.code ?? 0,
        message: response?.message ?? '',
      );
    } on Exception catch (e) {
      throw ServiceException(message: ExceptionUtils.getExceptionMessage(e));
    }
  }

  Future<
    ({
      List<TallerInscripto> data,
      int code,
      String message,
      int pages,
      int size,
      bool isLastPage,
      bool isFirstPage,
      int totalRegistros,
    })
  >
  consultaParticipantesDelTaller({
    required int idTaller,
    required int pageNr,
    required int pageSize,
  }) async {
    try {
      var response = await repository.consultaParticipantesDelTaller(
        idTaller: idTaller,
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

      TallerInscriptoPageable? pageable = response.object != null
          ? TallerInscriptoPageable.fromJson(response.object)
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

  Future<({int code, String message})> remover({
    required int idInscripto,
  }) async {
    try {
      var response = await repository.remover(idInscripto: idInscripto);
      return (code: response?.code ?? 0, message: response?.message ?? '');
    } on Exception catch (e) {
      throw ServiceException(message: ExceptionUtils.getExceptionMessage(e));
    }
  }
}
