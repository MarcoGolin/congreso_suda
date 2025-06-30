import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldCustom extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onFieldSubmitted;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  final TextCapitalization? textCapitalization;

  final int? maxLines;
  final int? maxLength;

  const TextFieldCustom({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines,
    this.maxLength,
    this.focusNode,
    this.textInputAction,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.onChanged,
    this.hintText,
    this.onTap,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        maxLines: maxLines ?? 1,
        maxLength: maxLength,
        textInputAction: textInputAction ?? TextInputAction.next,
        textCapitalization: textCapitalization!,
        decoration: inputDecoration.copyWith(
          labelText: label,
          hintText: hintText,
        ),
        inputFormatters: inputFormatters,
        validator:
            validator ??
            (value) =>
                (value == null || value.isEmpty) ? 'Campo requerido' : null,
        style: const TextStyle(fontSize: 14, color: Colors.black87),
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        onTap: onTap,
      ),
    );
  }
}

InputDecoration get inputDecoration => InputDecoration(
  isDense: true,
  contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide.none,
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Color(0xFF0C4793), width: 2.0),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Colors.red, width: 2.0),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Colors.red, width: 2.0),
  ),
  filled: true,
  fillColor: const Color(0xFFF9FAFB),
  labelStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
  hintStyle: TextStyle(color: Colors.grey[400]),
);
