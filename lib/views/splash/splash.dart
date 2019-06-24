import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mark/router/router.dart';
import 'package:mark/styles/colors.dart';
import 'package:mark/views/home/home.dart';

class SplashPage extends StatelessWidget {
  static var routeName = '/splash';

  @override
  Widget build(BuildContext context) {
    Timer(Duration(milliseconds: 200), () {
      RouterUtils.pushNamedAndRemoveAll(context, HomePage.routeName);
    });

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
