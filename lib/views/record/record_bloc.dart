import 'package:mark/entity/record.dart';
import 'package:mark/repository/RecordRepository.dart';

class RecordBloc {
  final RecordRepository _recordRepository = RecordRepository();

  Future<RecordEntity> saveRecord(RecordEntity record) async {
    return await _recordRepository.saveRecord(record);
  }

  dispose() {}
}
