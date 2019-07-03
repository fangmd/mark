import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mark/components/bottom_settings.dart';
import 'package:mark/entity/record.dart';
import 'package:mark/manager/file_manager.dart';
import 'package:mark/styles/colors.dart';
import 'package:mark/utils/logger.dart';
import 'package:mark/utils/project_utils.dart';
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

  @override
  void initState() {
    print('${new DateTime(2019, 6, 28, 1).toUtc().millisecondsSinceEpoch}');
    print('${new DateTime(2019, 6, 28, 23).toUtc().millisecondsSinceEpoch}');

    homeBloc.getMonthExpand().then((value) {
      Logger.d(msg: 'Value: $value');
      setState(() {
        this.monthExpend = value.toString();
      });
    }).catchError((error) {
      Logger.d(msg: '$error');
    });

    homeBloc.getDayExpend().then((value) {
      Logger.d(msg: 'Value: ${value[0]}');
      setState(() {
        this._dayExpend = value[0].toString();
        this._dayRecordEntity = _mergeAndSortData(value[1]);
      });

      Future.delayed(Duration.zero, () {
        print('Future delayed');
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            SizedBox(height: 20.0),
            DayWidget(
              dayExpend: _dayExpend,
              dayRecordEntity: _dayRecordEntity,
              dayRecordEntityImg: _dayRecordEntityImg,
            ),
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
            '本月支出',
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
}
