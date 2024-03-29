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
  double padding = 14;
  double yTextWidth = 28; //

  /// x 轴坐标预留位置
  double axisWidth = 35;

  /// 绘制表哥区域的宽高
  double gHeight;
  double gWidth;

  /// 控件的宽高
  double height;
  double width;

  /// x 轴坐标是否从 0 开始，true: 0, false: 动态
  bool setXAxisStartFromZero = true;

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
    height = size.height;
    width = size.width;

    // add padding to canvas 15,
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

    if (data.length <= 1) {
      yUnit = gHeight / (_yRange.max * 2);
      xUnit = 0;
    } else {
      yUnit = gHeight / (_yRange.max - _yRange.min);
      xUnit = gWidth / (data.length - 1);
    }

    // draw line
    drawLineAndPoint(canvas, linePaint);

    // draw Max, Min Point
    Point max = getMax(data);
    Point min = getMin(data);
    // drawPoint(max, canvas);
    // drawPoint(min, canvas);

    // draw min, max Text
    // drawPointText(max, canvas, )

    // draw Y axis
    var axisPaint = Paint()
      ..color = text_purple
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.square;
    Offset xBottom = Offset(0 + padding + yTextWidth, gHeight + padding + 6);
    Offset xTop = Offset(0 + padding + yTextWidth, 0 + padding - 6);
    canvas.drawLine(xBottom, xTop, axisPaint);

    // draw x axis Text
    double textHeight = 12;
    // draw min acis Text
    drawXText(min, canvas, Offset(padding - 4, gHeight + 6));
    Point mid = Point(y: ((_yRange.max + _yRange.min) / 2));
    drawXText(
        mid,
        canvas,
        Offset(padding - 4,
            gHeight + 6 - yUnit * ((_yRange.max - _yRange.min) / 2)));
    drawXText(max, canvas,
        Offset(padding - 4, gHeight + 6 - yUnit * (_yRange.max - _yRange.min)));

    // Test:
    // drawPadding(canvas);
  }

  /// draw graph line
  void drawLineAndPoint(Canvas canvas, Paint linePaint) {
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
    Point min = Point(x: 0, y: 0, xText: '0.0', yText: '0.00');
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
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.square;

    Offset offset = Offset(point.x * xUnit + padding + axisWidth,
        gHeight - (point.y - _yRange.min) * yUnit + padding);
    canvas.drawCircle(offset, 5, pointPaint);
  }

  void drawXText(Point min, Canvas canvas, Offset offset) {
    canvas.drawParagraph(
        buildParagraph('${min.y.toInt()}', 10, yTextWidth), offset);
  }

  void drawPadding(Canvas canvas) {
    var pointPaint = Paint()
      ..color = text_purple
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.square;

    // canvas.drawRect(Rect.fromLTRB(0, 0, width, height), pointPaint);

    canvas.drawLine(Offset(padding, padding), Offset(padding, height - padding),
        pointPaint);
    canvas.drawLine(Offset(padding, height - padding),
        Offset(width - padding, height - padding), pointPaint);
    canvas.drawLine(Offset(width - padding, height - padding),
        Offset(width - padding, padding), pointPaint);
    canvas.drawLine(
        Offset(width - padding, padding), Offset(padding, padding), pointPaint);
  }
}
