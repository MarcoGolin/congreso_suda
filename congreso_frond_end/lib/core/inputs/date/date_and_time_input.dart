import 'package:congreso_evento/core/behahavior/custom_scroll_behavior.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class DateAndTimeInput extends StatefulWidget {
  final String label;
  final bool? enabled;
  final DateTime? dateTime;
  final String? Function(String?)? validator;
  final void Function(DateTime? dateTime)? onChanged;
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;
  const DateAndTimeInput({
    super.key,
    required this.label,
    this.validator,
    this.onChanged,
    this.enabled,
    this.dateTime,
    this.focusNode,
    this.onFieldSubmitted,
  });

  @override
  State<DateAndTimeInput> createState() => _DateAndTimeInputState();
}

class _DateAndTimeInputState extends State<DateAndTimeInput> {
  final _controller = MaskedTextController(mask: '00/00/00 00:00');

  final dateFormatter = DateFormat("dd-MM-yy HH:mm", 'es_PY');

  DateTime? _dateTime;

  double finalHeight = 35;
  late WidgetStatesController _statesController;

  @override
  void initState() {
    _statesController = WidgetStatesController();
    _statesController.addListener(() {
      Future.delayed(Duration.zero, () {
        if (_statesController.value.contains(WidgetState.error)) {
          if (finalHeight <= 35) {
            setState(() {
              finalHeight += 20;
            });
          }
        } else {
          setState(() {
            finalHeight = 35;
          });
        }
      });
    });

    if (widget.dateTime != null) {
      _dateTime = widget.dateTime;
      _controller.text = dateFormatter.format(_dateTime!);
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: finalHeight,
      child: TextFormField(
        focusNode: widget.focusNode,
        enabled: widget.enabled,
        controller: _controller,
        statesController: _statesController,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: 'dd/mm/yy HH:mm',
          suffixIcon: InkWell(
            onTap: widget.enabled == true ? () => _dateTimePicker() : null,
            child: const Icon(Icons.calendar_month, size: 18.0),
          ),
          contentPadding: const EdgeInsets.only(left: 8),
        ),
        keyboardType: TextInputType.datetime,
        onChanged: (value) {
          List<String> parts = value.split(' ');
          if (parts.length == 2) {
            List<String> dateParts = parts[0].split('/');
            List<String> timeParts = parts[1].split(':');
            if (dateParts.length == 3 && timeParts.length == 2) {
              int? day = int.tryParse(dateParts[0]);
              int? month = int.tryParse(dateParts[1]);
              int? year = int.tryParse(dateParts[2]);
              int? hour = int.tryParse(timeParts[0]);
              int? minute = int.tryParse(timeParts[1]);

              if (day != null &&
                  month != null &&
                  year != null &&
                  hour != null &&
                  minute != null) {
                _dateTime = DateTime(year, month, day, hour, minute);
                widget.onChanged!(_dateTime!);
              } else {
                widget.onChanged!(null);
                _dateTime = null;
              }
            } else {
              widget.onChanged!(null);
              _dateTime = null;
            }
          } else {
            widget.onChanged!(null);
            _dateTime = null;
          }
        },
        onFieldSubmitted: widget.onFieldSubmitted,
        validator: (value) {
          if (_dateTime == null) {
            return 'Inválido';
          }

          if (widget.validator != null) {
            return widget.validator!(value);
          }
          return null;
        },
      ),
    );
  }

  _dateTimePicker() async {
    if (widget.dateTime != null) {
      widget.onChanged!(widget.dateTime!);
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300, maxHeight: 300),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: CustomScrollBehavior(),
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode
                        .dateAndTime, // Use dateAndTime mode
                    initialDateTime: _dateTime,
                    dateOrder: DatePickerDateOrder.dmy,
                    use24hFormat: true,
                    onDateTimeChanged: (val) => _dateTime = val,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  onPressed: () {
                    _dateTime ??= DateTime.now();
                    _controller.text = dateFormatter.format(_dateTime!);
                    widget.onChanged!(_dateTime);
                    Modular.to.pop();
                  },
                  child: const Text('ACEPTAR'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
