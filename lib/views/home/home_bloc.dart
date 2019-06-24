import 'package:mark/entity/record.dart';
import 'package:mark/repository/RecordRepository.dart';

class HomeBloc {
  final RecordRepository _recordRepository = RecordRepository();

  Future<int> getMonthExpand({int month}) async {
    if (month == null) {
      month = DateTime.now().month;
    }
    return await _recordRepository.getMonthAmount();
  }

  dispose() {}
}
