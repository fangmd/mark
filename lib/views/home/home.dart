import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mark/components/bottom_settings.dart';
import 'package:mark/components/chart/data.dart';
import 'package:mark/components/chart/line_chart.dart';
import 'package:mark/entity/record.dart';
import 'package:mark/styles/colors.dart';
import 'package:mark/styles/styles.dart';
import 'package:mark/utils/logger.dart';
import 'package:mark/utils/project_utils.dart';
import 'package:mark/utils/time_utils.dart';
import 'package:mark/views/home/home_bloc.dart';
import 'day_widget.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc homeBloc = HomeBloc();
  var monthExpend = "";
  var _dayExpend = "";
  var _dayRecordEntity = List<RecordEntity>();
  var _dayRecordEntityImg = List<String>();
  List<Point> _weekDatas = List<Point>();

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

    homeBloc.getDayExpend().then((value) {
      setState(() {
        this._dayExpend = value[0].toString();
        this._dayRecordEntity = _mergeAndSortData(value[1]);
      });

      Future.delayed(Duration.zero, () {
        var imgList = List<String>();
        this._dayRecordEntity.forEach((v) {
          getImgFromType(context, v.type).then((img) {
            imgList.add(img);
            if (this._dayRecordEntity.length == imgList.length) {
              setState(() {
                this._dayRecordEntityImg = imgList;
              });
            }
          });
        });
      });
    }).catchError((error) {
      Logger.d(msg: '$error');
    });

    homeBloc.getWeekPoint().then((value) {
      setState(() {
        this._weekDatas = value;
      });
    }).catchError((error) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: scaffold,
    );
    // return scaffold;
  }

  _buildBg() {
    return Positioned(
      child: Image.asset('assets/images/home_bg.png'),
    );
  }

  _buildBody(BuildContext context) {
    return Positioned(
      top: 40,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        child: ListView(
          children: <Widget>[
            _buildTime(),
            _buildSummary(),
            SizedBox(height: 20.0),
            DayWidget(
              dayExpend: _dayExpend,
              dayRecordEntity: _dayRecordEntity,
              dayRecordEntityImg: _dayRecordEntityImg,
            ),
            _buildGraph(),
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
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '本月',
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

  List<RecordEntity> _mergeAndSortData(List<RecordEntity> value) {
    // merge
    Map<String, RecordEntity> map = new Map<String, RecordEntity>();
    value.forEach((value) {
      var val = map[value.type];
      if (val != null) {
        val.value += value.value;
      } else {
        val = value;
        map[val.type] = val;
      }
    });

    // sort
    List<RecordEntity> source = map.values.toList();
    for (var i = 0; i < source.length; i++) {
      for (var j = i + 1; j < source.length; j++) {
        if (source[i].value < source[j].value) {
          var temp = source[i];
          source[i] = source[j];
          source[j] = temp;
        }
      }
    }

    // 合并除了前3之外的值
    if (source.length > 3) {
      var other = new RecordEntity();
      other.type = '其他';
      other.value = 0.0;
      for (var i = 3; i < source.length; i++) {
        other.value += source[i].value;
      }
      source = source.sublist(0, 3);
      source.add(other);
    }

    return source;
  }

  Widget _buildTime() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 20),
      child: Text(formatTime(pattern: 'MM/dd'), style: AppTheme.pageTitle),
    );
  }

  Widget _buildGraph() {
    // List<Point> data = List<Point>();
    // for (var i = 0; i < 30; i++) {
    //   if (i % 7 == 0) {
    //     data.add(Point(x: i, y: 0));
    //   } else {
    //     data.add(Point(x: i, y: 55));
    //   }
    // }

    return Container(
      padding: EdgeInsets.only(left: 0, right: 0, bottom: 20),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          Container(
            height: 40,
            child: Row(
              children: <Widget>[
                SizedBox(width: 20.0),
                Image.asset(
                  'assets/images/home/statistics.png',
                  width: 16,
                  height: 16,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: 10.0),
                Text('图表', style: AppTheme.home_card_title),
                Expanded(child: SizedBox()),
                Text('本周', style: AppTheme.home_card_title),
                SizedBox(width: 16)
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 220,
            child: CustomPaint(
              painter: LineChartPainter(_weekDatas),
            ),
          ),
        ],
      ),
    );
  }
}
