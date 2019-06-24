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

  Future<List<RecordEntity>> getAll() async {
    // List<Map> maps = await db.query('zb_card');
    // if (maps.length > 0) {
    //   List<RecordEntity> retList = List<RecordEntity>();
    //   for (Map map in maps) {
    //     retList.add(RecordEntity.fromMapForDB(map));
    //   }
    //   return retList;
    // }
    // return List<RecordEntity>();
  }

  Future<List<RecordEntity>> getRecordByMonth(int month) async {
    var from = new DateTime(DateTime.now().year, month, 1).toUtc().millisecondsSinceEpoch;
    Logger.d(msg: "getRecordByMonth from: $from");
    var last;
    if (month == 12) {
      last = new DateTime(DateTime.now().year + 1, 1, 1)
          .toUtc()
          .millisecondsSinceEpoch;
    } else {
      last = new DateTime(DateTime.now().year, month + 1, 1)
          .toUtc()
          .millisecondsSinceEpoch;
    }

    List<Map> query = await db.rawQuery(
        'select * from mark_record where recordDateTime >= ? & recordDateTime <= ?',
        [from, last]);

    var ret = List<RecordEntity>();
    for (var item in query) {
      ret.add(RecordEntity.fromMapDB(item));
    }
    return ret;
  }

  Future close() async => db.close();

  Future deleteAll() async {
    await db.delete('mark_record');
  }
}
