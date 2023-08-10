class CommonUtils {
  static stringToEnum(String? s, List values) {
    if (s == null) return null;
    return values.firstWhere(
      (e) => e.toString().split('.')[1].toUpperCase() == s.toUpperCase(),
    );
  }

  static isObjectId(String? id) {
    if (id == null) return false;
    return RegExp(r'^[a-f\d]{24}$', caseSensitive: false).hasMatch(id);
  }
}
