import 'package:congreso_evento/core/date_time_converter.dart';
import 'package:congreso_evento/core/i_simple_list_tile.dart';
import 'package:json_annotation/json_annotation.dart';

part 'congresista.g.dart';

@DateTimeConverter()
@JsonSerializable()
class Congresista implements ISimpleListTile {
  final String? id;
  final String? nomeCompleto;
  final String? email;
  final String? senha;
  final String? telefone;
  final String? institucion;
  final String? registroAcademico;
  final String? semestre;
  final String? seccion;

  //Pago
  final bool isPago;
  final DateTime? fechaPago;
  final double? montoPago;

  final String? uuid;

  Congresista({
    this.id,
    this.nomeCompleto,
    this.email,
    this.senha,
    this.telefone,
    this.institucion,
    this.registroAcademico,
    this.semestre,
    this.seccion,
    this.isPago = false,
    this.fechaPago,
    this.montoPago,
    this.uuid,
  });
  @override
  String get title => nomeCompleto ?? 'No Name';

  factory Congresista.fromJson(Map<String, dynamic> json) =>
      _$CongresistaFromJson(json);
  Map<String, dynamic> toJson() => _$CongresistaToJson(this);
}
