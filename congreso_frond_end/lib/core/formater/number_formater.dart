import 'dart:developer';

import 'package:intl/intl.dart';

String formatNumber(double? number, int idMoeda) {
  number ??= 0.0;
  String vl = '';
  if (idMoeda == 1 || idMoeda == 4) {
    final numberFormat = NumberFormat("#,###", "es_PY");
    vl = numberFormat.format(number);
  } else {
    final numberFormat = NumberFormat("#,##0.00", "pt_BR");
    vl = numberFormat.format(number);
  }
  return vl;
}

String formatNumberTxtController(double? digits, int idMoeda) {
  if (digits == null) return '';
  // var allowFraction = false;
  late NumberFormat formatter;
  if (idMoeda == 1) {
    formatter = NumberFormat("#,###", "es_PY");
  }
  if (idMoeda == 2) {
    formatter = NumberFormat("#,###.##", "pt_BR");
    // allowFraction = true;
  }

  var result = (formatter).format(digits);
  return result;
}

String newFormatNumber(double? number, int idMoeda) {
  number ??= 0.0;

  var locale = '';
  var symbol = '';
  var precision = 0;
  if (idMoeda == 1) {
    locale = 'es_PY';
    symbol = 'G\$';
    precision = 0;
  } else if (idMoeda == 2) {
    locale = 'br_PT';
    symbol = 'R\$';
    precision = 1;
  } else if (idMoeda == 3) {
    locale = 'es_PY';
    symbol = 'U\$';
    precision = 1;
  } else if (idMoeda == 4) {
    //peso argentino
    locale = 'es_AR';
    symbol = '\$';
    precision = 0;
  }

  late NumberFormat format;
  format = NumberFormat.currency(
    locale: locale,
    decimalDigits: precision,
    symbol: symbol,
  );

  String newString = format.format(number);
  return newString;
}

String newFormatNumberCompact(double? number, int idMoeda) {
  number ??= 0.0;

  var locale = '';
  var symbol = '';
  var precision = 0;
  if (idMoeda == 1) {
    locale = 'es_PY';
    symbol = 'G\$';
    precision = 0;
  } else if (idMoeda == 2) {
    locale = 'br_PT';
    symbol = 'R\$';
    precision = 1;
  } else if (idMoeda == 3) {
    locale = 'es_PY';
    symbol = 'U\$';
    precision = 1;
  } else if (idMoeda == 4) {
    //peso argentino
    locale = 'es_AR';
    symbol = '\$';
    precision = 0;
  }

  late NumberFormat format;

  format = NumberFormat.compactCurrency(
    locale: locale,
    decimalDigits: precision,
    symbol: symbol,
  );
  String newString = format.format(number);
  return newString;
}

int formatMoedaPrecision(int idMoedaBase, int idMoeda) {
  int precision = 0;

  ///GUARANI///
  if (idMoedaBase == 1) {
    if (idMoeda == 1) {
      precision = 0;
    }
    if (idMoeda == 2) {
      precision = 0;
    }
    if (idMoeda == 3) {
      precision = 0;
    }
    if (idMoeda == 4) {
      precision = 0;
    }
  }

  ///REAL///
  if (idMoedaBase == 2) {
    if (idMoeda == 1) {
      precision = 0;
    }
    if (idMoeda == 2) {
      precision = 3;
    }
    if (idMoeda == 3) {
      precision = 3;
    }
    if (idMoeda == 4) {
      precision = 0;
    }
  }

  return precision;
}

String completeWith4Cero(int number) {
  final numberFormat = NumberFormat("0000");
  var formated = '';

  formated = numberFormat.format(number);

  return formated;
}

String completeWith11Cero(int number) {
  final numberFormat = NumberFormat("00000000000");
  var formated = '';

  formated = numberFormat.format(number);

  return formated;
}

String nrFaturaFormat(String nrFilial, String pontoExpedicao, int nrFatura) {
  final nrFaturaFormat = NumberFormat("0000000");
  var formated = '';

  formated = '$nrFilial-$pontoExpedicao-${nrFaturaFormat.format(nrFatura)}';

  return formated;
}

bool isNumeric(String? s) {
  if (s == null) {
    return false;
  }
  return double.tryParse(s) != null;
}

String formatAndRound(double number) {
  String vl = '';
  final numberFormat = NumberFormat("#,###", "es_PY");
  vl = numberFormat.format(number.floor());
  return vl;
}

double roundUp(double number) {
  if (number > 1000) {
    return ((number / 100).ceil()) * 100;
  } else if (number < 1000 && number > 99) {
    return ((number / 100).ceil()) * 100;
  } else if (number < 100 && number > 10) {
    return ((number / 10).ceil()) * 10;
  } else {
    return number;
  }
}

String formatQuantidadeStock(
  double? qtdProduto, {
  required String unidade,
  int tipe = 0,
  showUnidade = true,
}) {
  qtdProduto ??= 0.0;
  final doubleFormat = NumberFormat('#,##0.0', "es_PY");
  final doubleFormatSinDecimal = NumberFormat('#,###', "es_PY");
  if (unidade.compareTo("UN") == 0 || unidade.compareTo("MT/UN") == 0) {
    return "${qtdProduto.toStringAsFixed(0)} ${showUnidade ? "UN" : ''}";
  } else if (unidade.compareTo("MT") == 0) {
    if (qtdProduto.abs() == 0) {
      return "0 ${showUnidade ? 'MT' : ''}";
    }
    if (qtdProduto.abs() < 100) {
      return "${doubleFormatSinDecimal.format(tipe == 0 ? qtdProduto : qtdProduto)} ${showUnidade ? 'CM' : ''}";
    } else {
      return "${doubleFormat.format(tipe == 0 ? qtdProduto / 100 : qtdProduto)} ${showUnidade ? unidade : ''}";
    }
  } else if (unidade.compareTo("KG") == 0) {
    if (qtdProduto.abs() == 0) {
      return "0 ${showUnidade ? 'KG' : ''}";
    }
    if (qtdProduto.abs() < 1000) {
      return "${doubleFormat.format(tipe == 0 ? qtdProduto / 1000 : qtdProduto)} ${showUnidade ? 'GR' : ''}";
    } else {
      return "${doubleFormat.format(tipe == 0 ? qtdProduto / 1000 : qtdProduto)} ${showUnidade ? unidade : ''}";
    }
  } else if (unidade.compareTo("LT") == 0) {
    if (qtdProduto.abs() == 0) {
      return "0 ${showUnidade ? 'LT' : ''}";
    }
    if (qtdProduto.abs() < 1000) {
      return "${doubleFormat.format(tipe == 0 ? qtdProduto / 1000 : qtdProduto)} ${showUnidade ? 'ML' : ''}";
    } else {
      return "${doubleFormat.format(tipe == 0 ? qtdProduto / 1000 : qtdProduto)} ${showUnidade ? unidade : ''}";
    }
  } else {
    return '';
  }
}

String formatQtdStockOnlyUnidade(
  double? qtdProduto, {
  required String unidade,
  int tipe = 0,
}) {
  qtdProduto ??= 0.0;
  if (unidade.compareTo("UN") == 0 || unidade.compareTo("MT/UN") == 0) {
    return "UN";
  } else if (unidade.compareTo("MT") == 0) {
    if (qtdProduto.abs() == 0) {
      return "'MT' : ''}";
    }
    if (qtdProduto.abs() < 100) {
      return "CM";
    } else {
      return "unidade";
    }
  } else if (unidade.compareTo("KG") == 0) {
    if (qtdProduto.abs() == 0) {
      return "KG";
    }
    if (qtdProduto.abs() < 1000) {
      return "GR";
    } else {
      return "KG";
    }
  } else if (unidade.compareTo("LT") == 0) {
    if (qtdProduto.abs() == 0) {
      return "LT";
    }
    if (qtdProduto.abs() < 1000) {
      return "ML";
    } else {
      return "unidade";
    }
  } else {
    return '';
  }
}

int findLimiteTelaVenda({
  required double widthTela,
  required double heightTela,
  required double widthWidget,
  required double heightWidget,
}) {
  int limiteHorizontal = (widthTela / widthWidget).floor();
  int limiteVertical = (heightTela / heightWidget).floor();
  return limiteHorizontal * limiteVertical;
}

String formatUnidadeMedidaSimples(String unidadeMedida, double qtdProduto) {
  if (unidadeMedida.compareTo("UN") == 0 ||
      unidadeMedida.compareTo("MT/UN") == 0) {
    return qtdProduto.toStringAsFixed(0);
  } else if (unidadeMedida.compareTo("MT") == 0) {
    return (qtdProduto / 100).toStringAsFixed(2);
  } else {
    return (qtdProduto / 1000).toStringAsFixed(3);
  }
}

String formatNumberManteniendoDecimales(double number, int idMoeda) {
  log('number: $number');
  // final n = number.toString();
  // final split = n.split('.');
  // final cantDecimales = split[1].length;

  var locale = '';
  var symbol = '';
  var precision = 0;
  if (idMoeda == 1) {
    locale = 'es_PY';
    precision = 0;
  } else {
    locale = 'br_PT';
    precision = 3;
  }

  final format = NumberFormat.currency(
    locale: locale,
    decimalDigits: precision,
    symbol: symbol,
  );

  String newString = format.format(number);
  return newString;
}

bool contieneSoloNumeros(String cadena) {
  final RegExp regex = RegExp(r'^[0-9]+$');
  return regex.hasMatch(cadena);
}
