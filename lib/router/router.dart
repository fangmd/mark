import 'package:flutter/material.dart';
import 'package:mark/views/home/home.dart';
import 'package:mark/views/record/record.dart';
import 'package:mark/views/setting/setting.dart';
import 'package:mark/views/splash/splash.dart';

Map<String, WidgetBuilder> buildRoutes() {
  return {
    // '页面名称': (_) => LogPage(),
    SplashPage.routeName: (_) => SplashPage(),
    HomePage.routeName: (_) => HomePage(),
    SettingPage.routeName: (_) => SettingPage(),
    RecordPage.routeName: (_) => RecordPage(),
  };
}

///路由管理
class RouterUtils {
  ///暂时不能传参数
  static void pushNamed(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  /// 启动一个新的页面，并清理所有历史栈
  static void pushNamedAndRemoveAll(BuildContext context, String newRouteName) {
    Navigator.pushNamedAndRemoveUntil(context, newRouteName, (_) => false);
  }

  /// push 可以传参数
  static void push(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}
