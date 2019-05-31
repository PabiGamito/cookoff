import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Countdown extends StatefulWidget {
  final DateTime _end;

  Countdown(DateTime end) : _end = end;

  @override
  State<StatefulWidget> createState() => _CountdownState(_end);
}

class _CountdownState extends State<Countdown> {
  final DateTime _end;
  TimeText _timeText = TimeText();
  Timer _updateTimer;

  _CountdownState(this._end);

  @override
  void initState() {
    super.initState();

    updateTimeText();

    _updateTimer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        updateTimeText();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    _updateTimer.cancel();
  }

  void updateTimeText() {
    var _timeLeft = _end.difference(DateTime.now());

    var days = _timeLeft.inDays;
    var hours = _timeLeft.inHours - _timeLeft.inDays * 24;
    var minutes = _timeLeft.inMinutes - hours * 60 - days * 24 * 60;
    var seconds = _timeLeft.inSeconds -
        minutes * 60 -
        hours * 60 * 60 -
        days * 24 * 60 * 60;

    _timeText.setDays(days);
    _timeText.setHours(hours);
    _timeText.setMinutes(minutes);
    _timeText.setSeconds(seconds);
  }

  @override
  Widget build(BuildContext context) => _timeText.getWidget();
}

class TimeText {
  List<int> _values = [0, 0, 0, 0];
  List<String> _units = ['d', 'h', 'm', 's'];

  void setDays(int days) {
    _values[0] = days;
  }

  void setHours(int hours) {
    _values[1] = hours;
  }

  void setMinutes(int minutes) {
    _values[2] = minutes;
  }

  void setSeconds(int seconds) {
    _values[3] = seconds;
  }

  Widget getWidget() {
    List<Widget> text = [];

    if (_values.last < 0) {
      return Text(
        'Done',
        style: TextStyle(
            color: Colors.white, fontSize: 24, fontFamily: 'Montserrat'),
      );
    }

    int cnt = 0;
    for (int i = 0; i < _values.length; i++) {
      if (cnt < 2 && _values[i] > 0) {
        text.add(
          Text(
            _values[i].toString(),
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontFamily: 'Montserrat'),
          ),
        );
        text.add(
          Text(
            _units[i].toString() + " ",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontFamily: 'Montserrat'),
          ),
        );
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: text,
    );
  }
}
