import 'package:shared_preferences/shared_preferences.dart';

class SPUtils {
  static Future<bool> getBool(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static setBool(String key, state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, state);
  }
}
