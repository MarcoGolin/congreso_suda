class ResumenCobradorTurno {
  final String? usuarioPagoId;
  final String? usuarioPagoNombre;

  // PAGOS
  final int cantDiaPagos;
  final double montoDiaPagos;
  final int cantTardePagos;
  final double montoTardePagos;
  final int cantNochePagos;
  final double montoNochePagos;

  // EXONERADOS (normalmente sin monto)
  final int cantDiaEx;
  final int cantTardeEx;
  final int cantNocheEx;

  // Totales calculados
  int get cantidadTotalPagos => cantDiaPagos + cantTardePagos + cantNochePagos;
  double get montoTotalPagos =>
      montoDiaPagos + montoTardePagos + montoNochePagos;

  int get cantidadTotalEx => cantDiaEx + cantTardeEx + cantNocheEx;

  ResumenCobradorTurno({
    this.usuarioPagoId,
    this.usuarioPagoNombre,
    // pagos
    this.cantDiaPagos = 0,
    this.montoDiaPagos = 0,
    this.cantTardePagos = 0,
    this.montoTardePagos = 0,
    this.cantNochePagos = 0,
    this.montoNochePagos = 0,
    // exonerados
    this.cantDiaEx = 0,
    this.cantTardeEx = 0,
    this.cantNocheEx = 0,
  });

  factory ResumenCobradorTurno.fromJson(Map<String, dynamic> j) {
    double d(v) => v == null ? 0 : (v as num).toDouble();
    int i(v) => v == null ? 0 : (v as num).toInt();

    return ResumenCobradorTurno(
      usuarioPagoId: j['usuarioPagoId'] as String?,
      usuarioPagoNombre: j['usuarioPagoNombre'] as String?,
      // pagos
      cantDiaPagos: i(j['cantDiaPagos']),
      montoDiaPagos: d(j['montoDiaPagos']),
      cantTardePagos: i(j['cantTardePagos']),
      montoTardePagos: d(j['montoTardePagos']),
      cantNochePagos: i(j['cantNochePagos']),
      montoNochePagos: d(j['montoNochePagos']),
      // exonerados
      cantDiaEx: i(j['cantDiaEx']),
      cantTardeEx: i(j['cantTardeEx']),
      cantNocheEx: i(j['cantNocheEx']),
    );
  }
}
