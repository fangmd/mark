import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:mark/components/record_item.dart';
import 'package:path/path.dart';

Future<String> getImgFromType(BuildContext context, String type) async {
  final data = json.decode(await DefaultAssetBundle.of(context)
      .loadString("assets/data/record_item.json"));
  var list = RecordItemUIData.fromJson(data);

  var ret;
  list.forEach((v) {
    if (v.title == type) {
      ret = v.image;
    }
  });
  if (type == '其他') {
    ret = 'assets/images/record_item/other.png';
  }
  print("getImgFromType: " + ret);
  return ret;
}
