import 'dart:core';

import 'package:congreso_evento/core/exception/exception_utils.dart';
import 'package:congreso_evento/core/exception/service_exception.dart';
import 'package:congreso_evento/modules/talleres/models/taller.dart';
import 'package:congreso_evento/modules/talleres/models/taller_inscripto.dart';
import 'package:congreso_evento/modules/talleres/repositories/taller_repository.dart';

class TallerService {
  final TallerRepository repository;

  TallerService(this.repository);

  Future<({List<Taller> data, int code, String message})>
  consultaTodos() async {
    try {
      var response = await repository.consultaTodos();
      List<Taller> list = response?.object != null
          ? (response?.object as List).map((e) => Taller.fromJson(e)).toList()
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

  Future<({List<Taller> data, int code, String message})>
  consultaTallerByDescripcion({required String descripcion}) async {
    try {
      var response = await repository.consultaTallerByDescripcion(descripcion);
      List<Taller> list = response?.object != null
          ? (response?.object as List).map((e) => Taller.fromJson(e)).toList()
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
    required int idTaller,
  }) async {
    try {
      var response = await repository.inscribir(idTaller: idTaller);
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

  Future<({TallerInscripto? data, int code, String message})>
  verificarInscripto({required int idTaller}) async {
    try {
      var response = await repository.verificarInscripto(idTaller: idTaller);
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

  Future<({String message, int code})> asignarResponsable({
    required int idTaller,
    required int? idUsuario,
  }) async {
    try {
      var response = await repository.asignarResponsable(
        idTaller: idTaller,
        idUsuario: idUsuario,
      );
      return (message: response?.message ?? '', code: response?.code ?? 0);
    } on Exception catch (e) {
      throw ServiceException(message: ExceptionUtils.getExceptionMessage(e));
    }
  }

  Future<({Taller? data, int code, String message})> consultaTallerById({
    required int idTaller,
  }) async {
    try {
      var response = await repository.consultaTallerById(idTaller);
      Taller? taller = response?.object != null
          ? Taller.fromJson(response!.object)
          : null;
      return (
        data: taller,
        code: response?.code ?? 0,
        message: response?.message ?? '',
      );
    } on Exception catch (e) {
      throw ServiceException(message: ExceptionUtils.getExceptionMessage(e));
    }
  }
}
