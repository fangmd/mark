import 'package:mark/utils/time_utils.dart';

class RecordEntity {
  int id; // db id
  DateTime createDate; // 账目创建时间
  DateTime recordDateTime; // 账目时间
  String type; // 账目类型TODO: 支持多个使用 & 分割
  double value; // 账目金额
  String comments; // 账目备注

  RecordEntity(
      {this.id,
      this.createDate,
      this.recordDateTime,
      this.type,
      this.value,
      this.comments});

  Map<String, dynamic> toMapDB() {
    var map = <String, dynamic>{
      'id': id,
      'createDate': createDate.millisecondsSinceEpoch,
      'recordDateTime': recordDateTime.millisecondsSinceEpoch,
      'type': type,
      'value': value,
      'comments': comments,
    };
    return map;
  }

  RecordEntity.fromMapDB(Map<String, dynamic> map) {
    id = map["id"];
    createDate = getDateTimeFromDB(map["createDate"]);
    recordDateTime = getDateTimeFromDB(map["recordDateTime"]);
    type = map["type"];
    value = map["value"];
    comments = map["comments"];
  }
}
