import 'package:flutter/material.dart';
import 'package:mark/router/router.dart';
import 'package:mark/views/splash/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mark',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
      routes: buildRoutes(),
      debugShowCheckedModeBanner: false,
    );
  }
}
