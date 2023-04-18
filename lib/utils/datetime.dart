import 'package:intl/intl.dart';

int calculateDiffWithNow(DateTime date) {
  DateTime now = DateTime.now();
  return DateTime(date.year, date.month, date.day)
      .difference(DateTime(now.year, now.month, now.day))
      .inDays;
}

String getFormattedDate(DateTime date) {
  final diffWithNow = calculateDiffWithNow(date);
  if (diffWithNow == 0) {
    return 'Today';
  } else if (diffWithNow == -1) {
    return 'Yesterday';
  } else if (diffWithNow == 1) {
    return 'Tomorrow';
  }
  return DateFormat('MMM dd, yyyy').format(date);
}
