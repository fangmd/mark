import 'package:flutter/material.dart';
import 'package:mark/styles/colors.dart';
import 'package:mark/utils/logger.dart';

class RecordItemUIData {
  String image;
  String title;
  bool selected;

  RecordItemUIData({this.image, this.title, this.selected = false});

  static List<RecordItemUIData> fromJson(List<dynamic> jsonList) {
    List<RecordItemUIData> ret = List<RecordItemUIData>();
    for (var item in jsonList) {
      ret.add(new RecordItemUIData(image: item['image'], title: item['title']));
    }
    Logger.d(msg: 'read record from json size: ${ret.length}');
    return ret;
  }
}

class RecordItem extends StatelessWidget {
  final RecordItemUIData data;

  const RecordItem({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: data.selected ? green_02 : white_02,
            borderRadius: BorderRadius.circular(23),
          ),
          child: Image.asset(
            data.image,
            height: 23,
            scale: 2,
          ),
        ),
        Text(
          data.title,
          style: TextStyle(),
        )
      ],
    );
  }
}
