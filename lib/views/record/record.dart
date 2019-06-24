import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mark/components/keyboard.dart';
import 'package:mark/components/record_item.dart';
import 'package:mark/entity/record.dart';
import 'package:mark/styles/colors.dart';
import 'package:mark/utils/logger.dart';
import 'package:mark/views/record/record_bloc.dart';

class RecordPage extends StatefulWidget {
  static const routeName = '/record';

  RecordPage({Key key}) : super(key: key);

  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  RecordBloc recordBloc = RecordBloc();

  final controller = PageController(
    initialPage: 0,
  );
  RecordItemUIData selectedRecordItemUIData;
  List<RecordItemUIData> data = List<RecordItemUIData>();

  var showKeyboard = false;
  ValueSetter<RecordEntity> recordSetter;
  OnCancel onCancel;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {
    final data = json.decode(await DefaultAssetBundle.of(context)
        .loadString("assets/data/record_item.json"));
    var list = RecordItemUIData.fromJson(data);
    setState(() {
      this.data = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    recordSetter = (RecordEntity record) {
      record.type = selectedRecordItemUIData.title;
      recordBloc.saveRecord(record).then((value) {
        Logger.d(msg: "save record success");
        Navigator.pop(context);
      }).catchError((error) {
        Logger.d(msg: "save record Fail: $error");
      });
    };
    onCancel = () {
      Navigator.pop(context);
    };

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Container(
          color: green_02,
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Container(
                  height: 40,
                  child: TabBar(
                    indicatorColor: Colors.black,
                    tabs: <Widget>[
                      Text('支出',
                          style: TextStyle(fontSize: 16, color: text_black)),
                      Text('收入',
                          style: TextStyle(fontSize: 16, color: text_black)),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: TabBarView(
                      children: <Widget>[
                        buildExpenditure(),
                        buildIncome(),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  child: Keyboard(
                    recordSetter: this.recordSetter,
                    onCancel: this.onCancel,
                  ),
                  visible: showKeyboard,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  GridView buildIncome() {
    return GridView.count(
      primary: false,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      crossAxisSpacing: 10.0,
      crossAxisCount: 4,
      children: <Widget>[
        RecordItem(
            data: RecordItemUIData(
                title: '长辈', image: 'assets/images/record_item/zhangbei.png')),
      ],
    );
  }

  GridView buildExpenditure() {
    var gridView = GridView.builder(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      itemCount: data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 10.0, crossAxisCount: 4),
      itemBuilder: (context, index) {
        return GestureDetector(
          child: RecordItem(data: data[index]),
          onTap: () {
            Logger.d(msg: 'select reocrd item: ${data[index].title}');
            for (var item in data) {
              item.selected = false;
            }
            data[index].selected = true;
            this.selectedRecordItemUIData = data[index];
            setState(() {
              showKeyboard = true;
            });
          },
        );
      },
    );
    return gridView;
  }
}
