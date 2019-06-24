import 'package:meta/meta.dart';

class Logger {
  static void d({tag: "Mark", @required String msg}) {
    print('$tag ===>> $msg');
  }
}
