import 'package:mark/entity/record.dart';
import 'package:mark/provider/db/record_db_provider.dart';
import 'package:mark/provider/net/record_provider.dart';
import 'package:mark/utils/logger.dart';

class RecordRepository {
  static const TAG = 'RecordRepository';
  RecordDBProvider _recordDBProvider = RecordDBProvider();
  RecordProvider _recordProvider = RecordProvider();

  Future<RecordEntity> saveRecord(RecordEntity record) async {
    await _recordDBProvider.open();
    RecordEntity recordDb = await _recordDBProvider.insert(record);
    await _recordDBProvider.close();
    return recordDb;
  }

  Future<int> getMonthAmount({int month}) async {
    if (month == null) {
      month = DateTime.now().month;
    }
    await _recordDBProvider.open();
    List<RecordEntity> recordsDB =
        await _recordDBProvider.getRecordByMonth(month);
    await _recordDBProvider.close();

    var amount = 0.0;
    for (var item in recordsDB) {
      if (item.value != null) {
        amount += item.value;
      }
    }
    Logger.d(tag: TAG, msg: 'Record Month Amount is $amount');
    return amount.toInt();
  }
}
