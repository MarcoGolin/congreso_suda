import 'package:congreso_evento/core/date_time_converter.dart';
import 'package:congreso_evento/core/i_simple_list_tile.dart';
import 'package:json_annotation/json_annotation.dart';

part 'usuario.g.dart';

@DateTimeConverter()
@JsonSerializable()
class Usuario implements ISimpleListTile {
  int? id;
  DateTime? fechaRegistro;
  String? nombreCompleto;
  String? email;
  String? senha;
  String? telefono;
  String? institucion;
  String? registroAcademico;
  String? semestre;
  String? seccion;
  String? pais;

  //Pago
  bool isPago;
  DateTime? fechaPago;
  double? montoPago;

  String? uuid;

  bool? recordarPassword = false;

  Usuario({
    this.id,
    this.nombreCompleto,
    this.email,
    this.senha,
    this.telefono,
    this.institucion,
    this.registroAcademico,
    this.semestre,
    this.seccion,
    this.isPago = false,
    this.fechaPago,
    this.montoPago,
    this.uuid,
    this.pais,
    this.fechaRegistro,
    this.recordarPassword,
  });
  @override
  String get title => nombreCompleto ?? 'No Name';

  factory Usuario.fromJson(Map<String, dynamic> json) =>
      _$UsuarioFromJson(json);
  Map<String, dynamic> toJson() => _$UsuarioToJson(this);
}
