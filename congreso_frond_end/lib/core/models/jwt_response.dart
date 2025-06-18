import 'package:congreso_evento/modules/auth/models/usuario.dart';
import 'package:json_annotation/json_annotation.dart';

part 'jwt_response.g.dart';

@JsonSerializable()
class JwtResponse {
  String? jwttoken;
  Usuario? usuario;

  JwtResponse({this.jwttoken, this.usuario});

  factory JwtResponse.fromJson(Map<String, dynamic> json) =>
      _$JwtResponseFromJson(json);

  Map<String, dynamic> toJson() => _$JwtResponseToJson(this);
}
