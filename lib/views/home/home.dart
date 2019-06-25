import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mark/components/bottom_settings.dart';
import 'package:mark/manager/file_manager.dart';
import 'package:mark/styles/colors.dart';
import 'package:mark/utils/logger.dart';
import 'package:mark/views/home/home_bloc.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc homeBloc = HomeBloc();
  var monthExpend = "";

  @override
  void initState() {
    homeBloc.getMonthExpand().then((value) {
      Logger.d(msg: 'Value: $value');
      setState(() {
        this.monthExpend = value.toString();
      });
    }).catchError((error) {
      Logger.d(msg: '$error');
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Logger.d(msg: 'build--');
    return Scaffold(
      body: Container(
        constraints: BoxConstraints(minHeight: double.infinity),
        child: Stack(
          children: <Widget>[
            _buildBg(),
            _buildBody(context),
            _buildBottom(),
          ],
        ),
      ),
    );
  }

  _buildBg() {
    return Positioned(
      child: Image.asset('assets/images/home_bg.png'),
    );
  }

  _buildBody(BuildContext context) {
    return Positioned(
      top: 90,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        child: ListView(
          padding: EdgeInsets.all(0.0),
          children: <Widget>[
            _buildSummary(),
          ],
        ),
      ),
    );
  }

  _buildSummary() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.0),
        color: Colors.white,
      ),
      height: 120,
      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '本月花费',
            style: TextStyle(color: text_purple, fontSize: 14),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              '\$ $monthExpend',
              style: TextStyle(
                color: text_green,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildBottom() {
    return Positioned(
      height: 60,
      left: 0,
      right: 0,
      bottom: 10,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          child: BottomSettings(),
        ),
      ),
    );
  }
}
