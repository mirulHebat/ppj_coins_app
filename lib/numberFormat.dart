import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CommaInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.decimalPattern();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    
    // Remove non-digit characters for processing
    final String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    // Convert string to integer
    final int parsedValue = int.parse(digitsOnly);
    // Format number with commas
    final String formattedValue = _formatter.format(parsedValue);

    // Update the cursor position
    return newValue.copyWith(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: formattedValue.length),
    );
  }
}
