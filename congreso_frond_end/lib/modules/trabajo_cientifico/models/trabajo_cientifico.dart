import 'package:congreso_evento/core/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

import 'coautor.dart';

part 'trabajo_cientifico.g.dart';

@DateTimeConverter()
@JsonSerializable(explicitToJson: true)
class TrabajoCientifico {
  final int? id;
  final DateTime? fechaRegistro;
  final String autorNombre;
  final String autorEmail;
  final String autorTelefono;
  final String autorFiliacion;
  final List<Coautor> coautores;
  final String titulo;
  final String modalidad;
  final String areaTematica;
  final String areaDeLaMedicina;
  final String? resumen;
  final String archivoWordUrl;
  final String? archivoPdfUrl;
  final bool? aceptaDeclaracion;

  TrabajoCientifico({
    this.id,
    this.fechaRegistro,
    required this.autorNombre,
    required this.autorEmail,
    required this.autorTelefono,
    required this.autorFiliacion,
    this.coautores = const [],
    required this.titulo,
    required this.modalidad,
    required this.areaTematica,
    required this.areaDeLaMedicina,
    this.resumen,
    required this.archivoWordUrl,
    this.archivoPdfUrl,
    this.aceptaDeclaracion,
  });

  factory TrabajoCientifico.fromJson(Map<String, dynamic> json) =>
      _$TrabajoCientificoFromJson(json);

  Map<String, dynamic> toJson() => _$TrabajoCientificoToJson(this);
}
