enum TipoUsuarioEnum {
  boAdmin('isAdmin', 'Administrador'),
  boFinanciero('isFinanciero', 'Financiero'),
  boStaff('isStaff', 'Staff'),
  boCongresista('isCongresista', 'Congresista'),
  boInvitado('isInvitado', 'Invitado'),
  boDisertante('isDisertante', 'Disertante');

  final String label;
  final String descripcion;

  const TipoUsuarioEnum(this.label, this.descripcion);

  /// --- (1) Obtener enum desde su label ---
  static TipoUsuarioEnum? fromLabel(String? label) {
    if (label == null) return null;
    try {
      return TipoUsuarioEnum.values.firstWhere((e) => e.label == label);
    } catch (_) {
      return null;
    }
  }

  /// --- (2) Obtener enum desde nombre en texto ---
  static TipoUsuarioEnum? fromName(String? name) {
    if (name == null) return null;
    try {
      return TipoUsuarioEnum.values.firstWhere((e) => e.name == name);
    } catch (_) {
      return null;
    }
  }

  /// --- (3) Convertir enum a JSON ---
  String toJson() => name;

  /// --- (4) Crear enum desde JSON ---
  static TipoUsuarioEnum? fromJson(dynamic json) {
    if (json == null) return null;
    return fromLabel(json.toString());
  }

  /// --- (5) Representación como String ---
  @override
  String toString() => label;
}
