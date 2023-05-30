double? intToDouble(dynamic value) {
  if (value is double) {
    return value;
  }
  if (value == null) {
    return null;
  }
  return value.toDouble();
}

String trimZeros(double number) {
  String str = number.toString();
  if (!str.contains('.')) {
    str = '$str.';
  }
  str = str.padRight(str.length + 2, '0');
  while (str.endsWith('0') && str.split('.').last.length > 2) {
    str = str.substring(0, str.length - 1);
  }
  return str;
}
