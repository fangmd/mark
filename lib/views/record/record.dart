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
  // selectedRecordItemUIData, selectedRecordItemUIDataInCome 同时存在是因为，无法在 Tab 切换的时候设置监听，设置了监听但是效果不好(监听是滞后的)
  RecordItemUIData selectedRecordItemUIData;
  RecordItemUIData selectedRecordItemUIDataInCome;
  List<RecordItemUIData> data = List<RecordItemUIData>();
  List<RecordItemUIData> _incomeData = List<RecordItemUIData>();

  var showKeyboard = false;
  String _currentTypeSI;
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

    final dataIncome = json.decode(await DefaultAssetBundle.of(context)
        .loadString("assets/data/income_item.json"));
    var listIncome = RecordItemUIData.fromJson(dataIncome);
    setState(() {
      this._incomeData = listIncome;
    });
  }

  @override
  Widget build(BuildContext context) {
    recordSetter = (RecordEntity record) {
      record.type = selectedRecordItemUIData.title;
      record.typeSI = this._currentTypeSI;
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
                  height: 46,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.arrow_back),
                        iconSize: 24,
                        color: Colors.black,
                      ),
                      Container(
                        height: 46,
                        width: 200,
                        child: TabBar(
                          indicatorColor: Colors.black,
                          tabs: <Widget>[
                            Container(
                              child: Text('支出',
                                  style: TextStyle(
                                      fontSize: 16, color: text_black)),
                            ),
                            Text('收入',
                                style:
                                    TextStyle(fontSize: 16, color: text_black)),
                          ],
                        ),
                      ),
                      SizedBox(width: 24),
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
    var gridView = GridView.builder(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      itemCount: _incomeData.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisSpacing: 10.0, crossAxisCount: 4),
      itemBuilder: (context, index) {
        return GestureDetector(
          child: RecordItem(data: _incomeData[index]),
          onTap: () {
            Logger.d(msg: 'select reocrd item: ${_incomeData[index].title}');
            for (var item in _incomeData) {
              item.selected = false;
            }
            _incomeData[index].selected = true;
            this.selectedRecordItemUIDataInCome = _incomeData[index];
            setState(() {
              showKeyboard = true;
              this._currentTypeSI = 'income';
            });
          },
        );
      },
    );
    return gridView;
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
              this._currentTypeSI = 'expenditure';
            });
          },
        );
      },
    );
    return gridView;
  }
}
