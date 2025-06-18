// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jwt_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JwtResponse _$JwtResponseFromJson(Map<String, dynamic> json) => JwtResponse(
  jwttoken: json['jwttoken'] as String?,
  usuario: json['usuario'] == null
      ? null
      : Usuario.fromJson(json['usuario'] as Map<String, dynamic>),
);

Map<String, dynamic> _$JwtResponseToJson(JwtResponse instance) =>
    <String, dynamic>{
      'jwttoken': instance.jwttoken,
      'usuario': instance.usuario,
    };
