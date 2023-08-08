class CommonUtils {
  static stringToEnum(String? s, List values) {
    if (s == null) return null;
    return values.firstWhere(
      (e) => e.toString().split('.')[1].toUpperCase() == s.toUpperCase(),
    );
  }
}
