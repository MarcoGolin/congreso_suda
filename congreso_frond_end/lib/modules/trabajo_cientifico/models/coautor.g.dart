// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coautor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Coautor _$CoautorFromJson(Map<String, dynamic> json) => Coautor(
  id: (json['id'] as num?)?.toInt(),
  nombre: json['nombre'] as String,
  email: json['email'] as String,
  filiacion: json['filiacion'] as String?,
  filiacionOtro: json['filiacionOtro'] as String?,
);

Map<String, dynamic> _$CoautorToJson(Coautor instance) => <String, dynamic>{
  'id': instance.id,
  'nombre': instance.nombre,
  'email': instance.email,
  'filiacion': instance.filiacion,
  'filiacionOtro': instance.filiacionOtro,
};
