import 'dart:io';

import 'package:path/path.dart';

class BackupDbFileEntity {
  String name;
  File file;
  bool isSelected = false;

  BackupDbFileEntity(this.file) {
    this.name = basename(this.file.path);
  }
}
