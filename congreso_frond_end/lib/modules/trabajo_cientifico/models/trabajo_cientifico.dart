import 'package:congreso_evento/core/date_time_converter.dart';
import 'package:json_annotation/json_annotation.dart';

import 'coautor.dart';

part 'trabajo_cientifico.g.dart';

@DateTimeConverter()
@JsonSerializable(explicitToJson: true)
class TrabajoCientifico {
  final String autorNombre;
  final String autorEmail;
  final String autorTelefono;
  final List<Coautor> coautores;
  final String titulo;
  final String modalidad;
  final String area;
  final String? resumen;
  final String archivoWordUrl;
  final String? archivoPdfUrl;
  final bool aceptaDeclaracion;

  TrabajoCientifico({
    required this.autorNombre,
    required this.autorEmail,
    required this.autorTelefono,
    this.coautores = const [],
    required this.titulo,
    required this.modalidad,
    required this.area,
    this.resumen,
    required this.archivoWordUrl,
    this.archivoPdfUrl,
    required this.aceptaDeclaracion,
  });

  factory TrabajoCientifico.fromJson(Map<String, dynamic> json) =>
      _$TrabajoCientificoFromJson(json);

  Map<String, dynamic> toJson() => _$TrabajoCientificoToJson(this);
}
