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
  String _timeValue;
  String _timeValueUnit;
  String _timeValueAlt;
  String _timeValueAltUnit;
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
    _timeValue = timeText()[0][0];
    _timeValueUnit = timeText()[1][0];
    _timeValueAlt = timeText()[0][1];
    _timeValueAltUnit = timeText()[1][1];
  }

  List<List<String>> timeText() {
    var _timeLeft = _end.difference(DateTime.now());

    if (_timeLeft.inSeconds < 0) {
      if (_updateTimer != null) {
        _updateTimer.cancel();
      }

      return [
        ['Done', ''],
        ['', '']
      ];
    }

    int valueCnt = 0;

    var values = List<String>();
    var units = List<String>();

    var days = _timeLeft.inDays;
    if (days > 0) {
      units.add('d');
      values.add(_timeLeft.inDays.toString());
      valueCnt++;
    }

    var hours = _timeLeft.inHours - _timeLeft.inDays * 24;
    if (hours > 0) {
      units.add('h');
      values.add(hours.toString());
      valueCnt++;
    }

    var minutes = _timeLeft.inMinutes - hours * 60 - days * 24 * 60;

    if (valueCnt < 2 && minutes > 0) {
      units.add('m');
      values.add(minutes.toString());
      valueCnt++;
    }

    var seconds = _timeLeft.inSeconds -
        minutes * 60 -
        hours * 60 * 60 -
        days * 24 * 60 * 60;
    if (valueCnt < 2 && seconds > 0) {
      units.add('s');
      values.add(seconds.toString());
      valueCnt++;
    }

    var res = List<List<String>>();

    res.add(values);
    res.add(units);

    return res;
  }

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            _timeValue ?? '',
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontFamily: 'Montserrat'),
          ),
          Text(
            (_timeValueUnit ?? '') + " ",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontFamily: 'Montserrat'),
          ),
          Text(
            _timeValueAlt ?? '',
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontFamily: 'Montserrat'),
          ),
          Text(
            _timeValueAltUnit ?? '',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontFamily: 'Montserrat'),
          ),
        ],
      );
}
