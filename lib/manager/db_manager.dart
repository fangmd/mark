import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBManager {
  static void initDBTable() async {
    Database db = await DBManager().initDB();
    await db.close();
  }

  Future<Database> initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'mark.db');

    Database db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      _createTableV1(db);
    });

    return db;
  }

  ///// 数据库里时间用 integer 存储，存储 UTC 时间
  void _createTableV1(Database db) async {
    await db.execute('''
create table mark_record (
  id integer primary key autoincrement,
  createDate integer,
  recordDateTime integer,
  type text NOT NULL,
  value double,
  comments text
  )
''');
  }
}
