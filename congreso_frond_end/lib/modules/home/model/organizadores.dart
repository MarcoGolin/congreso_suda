import 'package:json_annotation/json_annotation.dart';

part 'organizadores.g.dart';

@JsonSerializable()
class Organizadores {
  final String foto;
  final String nombre;
  final String cargo;
  final bool destacar;

  Organizadores({
    this.foto = '',
    this.nombre = '',
    this.cargo = '',
    this.destacar = false,
  });

  factory Organizadores.fromJson(Map<String, dynamic> json) =>
      _$OrganizadoresFromJson(json);

  Map<String, dynamic> toJson() => _$OrganizadoresToJson(this);
}
