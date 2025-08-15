import 'package:json_annotation/json_annotation.dart';

part 'coautor.g.dart';

@JsonSerializable()
class Coautor {
  final int? id;
  final String nombre;
  final String email;
  final String? filiacion;
  final String? filiacionOtro;

  Coautor({
    this.id,
    required this.nombre,
    required this.email,
    this.filiacion,
    this.filiacionOtro,
  });

  factory Coautor.fromJson(Map<String, dynamic> json) =>
      _$CoautorFromJson(json);

  Map<String, dynamic> toJson() => _$CoautorToJson(this);
}
