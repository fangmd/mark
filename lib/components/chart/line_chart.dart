import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:mark/components/chart/data.dart';
import 'package:mark/styles/colors.dart';

class LineChartPainter extends CustomPainter {
  final List<Point> data;
  YRange _yRange;
  double yUnit;
  double xUnit;
  double padding;

  /// x 轴坐标预留位置
  double axisWidth = 30;

  /// 绘制表哥区域的宽高
  double gHeight;
  double gWidth;

  /// x 轴坐标是否从 0 开始，true: 0, false: 动态
  bool setXAxisStartFromZero = false;

  /// data 需要按照 x 轴排列
  LineChartPainter(this.data) {
    _yRange = YRange();
    double min = 0;
    double max = 0;
    if (data.length > 0 && !setXAxisStartFromZero) {
      min = data[0].y;
    }
    for (var item in data) {
      min = min < item.y ? min : item.y;
      max = max > item.y ? max : item.y;
    }
    _yRange.min = min;
    _yRange.max = max;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (data == null || data.length <= 0) {
      return;
    }
    var height = size.height;
    var width = size.width;

    // add padding to canvas 15,
    padding = 16;
    gHeight = height - padding * 2;
    gWidth = width - padding * 2 - axisWidth;

    var paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.square;

    var linePaint = Paint()
      ..color = text_purple
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.square;

    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), paint);

    yUnit = gHeight / (_yRange.max - _yRange.min);
    xUnit = gWidth / (data.length - 1);

    // draw line
    drawLine(canvas, linePaint);

    // draw Max, Min Point
    Point max = getMax(data);
    Point min = getMin(data);
    drawPoint(max, canvas);
    drawPoint(min, canvas);

    // draw min, max Text
    // drawPointText(max, canvas, )

    // draw X axis
    var axisPaint = Paint()
      ..color = text_purple
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.square;
    Offset xBottom = Offset(0 + padding + 20, gHeight + padding + 6);
    Offset xTop = Offset(0 + padding + 20, 0 + padding - 6);
    canvas.drawLine(xBottom, xTop, axisPaint);

    // draw x axis Text
    double textHeight = 12;
    // draw min acis Text
    drawXText(min, canvas, Offset(padding - 14, gHeight + 6));
    drawXText(max, canvas, Offset(padding - 14, gHeight + 6 - yUnit * (_yRange.max - _yRange.min)));
  }

  /// draw graph line
  void drawLine(Canvas canvas, Paint linePaint) {
    Point first = data[0];
    Offset last = Offset(first.x * xUnit + padding + axisWidth,
        gHeight - (first.y - _yRange.min) * yUnit + padding);
    for (Point d in data) {
      canvas.drawLine(
          last,
          Offset(d.x * xUnit + padding + axisWidth,
              gHeight - (d.y - _yRange.min) * yUnit + padding),
          linePaint);
      last = Offset(d.x * xUnit + padding + axisWidth,
          gHeight - (d.y - _yRange.min) * yUnit + padding);

      drawPoint(d, canvas);
    }
  }

  @override
  bool shouldRepaint(LineChartPainter oldDelegate) {
    return oldDelegate.data != data;
  }

  /// 根据文本内容和字体大小等构建一段文本
  Paragraph buildParagraph(String text, double textSize, double constWidth) {
    ParagraphBuilder builder = ParagraphBuilder(
      ParagraphStyle(
        textAlign: TextAlign.right,
        fontSize: textSize,
        fontWeight: FontWeight.bold,
      ),
    );
    builder.pushStyle(ui.TextStyle(color: Colors.black));
    builder.addText(text);
    ParagraphConstraints constraints = ParagraphConstraints(width: constWidth);
    return builder.build()..layout(constraints);
  }

  /// get Max Point from data
  Point getMax(List<Point> data) {
    Point max = data[0];
    for (var d in data) {
      if (max.y <= d.y) {
        max = d;
      }
    }
    return max;
  }

  /// get Min Point from data
  Point getMin(List<Point> data) {
    Point min = data[0];
    for (var d in data) {
      if (min.y > d.y) {
        min = d;
      }
    }
    return min;
  }

  void drawPoint(Point point, Canvas canvas) {
    var pointPaint = Paint()
      ..color = text_purple
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.square;

    Offset offset = Offset(point.x * xUnit + padding + axisWidth,
        gHeight - (point.y - _yRange.min) * yUnit + padding);
    canvas.drawCircle(offset, 6, pointPaint);
  }

  void drawXText(Point min, Canvas canvas, Offset offset) {
    canvas.drawParagraph(buildParagraph('${min.y}', 12, 30), offset);
  }
}
