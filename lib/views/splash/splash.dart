import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mark/router/router.dart';
import 'package:mark/styles/colors.dart';
import 'package:mark/utils/logger.dart';
import 'package:mark/views/home/home.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashPage extends StatefulWidget {
  static var routeName = '/splash';

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _canClose = false;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Logger.d(msg: 'request Permission');
      PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage)
          .then((value) {
        if (value == PermissionStatus.granted) {
          this._canClose = true;
          RouterUtils.pushNamedAndRemoveAll(context, HomePage.routeName);
        } else if (value == PermissionStatus.denied ||
            value == PermissionStatus.unknown) {
          PermissionHandler()
              .requestPermissions([PermissionGroup.storage]).then((value) {
            RouterUtils.pushNamedAndRemoveAll(context, HomePage.routeName);
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Timer(Duration(milliseconds: 500), () {
    //   RouterUtils.pushNamedAndRemoveAll(context, HomePage.routeName);
    // });
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 30.0),
              child: Center(
                child: Text(
                  '马克',
                  style: TextStyle(fontSize: 20.0, color: text_black),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
