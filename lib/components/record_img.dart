import 'package:flutter/material.dart';
import 'package:mark/styles/colors.dart';

class RecordImg extends StatefulWidget {
  final String img;
  final Color bgColor;
  final double size;
  final double imgSize;

  RecordImg({
    Key key,
    @required this.img,
    this.bgColor = green_02,
    this.size = 24.0,
    this.imgSize = 12.0,
  }) : super(key: key);

  _RecordImgState createState() => _RecordImgState();
}

class _RecordImgState extends State<RecordImg> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size,
      width: widget.size,
      decoration: BoxDecoration(
        color: widget.bgColor,
        borderRadius: BorderRadius.circular(widget.size / 2),
      ),
      child: Center(
        child: Image.asset(
          widget.img,
          width: widget.imgSize,
          height: widget.imgSize,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
