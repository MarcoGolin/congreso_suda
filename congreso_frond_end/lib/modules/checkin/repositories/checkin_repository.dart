import 'package:congreso_evento/core/dio/api_rest_client.dart';
import 'package:congreso_evento/core/exception/repository_exception.dart';
import 'package:congreso_evento/core/models/generic_response_entity.dart';
import 'package:congreso_evento/modules/checkin/enums/checkin_enums.dart';

class CheckinRepository {
  final Api api;
  CheckinRepository(this.api);

  static const String _endpoint = '/checkin/checkin';
  // OJO: si tu Api ya tiene basePath '/api/checkin', cambiá por '/checkin'.

  Future<GenericResponseEntity> doCheckin({
    required String uuid,
    required CheckinTipo tipo,
    int? idTaller,
    CoffeeBreak? refriSlot,
  }) async {
    try {
      final params = <String, String>{
        'uuid': uuid,
        'tipo': tipo.toBackend(),
        if (idTaller != null) 'idTaller': '$idTaller',
        if (refriSlot != null) 'refriSlot': refriSlot.toBackend(),
      };

      // Forzamos @RequestParam via query string (compatible con tu backend).
      final url = '$_endpoint?${Uri(queryParameters: params).query}';

      final response = await api.post<Map<String, dynamic>>(url);
      return GenericResponseEntity.fromJson(response.data);
    } on Exception catch (e) {
      throw RepositoryException.toException(e);
    }
  }
}
