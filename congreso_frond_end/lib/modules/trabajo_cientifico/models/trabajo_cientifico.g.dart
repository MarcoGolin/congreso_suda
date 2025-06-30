// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trabajo_cientifico.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrabajoCientifico _$TrabajoCientificoFromJson(Map<String, dynamic> json) =>
    TrabajoCientifico(
      autorNombre: json['autorNombre'] as String,
      autorEmail: json['autorEmail'] as String,
      autorTelefono: json['autorTelefono'] as String,
      coautores:
          (json['coautores'] as List<dynamic>?)
              ?.map((e) => Coautor.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      titulo: json['titulo'] as String,
      modalidad: json['modalidad'] as String,
      area: json['area'] as String,
      resumen: json['resumen'] as String?,
      archivoWordUrl: json['archivoWordUrl'] as String,
      archivoPdfUrl: json['archivoPdfUrl'] as String?,
      aceptaDeclaracion: json['aceptaDeclaracion'] as bool,
    );

Map<String, dynamic> _$TrabajoCientificoToJson(TrabajoCientifico instance) =>
    <String, dynamic>{
      'autorNombre': instance.autorNombre,
      'autorEmail': instance.autorEmail,
      'autorTelefono': instance.autorTelefono,
      'coautores': instance.coautores.map((e) => e.toJson()).toList(),
      'titulo': instance.titulo,
      'modalidad': instance.modalidad,
      'area': instance.area,
      'resumen': instance.resumen,
      'archivoWordUrl': instance.archivoWordUrl,
      'archivoPdfUrl': instance.archivoPdfUrl,
      'aceptaDeclaracion': instance.aceptaDeclaracion,
    };
