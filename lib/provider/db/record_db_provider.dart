import 'package:mark/entity/record.dart';
import 'package:mark/manager/db_manager.dart';
import 'package:mark/utils/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class RecordDBProvider {
  Database db;

  Future open() async {
    db = await DBManager().initDB();
  }

  Future<RecordEntity> insert(RecordEntity card) async {
    await db.insert('mark_record', card.toMapDB());
    return card;
  }

  Future<List<RecordEntity>> getRecordByMonth(int year, int month) async {
    var from = new DateTime(year, month, 1).millisecondsSinceEpoch;
    Logger.d(msg: "getRecordByMonth from: $from");
    var last;
    if (month == 12) {
      last = new DateTime(year + 1, 1, 1).millisecondsSinceEpoch;
    } else {
      last = new DateTime(year, month + 1, 1).millisecondsSinceEpoch;
    }

    List<Map> query = await db.rawQuery(
        'select * from mark_record where recordDateTime >= ? and recordDateTime <= ? ORDER BY recordDateTime DESC',
        [from, last]);

    var ret = List<RecordEntity>();
    for (var item in query) {
      ret.add(RecordEntity.fromMapDB(item));
    }
    return ret;
  }

  Future close() async {
    // db.close();
  }

  Future deleteAll() async {
    await db.delete('mark_record');
  }

  Future<List<RecordEntity>> getRecordByDay(
      int year, int month, int day) async {
    var from = new DateTime(year, month, day, 0, 0, 0).millisecondsSinceEpoch;
    var last =
        new DateTime(year, month, day, 23, 59, 59).millisecondsSinceEpoch;
    Logger.d(msg: "getRecordByDay from: $from , to $last");

    List<Map> query = await db.rawQuery(
        'select * from mark_record where recordDateTime >= ? and recordDateTime <= ?',
        [from, last]);

    var ret = List<RecordEntity>();
    for (var item in query) {
      ret.add(RecordEntity.fromMapDB(item));
    }
    return ret;
  }
}
