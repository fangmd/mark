import 'package:flutter/material.dart';
import 'package:mark/router/router.dart';
import 'package:mark/views/record/record.dart';
import 'package:mark/views/setting/setting.dart';

class BottomSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        SizedBox(
          width: 26,
        ),
        GestureDetector(
          onTap: () {
            RouterUtils.pushNamed(context, RecordPage.routeName);
          },
          child: Image.asset("assets/images/add-item.png"),
        ),
        GestureDetector(
          onTap: () {
            RouterUtils.pushNamed(context, SettingPage.routeName);
          },
          child: SizedBox(
            width: 26,
            height: 26,
            child: Image.asset("assets/images/setting.png"),
          ),
        ),
      ],
    );
  }
}
