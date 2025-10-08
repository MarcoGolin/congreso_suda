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
        return 'Acreditación';
      case CheckinTipo.KIT_ENTREGADO:
        return 'Kit Bienvenida';
      case CheckinTipo.COFFEE_BREAK_ENTREGADO:
        return 'Coffee break';
      // case CheckinTipo.LIGA_ASISTENCIA:
      //   return 'Asistencia Liga';
    }
  }
}

enum CoffeeBreak { MANHANA, TARDE }

extension CoffeeBreakLabelX on CoffeeBreak {
  String get label {
    switch (this) {
      case CoffeeBreak.MANHANA:
        return 'Mañana';
      case CoffeeBreak.TARDE:
        return 'Tarde';
    }
  }
}
