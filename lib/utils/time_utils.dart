import 'package:intl/intl.dart';

// Get Date String: yyyy/MM/dd
String formatTime({date, pattern}) {
  if (date == null) {
    date = DateTime.now();
  }
  if (pattern == null) {
    pattern = 'yyyy/MM/dd';
  }
  return new DateFormat(pattern).format(date);
}

/// Get Date String: yyyy/MM/dd
/// same year to current,return MM-dd
/// other year to current, return yyyy-MM-dd
String formatTimeForHistory(date) {
  String pattern = 'MM-dd';
  if (!(date.year == DateTime.now().year)) {
    pattern = 'yyyy-MM-dd';
  }
  return new DateFormat(pattern).format(date);
}

/// 数据库中存储 UTC 时间
DateTime getDateTimeFromDB(int mill) {
  return DateTime.fromMillisecondsSinceEpoch(mill, isUtc: true);
}

/// 返回上个月的时间
DateTime getLastMonth(DateTime time) {
  int year = time.year;
  int month = time.month;
  int day = time.day;
  if (month == 1) {
    month = 12;
    year = year - 1;
  } else {
    month = month - 1;
  }
  return DateTime(year, month, day);
}

/// 返回下个月的时间
DateTime getNextMonth(DateTime time) {
  int year = time.year;
  int month = time.month;
  int day = time.day;
  if (month == 12) {
    month = 1;
    year = year + 1;
  } else {
    month = month + 1;
  }
  return DateTime(year, month, day);
}

/// check two DateTime is same month
bool sameMonth(DateTime one, DateTime two) {
  return one.year == two.year && one.month == two.month;
}
