// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taller_inscripto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TallerInscripto _$TallerInscriptoFromJson(Map<String, dynamic> json) =>
    TallerInscripto(
      id: (json['id'] as num?)?.toInt() ?? 0,
      fecha: const DateTimeConverter().fromJson(json['fecha'] as String),
      taller: Taller.fromJson(json['taller'] as Map<String, dynamic>),
      usuario: Usuario.fromJson(json['usuario'] as Map<String, dynamic>),
      fechaPago: _$JsonConverterFromJson<String, DateTime>(
        json['fechaPago'],
        const DateTimeConverter().fromJson,
      ),
      vlPago: (json['vlPago'] as num?)?.toDouble(),
      nrComprobante: json['nrComprobante'] as String?,
      usuarioPago: json['usuarioPago'] as String?,
      isExonerado: json['isExonerado'] as bool?,
    );

Map<String, dynamic> _$TallerInscriptoToJson(TallerInscripto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fecha': const DateTimeConverter().toJson(instance.fecha),
      'taller': instance.taller,
      'usuario': instance.usuario,
      'fechaPago': _$JsonConverterToJson<String, DateTime>(
        instance.fechaPago,
        const DateTimeConverter().toJson,
      ),
      'vlPago': instance.vlPago,
      'nrComprobante': instance.nrComprobante,
      'usuarioPago': instance.usuarioPago,
      'isExonerado': instance.isExonerado,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
