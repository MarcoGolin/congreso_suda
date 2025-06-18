// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Usuario _$UsuarioFromJson(Map<String, dynamic> json) => Usuario(
  id: (json['id'] as num?)?.toInt(),
  nombreCompleto: json['nombreCompleto'] as String?,
  email: json['email'] as String?,
  senha: json['senha'] as String?,
  telefono: json['telefono'] as String?,
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
  pais: json['pais'] as String?,
  fechaRegistro: _$JsonConverterFromJson<String, DateTime>(
    json['fechaRegistro'],
    const DateTimeConverter().fromJson,
  ),
  recordarPassword: json['recordarPassword'] as bool?,
);

Map<String, dynamic> _$UsuarioToJson(Usuario instance) => <String, dynamic>{
  'id': instance.id,
  'fechaRegistro': _$JsonConverterToJson<String, DateTime>(
    instance.fechaRegistro,
    const DateTimeConverter().toJson,
  ),
  'nombreCompleto': instance.nombreCompleto,
  'email': instance.email,
  'senha': instance.senha,
  'telefono': instance.telefono,
  'institucion': instance.institucion,
  'registroAcademico': instance.registroAcademico,
  'semestre': instance.semestre,
  'seccion': instance.seccion,
  'pais': instance.pais,
  'isPago': instance.isPago,
  'fechaPago': _$JsonConverterToJson<String, DateTime>(
    instance.fechaPago,
    const DateTimeConverter().toJson,
  ),
  'montoPago': instance.montoPago,
  'uuid': instance.uuid,
  'recordarPassword': instance.recordarPassword,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
