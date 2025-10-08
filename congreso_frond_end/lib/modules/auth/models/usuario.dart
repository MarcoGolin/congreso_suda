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
  String? usuarioPago;
  bool? isExonerado;

  String? uuid;

  bool? recordarPassword = false;

  //ROLES
  bool? isAdmin = false;
  bool? isFinanciero = false;
  bool? isStaff = false;
  bool? isCongresista = false;
  bool? isInvitado = false;
  bool? isDisertante = false;
  bool? isAudioVisual = false;

  bool? isActivado = true;

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
    this.usuarioPago,
    this.uuid,
    this.pais,
    this.fechaRegistro,
    this.recordarPassword,
    this.isAdmin = false,
    this.isFinanciero = false,
    this.isStaff = false,
    this.isCongresista = false,
    this.isExonerado = false,
    this.isActivado = true,
    this.isInvitado = false,
    this.isDisertante = false,
    this.isAudioVisual = false,
  });
  @override
  String get title => nombreCompleto ?? 'No Name';

  factory Usuario.fromJson(Map<String, dynamic> json) =>
      _$UsuarioFromJson(json);
  Map<String, dynamic> toJson() => _$UsuarioToJson(this);

  String getEstado() {
    if (isExonerado == true) {
      return 'Exonerado';
    }
    if (isPago == true) {
      return 'Pagado';
    }
    return 'Pendiente';
  }

  String getTipo() {
    if (isStaff == true) {
      return 'STAFF';
    } else if (isInvitado == true) {
      return 'INVITADO';
    } else if (isDisertante == true) {
      return 'DISERTANTE';
    }
    return 'PARTICIPANTE';
  }

  Usuario copyWith({
    int? id,
    DateTime? fechaRegistro,
    String? nombreCompleto,
    String? email,
    String? senha,
    String? telefono,
    String? institucion,
    String? registroAcademico,
    String? semestre,
    String? seccion,
    String? pais,
    bool? isPago,
    DateTime? fechaPago,
    double? montoPago,
    String? usuarioPago,
    bool? isExonerado,
    String? uuid,
    bool? recordarPassword,
    bool? isAdmin,
    bool? isFinanciero,
    bool? isStaff,
    bool? isCongresista,
    bool? isInvitado,
    bool? isDisertante,
    bool? isActivado,
    bool? isAudioVisual,
  }) {
    return Usuario(
      id: id ?? this.id,
      fechaRegistro: fechaRegistro ?? this.fechaRegistro,
      nombreCompleto: nombreCompleto ?? this.nombreCompleto,
      email: email ?? this.email,
      senha: senha ?? this.senha,
      telefono: telefono ?? this.telefono,
      institucion: institucion ?? this.institucion,
      registroAcademico: registroAcademico ?? this.registroAcademico,
      semestre: semestre ?? this.semestre,
      seccion: seccion ?? this.seccion,
      pais: pais ?? this.pais,
      isPago: isPago ?? this.isPago,
      fechaPago: fechaPago ?? this.fechaPago,
      montoPago: montoPago ?? this.montoPago,
      usuarioPago: usuarioPago ?? this.usuarioPago,
      isExonerado: isExonerado ?? this.isExonerado,
      uuid: uuid ?? this.uuid,
      recordarPassword: recordarPassword ?? this.recordarPassword,
      isAdmin: isAdmin ?? this.isAdmin,
      isFinanciero: isFinanciero ?? this.isFinanciero,
      isStaff: isStaff ?? this.isStaff,
      isCongresista: isCongresista ?? this.isCongresista,
      isInvitado: isInvitado ?? this.isInvitado,
      isDisertante: isDisertante ?? this.isDisertante,
      isActivado: isActivado ?? this.isActivado,
      isAudioVisual: isAudioVisual ?? this.isAudioVisual,
    );
  }
}
