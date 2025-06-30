// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coautor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Coautor _$CoautorFromJson(Map<String, dynamic> json) => Coautor(
  json['filiacion'] as String?,
  nombre: json['nombre'] as String,
  email: json['email'] as String,
);

Map<String, dynamic> _$CoautorToJson(Coautor instance) => <String, dynamic>{
  'nombre': instance.nombre,
  'email': instance.email,
  'filiacion': instance.filiacion,
};
