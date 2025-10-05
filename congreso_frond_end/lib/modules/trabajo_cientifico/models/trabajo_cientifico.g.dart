// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trabajo_cientifico.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrabajoCientifico _$TrabajoCientificoFromJson(Map<String, dynamic> json) =>
    TrabajoCientifico(
      id: (json['id'] as num?)?.toInt(),
      fechaRegistro: _$JsonConverterFromJson<String, DateTime>(
        json['fechaRegistro'],
        const DateTimeConverter().fromJson,
      ),
      autorNombre: json['autorNombre'] as String,
      autorEmail: json['autorEmail'] as String,
      autorTelefono: json['autorTelefono'] as String,
      autorFiliacion: json['autorFiliacion'] as String,
      coautores:
          (json['coautores'] as List<dynamic>?)
              ?.map((e) => Coautor.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      titulo: json['titulo'] as String,
      modalidad: json['modalidad'] as String,
      areaTematica: json['areaTematica'] as String,
      areaDeLaMedicina: json['areaDeLaMedicina'] as String,
      resumen: json['resumen'] as String?,
      archivoWordUrl: json['archivoWordUrl'] as String,
      archivoPdfUrl: json['archivoPdfUrl'] as String?,
      aceptaDeclaracion: json['aceptaDeclaracion'] as bool?,
      estado: json['estado'] as String?,
    );

Map<String, dynamic> _$TrabajoCientificoToJson(TrabajoCientifico instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fechaRegistro': _$JsonConverterToJson<String, DateTime>(
        instance.fechaRegistro,
        const DateTimeConverter().toJson,
      ),
      'autorNombre': instance.autorNombre,
      'autorEmail': instance.autorEmail,
      'autorTelefono': instance.autorTelefono,
      'autorFiliacion': instance.autorFiliacion,
      'coautores': instance.coautores.map((e) => e.toJson()).toList(),
      'titulo': instance.titulo,
      'modalidad': instance.modalidad,
      'areaTematica': instance.areaTematica,
      'areaDeLaMedicina': instance.areaDeLaMedicina,
      'resumen': instance.resumen,
      'archivoWordUrl': instance.archivoWordUrl,
      'archivoPdfUrl': instance.archivoPdfUrl,
      'aceptaDeclaracion': instance.aceptaDeclaracion,
      'estado': instance.estado,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
