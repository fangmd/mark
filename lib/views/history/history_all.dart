import 'package:flutter/material.dart';
import 'package:mark/components/record_img.dart';
import 'package:mark/entity/record.dart';
import 'package:mark/styles/colors.dart';
import 'package:mark/utils/project_utils.dart';
import 'package:mark/utils/time_utils.dart';
import 'package:mark/views/history/history_bloc.dart';

class HistoryAll extends StatefulWidget {
  static const routeName = '/history-all';

  HistoryAll({Key key}) : super(key: key);

  _HistoryAllState createState() => _HistoryAllState();
}

class _HistoryAllState extends State<HistoryAll> {
  HistoryBloc bloc = HistoryBloc();
  List<HistoryItem> items;
  Map<String, String> imgMap = Map();
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      getImgFromTypeMap(context).then((value) {
        setState(() {
          this.imgMap = value;
        });
      });
    });

    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;

      if (maxScroll == pixels) {
        print('load more');
        bloc?.loadmore()?.then((value) {
          setState(() {
            items.addAll(value);
          });
        });
      }
    });

    items = List<HistoryItem>();
    _refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: SafeArea(
          child: Container(
            child: _buildList(context),
          ),
        ),
      ),
    );
  }

  _buildList(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildHeader(context),
        Expanded(
          child: RefreshIndicator(
            child: ListView.builder(
              controller: _controller,
              itemCount: items.length,
              itemBuilder: (context, index) {
                var data = items[index];
                switch (items[index].type) {
                  case 1:
                    return _buildItemHeader(data);
                  case 2:
                    return _buildItem(data);
                  default:
                }
                return Text('Error');
              },
            ),
            onRefresh: _refresh,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back),
            iconSize: 24,
            color: Colors.black),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
          child: Text('流水',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildItemHeader(HistoryItem data) {
    return Container(
      height: 50,
      color: white_02,
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            sameMonth(data.data.date, DateTime.now())
                ? '本月'
                : '${data.data.date.month}月',
            style: TextStyle(color: text_black, fontSize: 14),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '支出 \$${data.data.expend}',
                style: TextStyle(color: text_9C9B97, fontSize: 12),
              ),
              Text(
                '收入 \$${data.data.income}',
                style: TextStyle(color: text_9C9B97, fontSize: 12),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildItem(HistoryItem data) {
    return Container(
      height: 68,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RecordImg(
                    img: imgMap[data.data.type] ??
                        'assets/images/record_item/other.png',
                    imgSize: 14,
                    size: 28),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      data.data.comments != ''
                          ? data.data.type + ' - ' + data.data.comments
                          : data.data.type,
                      style: TextStyle(fontSize: 14, color: text_hint),
                    ),
                    SizedBox(height: 10),
                    Text(
                      formatTimeForHistory(data.data.recordDateTime),
                      style: TextStyle(fontSize: 14, color: text_9C9B97),
                    ),
                  ],
                ),
                Expanded(child: SizedBox()),
                Text(
                    data.data.typeSI == 'expenditure'
                        ? '-${data.data.value}'
                        : '+${data.data.value}',
                    style: TextStyle(
                      fontSize: 16,
                      color: data.data.typeSI == 'expenditure'
                          ? text_black
                          : text_green,
                      fontWeight: FontWeight.bold,
                    ))
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 50,
            child: Container(
              height: 1.0,
              decoration: BoxDecoration(color: bg_divide),
            ),
          )
        ],
      ),
    );
  }

  Future<Null> _refresh() async {
    var value = await bloc.refresh();
    setState(() {
      items.addAll(value);
    });
    return null;
  }
}

class HistoryItem {
  final int type; // 0: header, 1: item_header, 2 item
  dynamic data; //  null, HistoryMonthSumary, RecordEntity

  HistoryItem(this.type, {this.data});
}

class HistoryMonthSummary {
  DateTime date;
  double income;
  double expend;
}
