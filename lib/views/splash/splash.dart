import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mark/manager/local_auth_manager.dart';
import 'package:mark/router/router.dart';
import 'package:mark/styles/colors.dart';
import 'package:mark/utils/logger.dart';
import 'package:mark/views/home/home.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';

class SplashPage extends StatefulWidget {
  static var routeName = '/splash';

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool _canClose = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1000), () {
      Logger.d(msg: 'request Permission');
      PermissionHandler()
          .checkPermissionStatus(PermissionGroup.storage)
          .then((value) {
        if (value == PermissionStatus.granted) {
          this._canClose = true;
        } else if (value == PermissionStatus.denied ||
            value == PermissionStatus.unknown) {
          PermissionHandler()
              .requestPermissions([PermissionGroup.storage]).then((value) {});
        }
      });
    }).then((value) {
      LocalAuthManager.getLocalAuthState().then((value) {
        print('生物识别 是否开启：===> ${value}');
        if (value) {
          // App 开启 生物识别
          LocalAuthManager().startAuth().then((authed) {
            print('生物识别 认证结果 ===> ${authed}');
            if (authed) {
              RouterUtils.pushNamedAndRemoveAll(context, HomePage.routeName);
            } else {
              // auth fail
              Toast.show("认证失败", context);
              // RouterUtils.pushNamedAndRemoveAll(context, HomePage.routeName);
            }
          });
        } else {
          RouterUtils.pushNamedAndRemoveAll(context, HomePage.routeName);
        }
      });
    });
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
