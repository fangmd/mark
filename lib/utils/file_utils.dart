import 'dart:io';

import 'package:mark/utils/logger.dart';
import 'package:path_provider/path_provider.dart';

Future<bool> copyFile(String oldFile, String newFile) async {
  File oldF = File(oldFile);
  File newF = File(newFile);
  if (!oldF.existsSync()) {
    throw 'Old File not exists';
  }
  if (newF.existsSync()) {
    throw 'New File Exists. Can not copy to newFile';
  }
  await oldF.copy(newFile);
  return true;
}
