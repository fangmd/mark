import 'package:intl/intl.dart';

// Get Date String: yyyy/MM/dd
String formatTime({date}) {
  if (date == null) {
    date = DateTime.now();
  }
  return new DateFormat('yyyy/MM/dd').format(date);
}

/// 数据库中存储 UTC 时间
DateTime getDateTimeFromDB(int mill) {
  return DateTime.fromMillisecondsSinceEpoch(mill, isUtc: true);
}
