import 'package:json_annotation/json_annotation.dart';

class DateTimeConverter implements JsonConverter<DateTime, String> {
  const DateTimeConverter();

  @override
  DateTime fromJson(String dateTime) {
    try {
      return DateTime.parse(dateTime);
    } catch (e) {
      return DateTime.now();
    }
  }

  @override
  String toJson(DateTime dateTime) {
    return dateTime.toIso8601String();
  }
}
