import 'package:congreso_evento/core/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'taller.g.dart';

@DateTimeConverter()
@JsonSerializable()
class Taller {
  final int id;
  final String? titulo;
  final String? descripcion;
  final String? organizador;
  final DateTime? fechaHora;
  final String? sala;
  final double? costo;
  final String? flayer;
  final String? contacto;
  final String? responsable;

  Taller({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.organizador,
    required this.fechaHora,
    required this.sala,
    required this.costo,
    required this.flayer,
    required this.contacto,
    required this.responsable,
  });

  factory Taller.fromJson(Map<String, dynamic> json) => _$TallerFromJson(json);
  Map<String, dynamic> toJson() => _$TallerToJson(this);
}
