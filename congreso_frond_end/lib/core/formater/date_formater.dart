import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const String constLocale = 'es_PY';

String formatDate(String? date) {
  if (date == null || date.isEmpty) {
    return '';
  }
  // var dateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date, true);
  var dtFormatedd = '';
  try {
    var dateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date, true);
    final dateFormatter = DateFormat('dd/MM/yy', 'es_PY');
    dtFormatedd = dateFormatter.format(dateTime.toLocal());
  } catch (e) {
    dtFormatedd = '';
  }
  return dtFormatedd;
}

String formatOnlyDate(DateTime? dateTime) {
  if (dateTime == null) {
    return '--/--/--';
  }
  // var dateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date, true);
  final dateFormatter = DateFormat('dd/MM/yy', constLocale);
  var dtFormatedd = dateFormatter.format(dateTime.toLocal());
  return dtFormatedd;
}

String formatDateWithLocal(String? date, {int? subsTractDays}) {
  if (date == null) {
    return '';
  }
  final dateFormatter = DateFormat('dd/MM/yyyy', constLocale);
  var dtFormatedd = dateFormatter.format(
      DateTime.parse(date).subtract(Duration(days: subsTractDays ?? 0)));
  debugPrint('date: $date');
  debugPrint('dtFormatedd: $dtFormatedd');
  return dtFormatedd;
}

String formatDateWithLocalAndDash(String date) {
  // var dateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date, true);
  // var dateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date, true);
  final dateFormatter = DateFormat('yyyy-MM-dd', constLocale);
  var dtFormatedd = dateFormatter.format(DateTime.parse(date));
  return dtFormatedd;
}

String formatOnlyHour(DateTime? dateTime) {
  if (dateTime == null) {
    return '--/--';
  }
  final dateFormatter = DateFormat('H:mm', constLocale);
  var dtFormatedd = dateFormatter.format(dateTime.toLocal());
  return dtFormatedd;
}

String formatDateAndTime(DateTime? dateTime) {
  if (dateTime == null) {
    return '--/--/-- --:--';
  }
  final dateFormatter = DateFormat('dd/MM/yyyy H:mm', constLocale);
  var dtFormatedd = dateFormatter.format(dateTime.toLocal());
  return dtFormatedd;
}

String formatHourMillesima(String? date) {
  if (date == null) {
    return '';
  }
  var dateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date, true);
  final dateFormatter = DateFormat('H:mm:ss a', constLocale);
  return dateFormatter.format(dateTime.toLocal());
}

DateTime utfToLocalDate(String date) {
  if (date.isEmpty) return DateTime.now();
  var dateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date, true);
  return dateTime.toLocal();
}

int diasParaVencimiento(String dt) {
  if (dt.isEmpty) return 0;
  var dtVencimento = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(dt, true);
  dtVencimento =
      DateTime(dtVencimento.year, dtVencimento.month, dtVencimento.day);
  var now = DateTime.now();
  now = DateTime(now.year, now.month, now.day);
  return (dtVencimento.difference(now).inHours / 24).round();
}

String sqlDateFormat(String? date) {
  if (date == null) {
    return '';
  }
  final dateFormatter = DateFormat('yyyy-MM-dd HH:mm:ss', constLocale);
  var dateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date, true);
  var dtFormatedd = dateFormatter.format(dateTime);
  return dtFormatedd;
}

String datePickFormat(DateTime dt, {DateTime? dtFim}) {
  String start = dt.toString().replaceRange(10, null, 'T00:00:00');
  String end = "";
  if (dtFim == null) {
    end = dt.toString().replaceRange(10, null, 'T23:59:59');
  } else {
    end = dtFim.toString().replaceRange(10, null, 'T23:59:59');
  }
  final dateFormatter = DateFormat('dd/MM/yy', constLocale);
  DateTime s = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(start, true);
  DateTime e = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(end, true);
  return "${dateFormatter.format(s)} - ${dateFormatter.format(e)}";
}

String formateDatePDFName(DateTime dt) {
  final dateFormatter = DateFormat('dd MM yy HH mm', constLocale);
  var s = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dt.toString(), true);
  return dateFormatter.format(s);
}

String formateDateField(String? date) {
  if (date == null) {
    return '';
  }
  if (date.isEmpty) {
    return '';
  }
  var dateTime = DateFormat("yyyy-MM-dd").parse(date, true);
  final dateFormatter = DateFormat('dd/MM/yyyy', constLocale);
  var dtFormatedd = dateFormatter.format(dateTime);
  return dtFormatedd;
}

String formateDateFieldToSave(String? date) {
  if (date == null) {
    return '';
  }
  if (date.isEmpty) {
    return '';
  }
  var dateTime = DateFormat("dd/MM/yyyy").parse(date, true);
  final dateFormatter = DateFormat('yyyy-MM-dd', constLocale);
  var dtFormatedd = dateFormatter.format(dateTime);
  return dtFormatedd;
}

String resolveMesAtualEmLetras() {
  String result = "";
  DateFormat mesLetras = DateFormat('MMMM', constLocale);
  DateTime mesAtual = DateTime.now();
  result = mesLetras.format(mesAtual);

  return result;
}

DateTime resolveUltimoDiaMes({required DateTime dateTime}) {
  // Obtiene el primer día del siguiente mes
  DateTime firstDayNextMonth = DateTime(dateTime.year, dateTime.month + 1, 1);

  // Resta un día para obtener el último día del mes actual
  final ultimoDia = firstDayNextMonth;
  return ultimoDia;
}

List<String> generarListaFechas({
  required String dtInicio,
  required String dtFim,
}) {
  List<String> listaFechas = [];
  for (var fecha = DateTime.parse(dtInicio);
      fecha.isBefore(DateTime.parse(dtFim));
      fecha = fecha.add(const Duration(days: 1))) {
    listaFechas
        .add(formatDateWithLocalAndDash(fecha.toString().substring(0, 10)));
  }
  return listaFechas;
}

DateTime resolveMonday() {
  int now = DateTime.now().weekday;
  if (now == 1) {
    return DateTime.now().subtract(Duration(days: (now - 8).abs()));
  } else {
    return DateTime.now().subtract(Duration(days: now - 1));
  }
}

String ultimoDiaMes() {
  DateTime now = DateTime.now();
  return formatDateWithLocal(DateTime(now.year, now.month + 1, 0).toString());
}

String getDateOfWeek(String date) {
  DateTime dt = DateTime.parse(date);
  int dayWeek = dt.weekday;
  switch (dayWeek) {
    case 1:
      return "Lun ${formatDateWithLocal(date)}";
    case 2:
      return "Mar ${formatDateWithLocal(date)}";
    case 3:
      return "Mie ${formatDateWithLocal(date)}";
    case 4:
      return "Jue ${formatDateWithLocal(date)}";
    case 5:
      return "Vie ${formatDateWithLocal(date)}";
    case 6:
      return "Sab ${formatDateWithLocal(date)}";
    case 7:
      return "Dom ${formatDateWithLocal(date)}";
    default:
      return "";
  }
}

String formatDateNameFoto(String? date) {
  if (date == null || date.isEmpty) {
    return '';
  }
  // var dateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date, true);
  var dateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(date, true);
  final dateFormatter = DateFormat('dd MM yy HH mm ss', 'es_PY');
  var dtFormatedd = dateFormatter.format(dateTime.toLocal());
  return dtFormatedd;
}

String getDayAndMonth(String date) {
  DateTime dt = DateTime.parse(date);
  int day = dt.day;
  int month = dt.month;
  return "$day/$month";
}

bool isVencido(String dtVencimento) {
  DateTime dtVenc = DateTime.parse(dtVencimento);
  DateTime now = DateTime.now();
  if (dtVenc.isBefore(now)) {
    return true;
  }
  return false;
}

String formatPeriod(DateTime? start, DateTime? end) {
  if (start == null || end == null) {
    return '';
  }

  // Formatear las fechas
  String startFormatted = DateFormat('dd/MM/yy').format(start);
  String endFormatted = DateFormat('dd/MM/yy').format(end);

  // Retornar en el formato deseado
  return '$startFormatted al $endFormatted';
}
