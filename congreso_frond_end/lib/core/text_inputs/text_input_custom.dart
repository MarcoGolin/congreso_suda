import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInputCustom extends StatefulWidget {
  final ValueChanged<String>? value;
  final String text;
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
  final bool autoFocus;
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

  const TextInputCustom({
    super.key,
    this.text = '',
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
  TextInputCustomState createState() => TextInputCustomState();
}

class TextInputCustomState extends State<TextInputCustom> {
  final controller = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(TextInputCustom oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    var colorFont = widget.colorFont ?? Colors.black87;

    return Row(
      children: [
        Expanded(
          child: TextFormField(
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: colorFont),
            inputFormatters: widget.inputFormatters,
            onChanged: widget.onChanged,
            maxLength: widget.maxLength,
            minLines: widget.minLines, //Normal textInputField will be displayed
            maxLines: widget.maxLines, //
            enabled: widget.enabled, //
            obscureText: widget.isPassword!,
            autofocus: widget.autoFocus,
            focusNode: widget.focusNode,
            controller: widget.controller ?? controller,
            keyboardType: widget.keyboardType,
            textAlign:
                widget.textAlign == null ? TextAlign.end : widget.textAlign!,
            textInputAction: widget.textInputAction,
            onFieldSubmitted: widget.onSubmited,
            cursorColor: widget.cursorColor ?? Colors.white,
            decoration: InputDecoration(
              errorText: widget.errorText,
              contentPadding: (widget.contentPadding ??
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 0)),
              hintStyle: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: colorFont,
                  ),
              hintText: widget.hintText,
              labelText: widget.label,
              labelStyle: widget.titleStyle ??
                  Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontSize: 12.0,
                        color: colorFont,
                      ),
              // suffixIcon: _clearField(colorFont),
              hoverColor: Colors.grey,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colorFont),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colorFont),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: colorFont),
              ),
            ),
            textAlignVertical: TextAlignVertical.top,
          ),
        ),
        _clearField(colorFont),
      ],
    );
  }

  Widget _clearField(Color colorFont) {
    if (widget.isRelatorio == true) {
      return IconButton(
        icon: const Icon(Icons.cancel),
        onPressed: () {
          controller.clear();
          widget.value!('');
          setState(() {});
        },
        color: colorFont,
      );
    } else {
      return widget.icon ?? const SizedBox();
    }
  }
}
