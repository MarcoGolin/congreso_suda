import 'package:congreso_evento/core/behahavior/custom_scroll_behavior.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';

class DateInput extends StatefulWidget {
  final String label;
  final bool? enabled;
  final DateTime? date;
  final String? Function(String?)? validator;
  final void Function(DateTime dateTime)? onChanged;
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;
  final MaskedTextController? controller;
  const DateInput({
    super.key,
    required this.label,
    this.validator,
    this.onChanged,
    this.enabled,
    this.date,
    this.focusNode,
    this.onFieldSubmitted,
    this.controller,
  });

  @override
  State<DateInput> createState() => _DateInputState();
}

class _DateInputState extends State<DateInput> {
  final dateFormatter = DateFormat("dd-MM-yy", 'es_PY');

  DateTime? _dateTime;

  double finalHeight = 0.0;
  late WidgetStatesController _statesController;

  late MaskedTextController _controller;

  @override
  void initState() {
    var heightExtra = 0.0;
    // if (widget.maxLength != null) {
    //   heightExtra = 20;
    // }
    finalHeight = (35 + heightExtra);
    _statesController = WidgetStatesController();
    _statesController.addListener(() {
      Future.delayed(Duration.zero, () {
        if (_statesController.value.contains(WidgetState.error)) {
          if (finalHeight == (35 + heightExtra)) {
            setState(() {
              if (heightExtra > 0) {
                finalHeight += 3;
              } else {
                finalHeight += 20;
              }
            });
          }
        } else {
          setState(() {
            finalHeight = (35 + heightExtra);
          });
        }
      });
    });

    if (widget.date != null) {
      _dateTime = widget.date;
    }

    if (widget.controller != null) {
      _controller = widget.controller!;
      if (widget.date != null && _controller.text.isEmpty) {
        _controller.text = dateFormatter.format(widget.date!);
      }
    } else {
      _controller = MaskedTextController(mask: '00/00/00');
      if (widget.date != null) {
        _controller.text = dateFormatter.format(widget.date!);
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _statesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: finalHeight,
      child: TextFormField(
        statesController: _statesController,
        focusNode: widget.focusNode,
        enabled: widget.enabled,
        controller: _controller,
        maxLines: 1,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          labelText: widget.label,
          hintText: 'dd/mm/yy',
          suffixIcon: InkWell(
            onTap: widget.enabled == true ? () => _dateTimePicker() : null,
            child: const Icon(Icons.calendar_month, size: 18.0),
          ),
          contentPadding: const EdgeInsets.only(left: 8),
        ),
        keyboardType: TextInputType.datetime,
        onChanged: (value) {
          if (_isValidDate(value)) {
            final parts = value.split('/');
            final day = int.tryParse(parts[0]);
            final month = int.tryParse(parts[1]);
            var year = int.tryParse(parts[2]);
            if (day == null || month == null || year == null) return;
            // Convertir años de dos dígitos a cuatro dígitos
            if (year < 100) {
              year += 2000;
            }
            _dateTime = DateTime(year, month, day);
            widget.onChanged?.call(_dateTime!);
          } else {
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

  bool _isValidDate(String date) {
    final parts = date.split('/');
    if (parts.length != 3) return false;

    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    var year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) return false;

    // Convertir años de dos dígitos a cuatro dígitos
    if (year < 100) {
      year += 2000;
    }

    try {
      DateTime(year, month, day); // Verifica si la fecha es válida
      return true;
    } catch (e) {
      return false;
    }
  }

  _dateTimePicker() async {
    if (widget.date != null) {
      widget.onChanged!(widget.date!);
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
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: widget.date ?? DateTime.now(),
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

                    widget.onChanged!(_dateTime!);
                    _controller.text = dateFormatter.format(_dateTime!);
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
