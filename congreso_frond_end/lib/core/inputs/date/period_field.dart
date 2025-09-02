import 'package:congreso_evento/core/formater/date_utils.dart';
import 'package:congreso_evento/core/inputs/text_field_custom.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

class PeriodField extends StatefulWidget {
  final String? date;
  final ValueChanged<ObservableList<String>?>? selectedPeriod;
  final ValueChanged<String>? realDate;
  final double? width;
  final String label;
  final Color? colorFont;
  final TextEditingController? controller;
  final bool isDateTime;
  final bool? showClearButton;

  const PeriodField({
    super.key,
    this.date = '',
    required this.selectedPeriod,
    this.width,
    required this.label,
    this.colorFont,
    this.controller,
    this.realDate,
    this.isDateTime = true,
    this.showClearButton = true,
  });

  @override
  PeriodFieldState createState() => PeriodFieldState();
}

class PeriodFieldState extends State<PeriodField> {
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
  void didUpdateWidget(covariant PeriodField oldWidget) {
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
                  // enabled: true,
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
                        widget.selectedPeriod!(null);
                        if (widget.realDate != null) {
                          widget.realDate!('');
                        }
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
      widget.selectedPeriod!(null);
    } else {
      // FECHA QUE MUESTRA EL PERIOD
      List<String> data = [];
      // FECHA QUE ENVIA AL BACKEND
      List<String> realData = [];

      var start = picked.start.toString().replaceRange(10, null, 'T00:00:00');
      var end = picked.end.toString().replaceRange(10, null, 'T23:59:59');

      if (widget.isDateTime) {
        realData.add(sqlDateTimeFormat(start));
        realData.add(sqlDateTimeFormat(end));
        data.add(start);
        data.add(end);
        formatted =
            '${formatDateWithLocal(start)} - ${formatDateWithLocal(end)}';
      } else {
        realData.add(sqlDateTimeFormat(start));
        realData.add(sqlDateTimeFormat(end));
        data.add(start);
        data.add(end);
        formatted =
            '${formatDateWithLocal(start.toString())} - ${formatDateWithLocal(end.toString())}';
      }

      // debugPrint("data ${data.first} -${data.last} ");
      // debugPrint("real rada ${realData.first} -${realData.last} ");

      widget.selectedPeriod!(realData.asObservable());

      controller.text = formatted;

      if (widget.realDate != null) widget.realDate!(formatted);
    }
  }
}
