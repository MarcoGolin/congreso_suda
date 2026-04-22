// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Taller _$TallerFromJson(Map<String, dynamic> json) => Taller(
  id: (json['id'] as num).toInt(),
  titulo: json['titulo'] as String?,
  descripcion: json['descripcion'] as String?,
  organizador: json['organizador'] as String?,
  fechaHora: _$JsonConverterFromJson<String, DateTime>(
    json['fechaHora'],
    const DateTimeConverter().fromJson,
  ),
  sala: json['sala'] as String?,
  costo: (json['costo'] as num?)?.toDouble(),
  flayer: json['flayer'] as String?,
  contacto: json['contacto'] as String?,
  responsable: json['responsable'] == null
      ? null
      : Usuario.fromJson(json['responsable'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TallerToJson(Taller instance) => <String, dynamic>{
  'id': instance.id,
  'titulo': instance.titulo,
  'descripcion': instance.descripcion,
  'organizador': instance.organizador,
  'fechaHora': _$JsonConverterToJson<String, DateTime>(
    instance.fechaHora,
    const DateTimeConverter().toJson,
  ),
  'sala': instance.sala,
  'costo': instance.costo,
  'flayer': instance.flayer,
  'contacto': instance.contacto,
  'responsable': instance.responsable,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
