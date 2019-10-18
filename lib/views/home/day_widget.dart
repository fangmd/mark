import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mark/entity/record.dart';
import 'package:mark/styles/colors.dart';
import 'package:mark/utils/logger.dart';
import 'package:mark/utils/project_utils.dart';

class DayWidget extends StatelessWidget {
  const DayWidget({
    Key key,
    @required String dayExpend,
    @required List<RecordEntity> dayRecordEntity,
    @required List<String> dayRecordEntityImg,
  })  : _dayExpend = dayExpend,
        _dayRecordEntity = dayRecordEntity,
        _dayRecordEntityImg = dayRecordEntityImg,
        super(key: key);

  final String _dayExpend;
  final List<RecordEntity> _dayRecordEntity;
  final List<String> _dayRecordEntityImg;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.0),
        color: Colors.white,
      ),
      height: 121, 
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                height: 16,
                width: 16,
                child: Image.asset('assets/images/home/today.png'),
              ),
              SizedBox(
                width: 10.0,
              ),
              Text(
                '今日支出',
                style: TextStyle(color: text_primary, fontSize: 14),
              ),
            ],
          ),
          Container(
            height: 60.0,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 6, right: 30),
                  child: Text(
                    '\$ $_dayExpend',
                    style: TextStyle(
                      color: text_green,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: _buildItems(),
                      ),
                      Row(
                        children: _buildItems2(),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildItems() {
    var list = <Widget>[];
    if (_dayRecordEntity.length > 0) {
      list.add(_getDayRecordItem(0));
    }

    if (_dayRecordEntity.length > 1) {
      list.add(SizedBox(
        width: 10.0,
      ));
      list.add(_getDayRecordItem(1));
    }
    return list;
  }

  List<Widget> _buildItems2() {
    var list = <Widget>[];
    if (_dayRecordEntity.length > 2) {
      list.add(_getDayRecordItem(2));
    }

    if (_dayRecordEntity.length > 3) {
      list.add(SizedBox(
        width: 10.0,
      ));
      list.add(_getDayRecordItem(3));
    }
    return list;
  }

  DayRecordItem _getDayRecordItem(index) {
    if (_dayRecordEntityImg.length > index) {
      return DayRecordItem(
        data: _dayRecordEntity[index],
        img: _dayRecordEntityImg[index],
      );
    } else {
      return DayRecordItem(
        data: _dayRecordEntity[index],
        img: 'assets/images/record_item/other.png',
      );
    }
  }
}

class DayRecordItem extends StatefulWidget {
  final RecordEntity data;
  final String img;

  const DayRecordItem({Key key, this.data, this.img}) : super(key: key);

  @override
  _DayRecordItemState createState() => _DayRecordItemState();
}

class _DayRecordItemState extends State<DayRecordItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      height: 26,
      decoration: BoxDecoration(
          color: bg_F3FCF1, borderRadius: BorderRadius.circular(13.0)),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            height: 10.0,
            child: Image.asset(
              widget.img,
              height: 10.0,
            ),
          ),
          Text(
            '-${widget.data.value}',
            style: TextStyle(
              color: text_green,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
