class ResumenCobrador {
  final String? usuarioPagoId;
  final String? usuarioPagoNombre;
  final int cantidad;
  final double montoTotal;

  ResumenCobrador({
    this.usuarioPagoId,
    this.usuarioPagoNombre,
    required this.cantidad,
    required this.montoTotal,
  });

  factory ResumenCobrador.fromJson(Map<String, dynamic> j) => ResumenCobrador(
    usuarioPagoId: j['usuarioPagoId'] as String?,
    usuarioPagoNombre: j['usuarioPagoNombre'] as String?,
    cantidad: j['cantidad'] as int? ?? 0,
    montoTotal: j['montoTotal'] as double? ?? 0,
  );
}
