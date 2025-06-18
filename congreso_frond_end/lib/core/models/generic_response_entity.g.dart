// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generic_response_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GenericResponseEntity _$GenericResponseEntityFromJson(
  Map<String, dynamic> json,
) => GenericResponseEntity(
  message: json['message'] as String? ?? '',
  code: (json['code'] as num?)?.toInt() ?? 0,
  object: json['object'],
);

Map<String, dynamic> _$GenericResponseEntityToJson(
  GenericResponseEntity instance,
) => <String, dynamic>{
  'message': instance.message,
  'code': instance.code,
  'object': instance.object,
};
