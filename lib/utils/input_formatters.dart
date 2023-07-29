import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

TextInputFormatter commaSeparatedNumberFormatter =
    TextInputFormatter.withFunction((oldValue, newValue) {
  final text = newValue.text;
  final number = int.tryParse(text);

  if (number == null) {
    return const TextEditingValue(
      text: '',
    );
  } else {
    final formatter = NumberFormat('#,###');
    final newString = formatter.format(number);
    return TextEditingValue(
      text: newString,
      selection: TextSelection.collapsed(offset: newString.length),
    );
  }
});
