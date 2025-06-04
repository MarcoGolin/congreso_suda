import 'package:flutter/services.dart';

import 'package:flutter/services.dart';

class PhoneInputFormatter extends TextInputFormatter {
  int _countDigitsBeforeOffset(String text, int offset) {
    int count = 0;
    for (int i = 0; i < offset && i < text.length; i++) {
      if (RegExp(r'\d').hasMatch(text[i])) count++;
    }
    return count;
  }

  int _findOffsetForDigits(String text, int targetDigits) {
    int digitCount = 0;
    for (int i = 0; i < text.length; i++) {
      if (RegExp(r'\d').hasMatch(text[i])) {
        digitCount++;
        if (digitCount == targetDigits) return i + 1;
      }
    }
    return text.length;
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsBeforeCursor = _countDigitsBeforeOffset(
      newValue.text,
      newValue.selection.start,
    );

    String cleaned = newValue.text.replaceAll(RegExp(r'[^\d+]'), '');

    // Forzar '+' si comienza con código de país sin él
    if (cleaned.startsWith('595')) {
      cleaned = '+$cleaned';
    } else if (cleaned.startsWith('55')) {
      cleaned = '+$cleaned';
    }

    // Mantener un solo '+' al inicio
    if (cleaned.startsWith('+')) {
      cleaned = '+' + cleaned.substring(1).replaceAll('+', '');
    } else {
      cleaned = cleaned.replaceAll('+', '');
    }

    final digitsOnly = cleaned.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    if (cleaned.startsWith('+595')) {
      buffer.write('+595');
      String digits = digitsOnly.substring(3);

      if (digits.isNotEmpty) {
        buffer.write(' ');
        if (digits.length >= 3) {
          buffer.write(digits.substring(0, 3));
          digits = digits.substring(3);
        } else {
          buffer.write(digits);
          digits = '';
        }
      }

      if (digits.isNotEmpty) {
        buffer.write(' ');
        if (digits.length >= 3) {
          buffer.write(digits.substring(0, 3));
          digits = digits.substring(3);
        } else {
          buffer.write(digits);
          digits = '';
        }
      }

      if (digits.isNotEmpty) {
        buffer.write(' ');
        buffer.write(digits);
      }
    } else if (cleaned.startsWith('+55')) {
      buffer.write('+55');
      String digits = digitsOnly.substring(2); // eliminar '55'

      if (digits.isNotEmpty) {
        buffer.write(' ');
        if (digits.length >= 2) {
          buffer.write(digits.substring(0, 2)); // DDD
          digits = digits.substring(2);
        } else {
          buffer.write(digits);
          digits = '';
        }
      }

      if (digits.isNotEmpty) {
        buffer.write(' ');
        if (digits.length >= 5) {
          buffer.write(digits.substring(0, 5));
          digits = digits.substring(5);
        } else {
          buffer.write(digits);
          digits = '';
        }
      }

      if (digits.isNotEmpty) {
        buffer.write('-');
        buffer.write(digits);
      }
    } else {
      // Número no reconocido, devolver texto plano sin formateo
      return TextEditingValue(
        text: cleaned,
        selection: TextSelection.collapsed(offset: cleaned.length),
      );
    }

    final formatted = buffer.toString();
    final newOffset = _findOffsetForDigits(formatted, digitsBeforeCursor);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newOffset),
    );
  }
}
