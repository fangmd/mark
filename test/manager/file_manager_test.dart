import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mark/main.dart';
import 'package:mark/manager/file_manager.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  testWidgets('getExternalStorageDirectory() test',
      (WidgetTester tester) async {
    // await tester.pumpWidget(MyApp());
    await FileManager().backupDB();
    print('sd');
    expect(1, 1);
  });
}
