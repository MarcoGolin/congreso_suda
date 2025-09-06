import 'dart:core';

import 'package:congreso_evento/core/exception/exception_utils.dart';
import 'package:congreso_evento/core/exception/service_exception.dart';
import 'package:congreso_evento/modules/home/model/organizadores.dart';
import 'package:congreso_evento/modules/home/repositories/organizadores_repository.dart';

class OrganizadoresService {
  final OrganizadoresRepository repository;

  OrganizadoresService(this.repository);

  Future<({List<Organizadores> data, int code, String message})>
  consultaTodos() async {
    try {
      var response = await repository.consultaTodos();
      List<Organizadores> list = response?.object != null
          ? (response?.object as List)
                .map((e) => Organizadores.fromJson(e))
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
}
