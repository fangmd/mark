import 'package:mark/C.dart';
import 'package:mark/entity/db_info.dart';
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

    Database db = await openDatabase(path, version: DB_VERSION,
        onCreate: (Database db, int version) async {
      // _createTableV1(db);
      _createTableV2(db);
    }, onUpgrade: (db, oldVersion, newVersion) {
      if (oldVersion == 1) {
        _updateTableV1toV2(db);
      }
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

  ///// 数据库里时间用 integer 存储，存储 UTC 时间
  void _createTableV2(Database db) async {
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
    await db.execute('''
        create table mark_db_info (
          id integer primary key autoincrement,
          version integer
          )
        ''');
  }

  Future delete() async {
    var db = await initDB();
    db.delete('mark_record');
    return 0;
  }

  void _updateTableV1toV2(Database db) async {
    await db.execute('''
        create table mark_db_info (
          id integer primary key autoincrement,
          version integer
          )
        ''');
    var dnInfo = DBInfoEntity(version: DB_VERSION);
    await db.insert('mark_db_info', dnInfo.toMapDB());
  }
}
