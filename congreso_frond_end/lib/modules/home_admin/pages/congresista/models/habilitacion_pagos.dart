import 'package:congreso_evento/core/date_time_converter.dart';
import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:json_annotation/json_annotation.dart';

part 'habilitacion_pagos.g.dart';

@DateTimeConverter()
@JsonSerializable()
class HabilitacionPagos {
  final int? id;
  final DateTime? fechaRegistro;
  final Usuario usuario;
  final DateTime inicio;
  final DateTime fin;
  final String? observacion;
  final Usuario? usuarioRegistro;

  HabilitacionPagos({
    this.id,
    required this.usuario,
    this.fechaRegistro,
    required this.inicio,
    required this.fin,
    this.observacion,
    this.usuarioRegistro,
  });

  factory HabilitacionPagos.fromJson(Map<String, dynamic> json) =>
      _$HabilitacionPagosFromJson(json);

  Map<String, dynamic> toJson() => _$HabilitacionPagosToJson(this);
}
