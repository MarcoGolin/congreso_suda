import 'package:congreso_evento/core/exception/exception_utils.dart';
import 'package:congreso_evento/core/exception/service_exception.dart';
import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:congreso_evento/modules/auth/models/usuario_pageable.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/enums/tipo_usuario_enum.dart';
import 'package:congreso_evento/modules/home_admin/pages/congresista/repositories/congresista_repository.dart';

class CongresistaService {
  final CongresistaRepository repository;

  CongresistaService(this.repository);

  Future<({Usuario? data, int code, String message})> save(
    Usuario congresista,
  ) async {
    try {
      var response = await repository.save(congresista);
      Usuario? p = response.object != null
          ? Usuario.fromJson(response.object)
          : null;
      return (data: p, code: response.code, message: response.message);
    } on Exception catch (e) {
      throw ServiceException(message: ExceptionUtils.getExceptionMessage(e));
    }
  }

  Future<({Usuario? data, int code, String message})> restablecerContrasenha(
    Usuario congresista,
  ) async {
    try {
      var response = await repository.restablecerContrasenha(congresista);
      Usuario? p = response.object != null
          ? Usuario.fromJson(response.object)
          : null;
      return (data: p, code: response.code, message: response.message);
    } on Exception catch (e) {
      throw ServiceException(message: ExceptionUtils.getExceptionMessage(e));
    }
  }

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
  }) async {
    try {
      String? nombre;
      String? registroAcademico;

      // si buscador es totalmente numero busca por registro academico, osino por nombre
      if (buscador != null && buscador.isNotEmpty) {
        if (RegExp(r'^\d+$').hasMatch(buscador)) {
          registroAcademico = buscador;
        } else {
          nombre = buscador;
        }
      }

      var response = await repository
          .consultaCongresistaPorNombreORegistroAcademico(
            nombre: nombre,
            registroAcademico: registroAcademico,
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

  Future<({List<Usuario> data, int code, String message})>
  consultaCongresistaPorTipo(
    TipoUsuarioEnum tipoUsuario, {
    required bool soloPagados,
  }) async {
    try {
      var response = await repository.consultaCongresistaPorTipo(
        tipoUsuario: tipoUsuario,
        soloPagados: soloPagados,
      );
      if (response == null) {
        throw ServiceException(
          message: 'No se encontró información del congresista',
        );
      }
      List<Usuario> usuarios = response.object != null
          ? (response.object as List).map((e) => Usuario.fromJson(e)).toList()
          : [];
      return (data: usuarios, code: response.code, message: response.message);
    } on Exception catch (e) {
      throw ServiceException(message: ExceptionUtils.getExceptionMessage(e));
    }
  }

  Future<({Usuario? data, int code, String message})> consultaCongresistaPorId(
    int idUsuario,
  ) async {
    try {
      var response = await repository.consultaCongresistaPorId(idUsuario);
      Usuario? usuario = response.object != null
          ? Usuario.fromJson(response.object)
          : null;
      return (data: usuario, code: response.code, message: response.message);
    } on Exception catch (e) {
      throw ServiceException(message: ExceptionUtils.getExceptionMessage(e));
    }
  }
}
