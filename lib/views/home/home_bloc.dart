import 'package:mark/entity/record.dart';
import 'package:mark/repository/RecordRepository.dart';

class HomeBloc {
  final RecordRepository _recordRepository = RecordRepository();

  Future<int> getMonthExpand({int year, int month}) async {
    if (year == null) {
      year = DateTime.now().year;
    }
    if (month == null) {
      month = DateTime.now().month;
    }
    return await _recordRepository.getMonthAmount(
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

  dispose() {}
}
