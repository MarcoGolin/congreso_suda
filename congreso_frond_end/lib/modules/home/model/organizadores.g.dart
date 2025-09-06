// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organizadores.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Organizadores _$OrganizadoresFromJson(Map<String, dynamic> json) =>
    Organizadores(
      foto: json['foto'] as String? ?? '',
      nombre: json['nombre'] as String? ?? '',
      cargo: json['cargo'] as String? ?? '',
      destacar: json['destacar'] as bool? ?? false,
    );

Map<String, dynamic> _$OrganizadoresToJson(Organizadores instance) =>
    <String, dynamic>{
      'foto': instance.foto,
      'nombre': instance.nombre,
      'cargo': instance.cargo,
      'destacar': instance.destacar,
    };
