// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'congresista.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Congresista _$CongresistaFromJson(Map<String, dynamic> json) => Congresista(
  id: json['id'] as String?,
  nomeCompleto: json['nomeCompleto'] as String?,
  email: json['email'] as String?,
  senha: json['senha'] as String?,
  telefone: json['telefone'] as String?,
  institucion: json['institucion'] as String?,
  registroAcademico: json['registroAcademico'] as String?,
  semestre: json['semestre'] as String?,
  seccion: json['seccion'] as String?,
  isPago: json['isPago'] as bool? ?? false,
  fechaPago: _$JsonConverterFromJson<String, DateTime>(
    json['fechaPago'],
    const DateTimeConverter().fromJson,
  ),
  montoPago: (json['montoPago'] as num?)?.toDouble(),
  uuid: json['uuid'] as String?,
);

Map<String, dynamic> _$CongresistaToJson(Congresista instance) =>
    <String, dynamic>{
      'id': instance.id,
      'nomeCompleto': instance.nomeCompleto,
      'email': instance.email,
      'senha': instance.senha,
      'telefone': instance.telefone,
      'institucion': instance.institucion,
      'registroAcademico': instance.registroAcademico,
      'semestre': instance.semestre,
      'seccion': instance.seccion,
      'isPago': instance.isPago,
      'fechaPago': _$JsonConverterToJson<String, DateTime>(
        instance.fechaPago,
        const DateTimeConverter().toJson,
      ),
      'montoPago': instance.montoPago,
      'uuid': instance.uuid,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
