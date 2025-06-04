import 'package:json_annotation/json_annotation.dart';

class DateTimeConverter implements JsonConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime fromJson(String dateTime) {
    // Asegúrate de que la cadena de fecha sea UTC agregando 'Z' si falta
    try {
      //en java se debe usar instant para que guarde como utc
      if (!dateTime.contains('Z')) {
        dateTime = '${dateTime}Z';
        final utcDateTime = DateTime.parse(dateTime);
        final local = utcDateTime.toLocal();
        return local;
      } else {
        final utcDateTime = DateTime.parse(dateTime);
        return utcDateTime;
      }
    } catch (e) {
      return DateTime.now();
    }
  }

  @override
  String toJson(DateTime dateTime) {
    return dateTime.toUtc().toIso8601String();
  }
}
