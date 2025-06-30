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

    bool cursorToEnd = false;

    if (cleaned.startsWith('098')) {
      cleaned = '+59598${cleaned.substring(3)}';
      cursorToEnd = true;
    } else if (cleaned.startsWith('98')) {
      cleaned = '+59598${cleaned.substring(2)}';
      cursorToEnd = true;
    } else if (cleaned.startsWith('0')) {
      cleaned = '+595${cleaned.substring(1)}';
      cursorToEnd = true;
    } else if (cleaned.startsWith('9')) {
      cleaned = '+5959${cleaned.substring(1)}';
      cursorToEnd = true;
    }
    // Forzar '+' si comienza con código de país sin él
    if (cleaned.startsWith('595') ||
        cleaned.startsWith('55') ||
        cleaned.startsWith('54')) {
      cleaned = '+$cleaned';
    }

    // Mantener un solo '+' al inicio
    if (cleaned.startsWith('+')) {
      cleaned = '+${cleaned.substring(1).replaceAll('+', '')}';
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
      String digits = digitsOnly.substring(2);

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
    } else if (cleaned.startsWith('+54')) {
      buffer.write('+54');
      String digits = digitsOnly.substring(2); // solo dígitos después de +54

      if (digits.isNotEmpty) {
        buffer.write(' ');
        if (digits.length >= 3) {
          buffer.write(digits.substring(0, 3)); // prefijo como 911
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
    } else {
      return TextEditingValue(
        text: cleaned,
        selection: TextSelection.collapsed(offset: cleaned.length),
      );
    }
    final formatted = buffer.toString();

    // Evitar que se pase del largo del texto
    final clampedOffset = cursorToEnd
        ? formatted.length
        : _findOffsetForDigits(
            formatted,
            digitsBeforeCursor,
          ).clamp(0, formatted.length);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: clampedOffset),
    );
  }
}
