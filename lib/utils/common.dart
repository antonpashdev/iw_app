class CommonUtils {
  static stringToEnum(String s, List values) {
    return values.firstWhere(
        (e) => e.toString().split('.')[1].toUpperCase() == s.toUpperCase());
  }
}
