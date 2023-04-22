double? intToDouble(dynamic value) {
  if (value is double) {
    return value;
  }
  if (value == null) {
    return null;
  }
  return value.toDouble();
}
