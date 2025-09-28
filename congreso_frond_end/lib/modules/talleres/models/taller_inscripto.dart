import 'package:congreso_evento/core/date_time_converter.dart';
import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:congreso_evento/modules/talleres/models/taller.dart';
import 'package:json_annotation/json_annotation.dart';

part 'taller_inscripto.g.dart';

@DateTimeConverter()
@JsonSerializable()
class TallerInscripto {
  final int id;
  final DateTime fecha;
  final Taller taller;
  final Usuario usuario;

  final DateTime? fechaPago;
  final double? vlPago;
  final String? nrComprobante;
  final String? usuarioPago;
  final bool? isExonerado;

  TallerInscripto({
    this.id = 0,
    required this.fecha,
    required this.taller,
    required this.usuario,
    this.fechaPago,
    this.vlPago,
    this.nrComprobante,
    this.usuarioPago,
    this.isExonerado,
  });

  factory TallerInscripto.fromJson(Map<String, dynamic> json) =>
      _$TallerInscriptoFromJson(json);

  Map<String, dynamic> toJson() => _$TallerInscriptoToJson(this);
}
