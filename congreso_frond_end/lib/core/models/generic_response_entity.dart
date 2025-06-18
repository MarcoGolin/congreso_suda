import 'package:json_annotation/json_annotation.dart';

part 'generic_response_entity.g.dart';

@JsonSerializable()
class GenericResponseEntity {
  String message;
  int code;
  dynamic object;

  GenericResponseEntity({this.message = '', this.code = 0, this.object});

  factory GenericResponseEntity.fromJson(Map<String, dynamic> json) =>
      _$GenericResponseEntityFromJson(json);

  Map<String, dynamic> toJson() => _$GenericResponseEntityToJson(this);
}
