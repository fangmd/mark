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

/// 数据库中存储 UTC 时间
DateTime getDateTimeFromDB(int mill) {
  return DateTime.fromMillisecondsSinceEpoch(mill, isUtc: true);
}
