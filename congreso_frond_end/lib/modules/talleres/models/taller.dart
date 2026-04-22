import 'package:congreso_evento/core/date_time_converter.dart';
import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../core/searcher/models/i_list_tile.dart';

part 'taller.g.dart';

@DateTimeConverter()
@JsonSerializable()
class Taller implements IListTile {
  final int id;
  final String? titulo;
  final String? descripcion;
  final String? organizador;
  final DateTime? fechaHora;
  final String? sala;
  final double? costo;
  final String? flayer;
  final String? contacto;
  final Usuario? responsable;

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

  @override
  String get title => titulo ?? '';

  @override
  String get subTitle => descripcion ?? '';

  factory Taller.fromJson(Map<String, dynamic> json) => _$TallerFromJson(json);
  Map<String, dynamic> toJson() => _$TallerToJson(this);
}
