import 'dart:io';

import 'package:mark/entity/backup_db.dart';
import 'package:mark/utils/file_utils.dart';
import 'package:mark/utils/logger.dart';
import 'package:mark/utils/time_utils.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class FileManager {
  static const BACK_UP = 'mark-backup';
  static const DB_FILE = 'mark.db';

  /// 备份 db
  Future<bool> backupDB() async {
    print('text');
    if (Platform.isAndroid) {
      print('isAndroid');
      File newFile = await _createNewFile();
      File dbFile = await _getDBFile();
      Logger.d(msg: 'newFile path: ${newFile.path}, DBFile ${dbFile.path}');
      if (dbFile.existsSync()) {
        await copyFile(dbFile.path, newFile.path);
        return true;
      } else {
        return false;
      }
    } else {
      print('is IOS');
      return false;
    }
  }

  /// 恢复备份
  Future<bool> restoreDB(fileName) async {
    var path = await getExternalStorageDirectory();
    File backupFile = File(join(path.path, BACK_UP, fileName));
    File dbFile = await _getDBFile();

    //delete newFile First
    dbFile.deleteSync();

    await copyFile(backupFile.path, dbFile.path);
    return true;
  }

  /// 删除备份文件：sdcard/make-backup/...
  Future<bool> deleteBackup() async {
    if (Platform.isAndroid) {
      var path = await getExternalStorageDirectory();
      var backupFilePath = join(path.path, '$BACK_UP');
      var file = File(backupFilePath);
      FileSystemEntity entity = await file.delete(recursive: true);
      return true;
    } else {
      return false;
    }
  }

  ///删除App数据库
  Future<bool> deleteDB() async {
    if (Platform.isAndroid) {
      var dbFile = await _getDBFile();
      dbFile.deleteSync();
      return true;
    } else {
      return false;
    }
  }

  /// 获取所有备份文件 DB
  Future<List<BackupDbFileEntity>> getBackupFiles() async {
    var backupDir = await _createBackupDir();
    List<FileSystemEntity> list = backupDir.listSync();
    var ret = List<BackupDbFileEntity>();
    for (var item in list) {
      ret.add(BackupDbFileEntity(File(item.path)));
    }
    return ret;
  }

  /// 创建一个备份文件夹下的新 DB 文件(文件名称: yyyy-MM-dd.db)
  /// 一天内可以多次创建
  Future<File> _createNewFile() async {
    var path = await getExternalStorageDirectory();
    String curTime = formatTime(pattern: 'yyyy-MM-dd');
    await _createBackupDir();
    var newFilePath = join(path.path, BACK_UP, '$curTime.db');
    var newFile = File(newFilePath);
    var newFileExists = await newFile.exists();
    var cnt = 1;
    while (newFileExists) {
      newFile = File(join(path.path, BACK_UP, '$curTime($cnt).db'));
      newFileExists = await newFile.exists();
      cnt++;
    }
    return newFile;
  }

  /// 获取 APK 数据库文件
  Future<File> _getDBFile() async {
    var path = await getApplicationDocumentsDirectory();
    var dbPath = join(path.parent.path, 'databases', DB_FILE);
    Logger.d(msg: 'path: ${path.parent.path} dbPath: ${dbPath}');
    return File(dbPath);
  }

  /// 创建备份文件夹
  Future<Directory> _createBackupDir() async {
    var path = await getExternalStorageDirectory();
    var backupDir = join(path.path, BACK_UP);
    var file = Directory(backupDir);
    file.createSync();
    return file;
  }
}
