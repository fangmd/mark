import 'package:flutter/material.dart';
import 'package:mark/entity/record.dart';
import 'package:mark/styles/colors.dart';
import 'package:mark/utils/convert_utils.dart';
import 'package:mark/utils/logger.dart';
import 'package:mark/utils/time_utils.dart';

typedef OnCancel = void Function();

class Keyboard extends StatefulWidget {
  final ValueSetter<RecordEntity> recordSetter;
  final OnCancel onCancel;

  Keyboard({Key key, this.recordSetter, this.onCancel}) : super(key: key);

  _KeyboardState createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {
  var inputValueStr = '0.00';
  var time = new DateTime.now();
  var comment = '';
  var showNumberboard = true;
  var stateText = 'Cancel'; // Cancel/OK Button

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    final double itemHeight = 60;
    final double itemWidth = screen.width / 4;

    Logger.d(msg: formatTime(date: time));

    return Container(
      color: bg_F3F6FB,
      height: showNumberboard ? itemHeight * 4 + 46 : 46,
      child: Column(
        children: <Widget>[
          _buildDisplay(),
          Expanded(
            child: Visibility(
              child: buildKeyboard(itemWidth, itemHeight),
              visible: showNumberboard,
            ),
          ),
        ],
      ),
    );
  }

  GridView buildKeyboard(double itemWidth, double itemHeight) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      controller: ScrollController(keepScrollOffset: false),
      childAspectRatio: itemWidth / itemHeight,
      children: <Widget>[
        _createButton('7'),
        _createButton('8'),
        _createButton('9'),
        _createButton('今天'),
        _createButton('4'),
        _createButton('5'),
        _createButton('6'),
        _createButton(''), //+
        _createButton('1'),
        _createButton('2'),
        _createButton('3'),
        _createButton(''), //-
        _createButton('.'),
        _createButton('0'),
        _createButton('del'),
        _createButton(stateText),
      ],
    );
  }

  Widget _createButton(String text) {
    return GestureDetector(
      onTap: () {
        _handleKeyboard(text);
      },
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDisplay() {
    return Container(
      color: white_02,
      height: 46,
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              print('icon click');
            },
            child: Padding(
              padding: EdgeInsets.only(left: 12, right: 12),
              child: Image.asset(
                'assets/images/mark.png',
                scale: 2,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              onChanged: (value) {
                comment = value;
              },
              decoration: InputDecoration(
                hintText: '输入备注...',
                hintStyle: TextStyle(fontSize: 16),
                border: InputBorder.none,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Text(
              inputValueStr,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  _handleKeyboard(String text) {
    var newValue;
    if (isNumeric(text)) {
      if (!(converStrToDouble(inputValueStr) == 0)) {
        newValue = inputValueStr + text;
      } else {
        newValue = text;
      }
    } else {
      switch (text) {
        case 'OK':
          if (this.widget.recordSetter != null) {
            var record = RecordEntity();
            record.recordDateTime = this.time;
            record.comments = this.comment;
            record.createDate = this.time;
            record.value = converStrToDouble(this.inputValueStr);
            this.widget.recordSetter(record);
          }
          break;
        case 'Cancel':
          if (this.widget.onCancel != null) {
            this.widget.onCancel();
          }
          break;
        case 'del':
          newValue = 0.0;
          break;
        case '.':
          if (!inputValueStr.contains('.')) {
            newValue = inputValueStr + text;
          }
          break;
        case '+':
          break;
        case '-':
          break;
        default:
          break;
      }
    }

    Logger.d(tag: 'Keyboard newValue:', msg: newValue.toString());
    if (newValue != null) {
      setState(() {
        inputValueStr = newValue.toString();
      });
    }
    _updateStateText();
  }

  void _updateStateText() {
    var value = converStrToDouble(this.inputValueStr);
    this.stateText = value != 0 ? 'OK' : 'Cancel';
  }
}
