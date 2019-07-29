import 'package:flutter/material.dart';
import 'package:mark/router/router.dart';
import 'package:mark/views/history/history_all.dart';
import 'package:mark/views/record/record.dart';
import 'package:mark/views/setting/setting.dart';

class BottomSettings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        InkWell(
          onTap: () {
            RouterUtils.pushNamed(context, HistoryAll.routeName);
          },
          child: Container(
            width: 40,
            child: Padding(
              padding: EdgeInsets.all(4.0),
              child: Image.asset('assets/images/home/ic-list.png'),
            ),
          ),
        ),
        InkWell(
          onTap: () {
            RouterUtils.pushNamed(context, RecordPage.routeName);
          },
          child: Image.asset("assets/images/add-item.png"),
        ),
        InkWell(
          onTap: () {
            RouterUtils.pushNamed(context, SettingPage.routeName);
          },
          child: Padding(
            padding: EdgeInsets.all(5.0),
            child: SizedBox(
              width: 26,
              height: 26,
              child: Image.asset("assets/images/setting.png"),
            ),
          ),
        ),
      ],
    );
  }
}
