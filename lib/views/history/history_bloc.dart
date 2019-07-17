import 'package:mark/entity/record.dart';
import 'package:mark/repository/RecordRepository.dart';
import 'package:mark/utils/logger.dart';
import 'package:mark/utils/time_utils.dart';

import 'history_all.dart';

class HistoryBloc {
  static const String TAG = "HistoryBloc";

  final RecordRepository _repository = RecordRepository();

  /// 当前加载的数据的下个月份
  DateTime time;

  /// 刷新数据
  /// 获取当前月数据，不足 20 条的时候自动获取下个月数据, 不足 20 条继续获取下个月数据，依次类推
  Future<List<HistoryItem>> refresh() async {
    DateTime now = DateTime.now();

    List<HistoryItem> retList = List();
    int cnt = 0;
    while (cnt < 20) {
      List<RecordEntity> data =
          await _repository.getMonthData(now.year, now.month, now.day);
      HistoryMonthSummary monthSummary = createMonthSummary(data, now);

      // convert to list item
      HistoryItem item = HistoryItem(1, data: monthSummary);
      retList.add(item);
      var itemData = data.map((f) {
        return HistoryItem(2, data: f);
      }).toList();
      retList.addAll(itemData);

      cnt = data.length;
      now = getLastMonth(now);
      time = now;
    }
    return retList;
  }

  /// loadmore: 加载上个月的数据
  /// 不设置 最少/最多 下载数量
  Future<List<HistoryItem>> loadmore() async {
    Logger.d(tag: TAG, msg: 'load more month: ${time.month}');
    List<HistoryItem> retList = List();

    List<RecordEntity> data =
        await _repository.getMonthData(time.year, time.month, time.day);
    HistoryMonthSummary monthSummary = createMonthSummary(data, time);

    // convert to list item
    HistoryItem item = HistoryItem(1, data: monthSummary);
    retList.add(item);
    var itemData = data.map((f) {
      return HistoryItem(2, data: f);
    }).toList();
    retList.addAll(itemData);

    time = getLastMonth(time);
    return retList;
  }

  /// 计算出数据的 总支出/总收入
  HistoryMonthSummary createMonthSummary(
      List<RecordEntity> data, DateTime date) {
    HistoryMonthSummary ret = HistoryMonthSummary();
    ret.date = date;
    ret.expend = 0;
    ret.income = 0;
    for (var item in data) {
      if (item.typeSI == 'expenditure') {
        ret.expend += item.value ?? 0;
      } else {
        ret.income += item.value ?? 0;
      }
    }
    return ret;
  }

  dispose() {
    // _repository.closeDb();
  }
}
