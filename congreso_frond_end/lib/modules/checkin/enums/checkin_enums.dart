enum CheckinTipo {
  CONGRESO_ASISTENCIA,
  KIT_ENTREGADO,
  COFFEE_BREAK_ENTREGADO,
  // LIGA_ASISTENCIA,
}

extension CheckinTipoX on CheckinTipo {
  String toBackend() => name;
}

extension CoffeeBreakX on CoffeeBreak {
  String toBackend() => name;
}

extension CheckinTipoLabelX on CheckinTipo {
  String get label {
    switch (this) {
      case CheckinTipo.CONGRESO_ASISTENCIA:
        return 'Asistencia Congreso';
      case CheckinTipo.KIT_ENTREGADO:
        return 'Kit entregado';
      case CheckinTipo.COFFEE_BREAK_ENTREGADO:
        return 'Coffee break entregado';
      // case CheckinTipo.LIGA_ASISTENCIA:
      //   return 'Asistencia Liga';
    }
  }
}

enum CoffeeBreak { MATUTINO, VESPERTINO, NOCTURNO }

extension CoffeeBreakLabelX on CoffeeBreak {
  String get label {
    switch (this) {
      case CoffeeBreak.MATUTINO:
        return 'Matutino';
      case CoffeeBreak.VESPERTINO:
        return 'Vespertino';
      case CoffeeBreak.NOCTURNO:
        return 'Nocturno';
    }
  }
}
