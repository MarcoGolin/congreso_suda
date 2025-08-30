// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habilitacion_pagos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HabilitacionPagos _$HabilitacionPagosFromJson(Map<String, dynamic> json) =>
    HabilitacionPagos(
      id: (json['id'] as num?)?.toInt(),
      usuario: Usuario.fromJson(json['usuario'] as Map<String, dynamic>),
      fechaRegistro: _$JsonConverterFromJson<String, DateTime>(
        json['fechaRegistro'],
        const DateTimeConverter().fromJson,
      ),
      inicio: const DateTimeConverter().fromJson(json['inicio'] as String),
      fin: const DateTimeConverter().fromJson(json['fin'] as String),
      observacion: json['observacion'] as String?,
      usuarioRegistro: json['usuarioRegistro'] == null
          ? null
          : Usuario.fromJson(json['usuarioRegistro'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HabilitacionPagosToJson(HabilitacionPagos instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fechaRegistro': _$JsonConverterToJson<String, DateTime>(
        instance.fechaRegistro,
        const DateTimeConverter().toJson,
      ),
      'usuario': instance.usuario,
      'inicio': const DateTimeConverter().toJson(instance.inicio),
      'fin': const DateTimeConverter().toJson(instance.fin),
      'observacion': instance.observacion,
      'usuarioRegistro': instance.usuarioRegistro,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
