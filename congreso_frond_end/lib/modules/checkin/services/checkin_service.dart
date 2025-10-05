import 'package:congreso_evento/core/exception/exception_utils.dart';
import 'package:congreso_evento/core/exception/service_exception.dart';

import '../enums/checkin_enums.dart';
import '../models/checkin.dart';
import '../repositories/checkin_repository.dart';

class CheckinService {
  CheckinService(this._repository);

  final CheckinRepository _repository;

  String? _lastMessage;
  String? get lastMessage => _lastMessage;

  Future<Checkin> doCheckin({
    required String uuid,
    required CheckinTipo tipo,
    int? idTaller,
    CoffeeBreak? refriSlot,
  }) async {
    try {
      final entity = await _repository.doCheckin(
        uuid: uuid,
        tipo: tipo,
        idTaller: idTaller,
        refriSlot: refriSlot,
      );

      _lastMessage = entity.message;

      final obj = entity.object; // Tu GenericResponseEntity usa 'object'
      if (obj is Map<String, dynamic>) {
        return Checkin.fromJson(obj);
      }

      throw ServiceException(
        message: _lastMessage?.isNotEmpty == true
            ? _lastMessage!
            : 'No se recibió información del check-in.',
      );
    } on ServiceException {
      rethrow;
    } on Exception catch (e) {
      throw ServiceException(message: ExceptionUtils.getExceptionMessage(e));
    }
  }
}
