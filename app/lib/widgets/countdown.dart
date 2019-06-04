import 'dart:async';

import 'package:cookoff/scalar.dart';
import 'package:flutter/material.dart';

const int hoursInADay = 24;
const int minutesInAnHour = 60;
const int secondsInAMinute = 60;

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
    var hours = _timeLeft.inHours % hoursInADay;
    var minutes = _timeLeft.inMinutes % minutesInAnHour;
    var seconds = _timeLeft.inSeconds % secondsInAMinute;

    _timeText.setDays(days);
    _timeText.setHours(hours);
    _timeText.setMinutes(minutes);
    _timeText.setSeconds(seconds);
  }

  @override
  Widget build(BuildContext context) => _timeText;
}

class TimeText extends StatelessWidget {
  final bool _showSeconds;
  final bool _showMinutes;
  final bool _showHours;
  final bool _showDays;

  List<int> _values = [0, 0, 0, 0];
  List<String> _units = ['d', 'h', 'm', 's'];

  TimeText(
      {bool alwaysShowSeconds = false,
      bool alwaysShowMinutes = false,
      bool alwaysShowHours = false,
      bool alwaysShowDays = false,
      Duration duration})
      : _showSeconds = alwaysShowSeconds,
        _showMinutes = alwaysShowMinutes,
        _showHours = alwaysShowHours,
        _showDays = alwaysShowDays {
    if (duration != null) {
      setDays(duration.inDays.round());
      setHours(duration.inHours.round() % 24);
      setMinutes(duration.inMinutes.round() % 60);
    }
  }

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

  String _valueToString(int val) {
    String res = '';

    if (val < 10) {
      res += '0';
    }

    res += val.toString();

    return res;
  }

  Widget getWidget(BuildContext context) {
    List<Widget> text = [];
    List<bool> showUnits = [_showDays, _showHours, _showMinutes, _showSeconds];

    if (_values.last < 0) {
      return Text(
        'Done',
        style: TextStyle(
            color: Colors.white,
            fontSize: Scalar(context).scale(24),
            fontFamily: 'Montserrat'),
      );
    }

    int cnt = 0;
    for (int i = 0; i < _values.length; i++) {
      if (showUnits[i] || (cnt < 2 && _values[i] > 0)) {
        cnt++;
        text.add(
          Text(
            _valueToString(_values[i]),
            style: TextStyle(
                color: Colors.white,
                fontSize: Scalar(context).scale(24),
                fontFamily: 'Montserrat'),
          ),
        );
        text.add(
          Text(
            _units[i].toString() + " ",
            style: TextStyle(
                color: Colors.white,
                fontSize: Scalar(context).scale(16),
                fontFamily: 'Montserrat'),
          ),
        );
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return getWidget(context);
  }
}
