import 'package:mark/entity/record.dart';
import 'package:mark/provider/db/record_db_provider.dart';
import 'package:mark/provider/net/record_provider.dart';
import 'package:mark/utils/logger.dart';

class RecordRepository {
  static const TAG = 'RecordRepository';
  RecordDBProvider _recordDBProvider = RecordDBProvider();
  RecordProvider _recordProvider = RecordProvider();
  Map<int, List<RecordEntity>> _map = new Map<int, List<RecordEntity>>();

  Future<RecordEntity> saveRecord(RecordEntity record) async {
    await _recordDBProvider.open();
    RecordEntity recordDb = await _recordDBProvider.insert(record);
    await _recordDBProvider.close();
    return recordDb;
  }

  Future<int> getMonthAmount(int year, int month, int day) async {
    List<RecordEntity> recordsDB = _map[day];
    if (recordsDB == null) {
      Logger.d(tag: TAG, msg: 'get RecordEntity from DB');
      await _recordDBProvider.open();
      recordsDB = await _recordDBProvider.getRecordByMonth(year, month);
      await _recordDBProvider.close();
      _map[day] = recordsDB;
    } else {
      Logger.d(tag: TAG, msg: 'get RecordEntity from Cahce');
    }

    var amount = 0.0;
    for (var item in recordsDB) {
      if (item.value != null) {
        amount += item.value;
      }
    }
    Logger.d(tag: TAG, msg: 'Record Month Amount is $amount');
    return amount.toInt();
  }

  Future<List> getDayExpend({int year, int month, int day}) async {
    if (year == null) {
      year = DateTime.now().year;
    }
    if (month == null) {
      month = DateTime.now().month;
    }

    List<RecordEntity> recordsDB = _map[day];
    if (recordsDB == null) {
      Logger.d(tag: TAG, msg: 'get RecordEntity from DB');
      await _recordDBProvider.open();
      recordsDB = await _recordDBProvider.getRecordByDay(year, month, day);
      await _recordDBProvider.close();
      _map[day] = recordsDB;
    } else {
      Logger.d(tag: TAG, msg: 'get RecordEntity from Cahce');
    }

    var amount = 0.0;
    for (var item in recordsDB) {
      if (item.value != null) {
        amount += item.value;
      }
    }
    Logger.d(tag: TAG, msg: 'Record Day Amount is $amount');
    return [amount.toInt(), recordsDB];
  }
}
