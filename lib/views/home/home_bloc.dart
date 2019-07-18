import 'package:mark/components/chart/data.dart';
import 'package:mark/entity/record.dart';
import 'package:mark/repository/RecordRepository.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc {
  final RecordRepository _recordRepository = RecordRepository();

  final BehaviorSubject<List<Point>> _pointSubject =
      BehaviorSubject<List<Point>>();

  BehaviorSubject<List<Point>> get pointSubject => _pointSubject;

  Future<int> getMonthExpand({int year, int month}) async {
    if (year == null) {
      year = DateTime.now().year;
    }
    if (month == null) {
      month = DateTime.now().month;
    }
    return await _recordRepository.getMonthAmountExpend(
        year, month, DateTime.now().day);
  }

  Future<List> getDayExpend({int year, int month, int day}) async {
    if (year == null) {
      year = DateTime.now().year;
    }
    if (month == null) {
      month = DateTime.now().month;
    }
    if (day == null) {
      day = DateTime.now().day;
    }
    var list = await _recordRepository.getDayExpend(
        year: year, month: month, day: day);

    return list;
  }

  Future<List<Point>> getWeekPoint() async {
    print(DateTime.now().weekday);
    DateTime dayNow = DateTime.now();
    int weekday = dayNow.weekday;
    List<Point> points = List<Point>();
    Point point;
    for (var i = 1; i <= weekday; i++) {
      DateTime day = dayNow.subtract(Duration(days: weekday - i));

      List listD = await _recordRepository.getDayExpend(
          year: day.year, month: day.month, day: day.day);
      point = Point(
          x: i - 1,
          y: listD[0].toDouble(),
          xText: '${day.weekday}',
          yText: '${listD[0]}');
      points.add(point);
    }
    _pointSubject.sink.add(points);
    return points;
  }

  dispose() {
    _pointSubject.close();
  }
}
