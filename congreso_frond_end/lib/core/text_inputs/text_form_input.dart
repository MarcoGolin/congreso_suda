// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormInput extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final String? helperText;
  final String? initValue;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;
  final bool? autofocus;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final bool? enabled;
  final TextAlign? textAlign;
  final Widget? suffixIcon;
  final int? maxLines;
  final int? maxLength;
  final bool obscureText;
  final Iterable<String>? autofillHints;
  final Color? fontColor;
  final Color? fontDisableColor;
  final int? minLines;
  final bool? readOnly;
  final void Function()? onTap;
  final TextCapitalization? textCapitalization;
  final bool? dense;
  final String? suffixText;

  const TextFormInput({
    super.key,
    this.labelText,
    this.hintText,
    this.helperText,
    this.validator,
    this.controller,
    this.inputFormatters,
    this.autofocus,
    this.onChanged,
    this.focusNode,
    this.keyboardType,
    this.enabled = true,
    this.onFieldSubmitted,
    this.textAlign,
    this.suffixIcon,
    this.initValue,
    this.maxLines,
    this.obscureText = false,
    this.maxLength,
    this.autofillHints,
    this.fontColor,
    this.minLines,
    this.readOnly,
    this.onTap,
    this.textCapitalization,
    this.dense = true,
    this.suffixText,
    this.fontDisableColor,
  });

  @override
  State<TextFormInput> createState() => _TextFormInputState();
}

class _TextFormInputState extends State<TextFormInput> {
  double finalHeight = 0.0;
  late WidgetStatesController _statesController;

  @override
  void initState() {
    var heightExtra = 0.0;
    if (widget.maxLength != null) {
      heightExtra = 20;
    }
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.dense == true ? finalHeight : null,
      child: TextFormField(
        textCapitalization:
            widget.textCapitalization ?? TextCapitalization.none,
        statesController: _statesController,
        autofocus: widget.autofocus ?? false,
        initialValue: widget.initValue,
        inputFormatters: widget.inputFormatters,
        keyboardType: widget.keyboardType,
        enabled: widget.enabled,
        maxLines: widget.maxLines ?? 1,
        textAlign: widget.textAlign ?? TextAlign.start,
        obscureText: widget.obscureText,
        maxLength: widget.maxLength,
        validator: widget.validator,
        controller: widget.controller,
        focusNode: widget.focusNode,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onFieldSubmitted,
        autofillHints: widget.autofillHints,
        minLines: widget.minLines,
        readOnly: widget.readOnly ?? false,
        onTap: widget.onTap,
      ),
    );
  }
}
