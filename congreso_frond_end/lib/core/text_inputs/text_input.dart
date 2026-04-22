import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInput extends StatefulWidget {
  final ValueChanged<String>? value;
  final String? text;
  final String? label;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final String? hintText;
  final Widget? icon;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final bool? enabled;
  final bool? isPassword;
  final bool? autoFocus;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Function(String)? onSubmited;
  final bool isRelatorio;
  final TextStyle? titleStyle;
  final Color? colorFont;
  final TextAlign? textAlign;
  final Color? cursorColor;

  const TextInput({
    super.key,
    this.text,
    this.icon,
    this.autoFocus = false,
    this.isPassword = false,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.minLines,
    this.maxLines,
    this.enabled,
    this.contentPadding,
    this.maxLength,
    this.inputFormatters,
    this.errorText,
    required this.label,
    this.onChanged,
    this.textInputAction,
    this.onSubmited,
    this.focusNode,
    this.isRelatorio = false,
    this.value,
    this.titleStyle,
    this.colorFont,
    this.textAlign,
    this.cursorColor,
  });

  @override
  TextInputState createState() => TextInputState();
}

class TextInputState extends State<TextInput> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: "");
    if (widget.text == null || widget.text!.isEmpty) {
      controller.text = "";
    } else {
      controller.text = widget.text!;
      widget.value!(controller.text);
    }

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TextInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.text == null || widget.text!.isEmpty) {
      controller.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      inputFormatters: widget.inputFormatters,
      onChanged: widget.onChanged,
      maxLength: widget.maxLength,
      minLines: widget.minLines, //Normal textInputField will be displayed
      maxLines: widget.maxLines, //
      enabled: widget.enabled, //
      obscureText: widget.isPassword!,
      autofocus: widget.autoFocus!,
      focusNode: widget.focusNode,
      controller: widget.controller ?? controller,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmited,
      decoration: InputDecoration(
        errorText: widget.errorText,
        hintText: widget.hintText,
        filled: true,
        labelText: widget.label,
        suffixIcon: _clearField(),
      ),
    );
  }

  Widget? _clearField() {
    if (widget.isRelatorio == true) {
      return IconButton(
        icon: const Icon(Icons.cancel),
        onPressed: () {
          controller.clear();
          widget.value!('');
        },
      );
    } else {
      return widget.icon;
    }
  }
}
