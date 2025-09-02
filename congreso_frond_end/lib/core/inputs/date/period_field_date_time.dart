import 'package:congreso_evento/core/formater/date_formater.dart';
import 'package:congreso_evento/core/inputs/text_field_custom.dart';
import 'package:flutter/material.dart';

class PeriodFieldDateTime extends StatefulWidget {
  final String? date;
  final Function(DateTime? start, DateTime? end) selectedPeriod;
  final double? width;
  final String label;
  final Color? colorFont;
  final TextEditingController? controller;
  final bool? showClearButton;

  const PeriodFieldDateTime({
    super.key,
    this.date = '',
    required this.selectedPeriod,
    this.width,
    required this.label,
    this.colorFont,
    this.controller,
    this.showClearButton = true,
  });

  @override
  PeriodFieldDateTimeState createState() => PeriodFieldDateTimeState();
}

class PeriodFieldDateTimeState extends State<PeriodFieldDateTime> {
  late String formatted = '';

  late TextEditingController controller;

  @override
  void initState() {
    if (widget.controller == null) {
      controller = TextEditingController();
    } else {
      controller = widget.controller!;
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PeriodFieldDateTime oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _onPressed(),
      child: SizedBox(
        width: (widget.width ?? double.infinity),
        child: Row(
          children: [
            Expanded(
              child: AbsorbPointer(
                child: TextFieldCustom(
                  controller: controller,
                  label: widget.label,
                  // textAlign: TextAlign.right,
                  // prefixIcon: const Icon(Icons.calendar_today),
                ),
              ),
            ),
            widget.showClearButton == true
                ? Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        widget.selectedPeriod(null, null);
                        controller.text = '';
                      },
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  _onPressed() async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendar,
      locale: const Locale("es", "PY"),
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      builder: (context, child) {
        return Scaffold(body: child!);
      },
    );
    if (picked == null) {
      widget.selectedPeriod(null, null);
      controller.text = '';
    } else {
      // Ajustar las horas de inicio y fin
      DateTime start = picked.start.copyWith(hour: 0, minute: 0, second: 0);
      DateTime end = picked.end.copyWith(hour: 23, minute: 59, second: 59);

      // Formatear las fechas para mostrar en el controlador
      formatted =
          '${formatDateWithLocal(start.toString())} - ${formatDateWithLocal(end.toString())}';

      controller.text = formatted;

      // Pasar las fechas ajustadas al método selectedPeriod
      widget.selectedPeriod(start, end);
    }
  }
}
