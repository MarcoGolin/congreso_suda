import 'dart:core';

import 'package:congreso_evento/core/exception/exception_utils.dart';
import 'package:congreso_evento/core/exception/service_exception.dart';
import 'package:congreso_evento/modules/talleres/models/taller_inscripto.dart';
import 'package:congreso_evento/modules/talleres/repositories/taller_repository.dart';

class TallerInscripcionService {
  final TallerRepository repository;

  TallerInscripcionService(this.repository);

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
}
