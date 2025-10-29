// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usuario.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Usuario _$UsuarioFromJson(Map<String, dynamic> json) => Usuario(
  id: (json['id'] as num?)?.toInt(),
  nombreCompleto: json['nombreCompleto'] as String?,
  email: json['email'] as String?,
  senha: json['senha'] as String?,
  telefono: json['telefono'] as String?,
  institucion: json['institucion'] as String?,
  registroAcademico: json['registroAcademico'] as String?,
  semestre: json['semestre'] as String?,
  seccion: json['seccion'] as String?,
  isPago: json['isPago'] as bool? ?? false,
  fechaPago: _$JsonConverterFromJson<String, DateTime>(
    json['fechaPago'],
    const DateTimeConverter().fromJson,
  ),
  montoPago: (json['montoPago'] as num?)?.toDouble(),
  usuarioPago: json['usuarioPago'] as String?,
  uuid: json['uuid'] as String?,
  pais: json['pais'] as String?,
  fechaRegistro: _$JsonConverterFromJson<String, DateTime>(
    json['fechaRegistro'],
    const DateTimeConverter().fromJson,
  ),
  recordarPassword: json['recordarPassword'] as bool?,
  isAdmin: json['isAdmin'] as bool? ?? false,
  isFinanciero: json['isFinanciero'] as bool? ?? false,
  isStaff: json['isStaff'] as bool? ?? false,
  isCongresista: json['isCongresista'] as bool? ?? false,
  isExonerado: json['isExonerado'] as bool? ?? false,
  isActivado: json['isActivado'] as bool? ?? true,
  isInvitado: json['isInvitado'] as bool? ?? false,
  isDisertante: json['isDisertante'] as bool? ?? false,
  isAudioVisual: json['isAudioVisual'] as bool? ?? false,
  isCheckIn: json['isCheckIn'] as bool? ?? false,
  checkin: (json['checkin'] as List<dynamic>?)
      ?.map((e) => Checkin.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UsuarioToJson(Usuario instance) => <String, dynamic>{
  'id': instance.id,
  'fechaRegistro': _$JsonConverterToJson<String, DateTime>(
    instance.fechaRegistro,
    const DateTimeConverter().toJson,
  ),
  'nombreCompleto': instance.nombreCompleto,
  'email': instance.email,
  'senha': instance.senha,
  'telefono': instance.telefono,
  'institucion': instance.institucion,
  'registroAcademico': instance.registroAcademico,
  'semestre': instance.semestre,
  'seccion': instance.seccion,
  'pais': instance.pais,
  'isPago': instance.isPago,
  'fechaPago': _$JsonConverterToJson<String, DateTime>(
    instance.fechaPago,
    const DateTimeConverter().toJson,
  ),
  'montoPago': instance.montoPago,
  'usuarioPago': instance.usuarioPago,
  'isExonerado': instance.isExonerado,
  'uuid': instance.uuid,
  'recordarPassword': instance.recordarPassword,
  'isAdmin': instance.isAdmin,
  'isFinanciero': instance.isFinanciero,
  'isStaff': instance.isStaff,
  'isCongresista': instance.isCongresista,
  'isInvitado': instance.isInvitado,
  'isDisertante': instance.isDisertante,
  'isAudioVisual': instance.isAudioVisual,
  'isCheckIn': instance.isCheckIn,
  'isActivado': instance.isActivado,
  'checkin': instance.checkin,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
