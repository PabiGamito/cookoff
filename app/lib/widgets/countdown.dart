import 'dart:async';

import 'package:cookoff/scalar.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

const int hoursInADay = 24;
const int minutesInAnHour = 60;
const int secondsInAMinute = 60;

class Countdown extends StatefulWidget {
  final DateTime _end;

  // Call this function when timer is negative
  final Function _callback;

  Countdown({@required DateTime end, Function callback})
      : _end = end,
        _callback = callback;

  @override
  State<StatefulWidget> createState() => _CountdownState(_end, _callback);
}

class _CountdownState extends State<Countdown> {
  final DateTime _end;
  TimeText _timeText = TimeText();
  Timer _updateTimer;
  Function _callback;

  _CountdownState(this._end, this._callback);

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

    if (_timeLeft.isNegative) {
      _callback?.call();
    }

    _timeText = TimeText(duration: _timeLeft);
  }

  @override
  Widget build(BuildContext context) => _timeText;
}

class TimeText extends StatelessWidget {
  final bool _showSeconds;
  final bool _showMinutes;
  final bool _showHours;
  final bool _showDays;
  final bool _isFinished;

  final List<int> _values = [0, 0, 0, 0];
  final List<String> _units = ['d', 'h', 'm', 's'];

  TimeText(
      {bool alwaysShowSeconds = false,
      bool alwaysShowMinutes = false,
      bool alwaysShowHours = false,
      bool alwaysShowDays = false,
      Duration duration})
      : _showSeconds = alwaysShowSeconds,
        _showMinutes = alwaysShowMinutes,
        _showHours = alwaysShowHours,
        _showDays = alwaysShowDays,
        _isFinished = duration?.isNegative {
    if (duration != null) {
      setDays(duration.inDays.round());
      setHours(duration.inHours.round() % hoursInADay);
      setMinutes(duration.inMinutes.round() % minutesInAnHour);
      setSeconds(duration.inSeconds.round() % secondsInAMinute);
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

    if (_isFinished) {
      return Text(
        'Done',
        style: TextStyle(
            color: Colors.white,
            fontSize: Scaler(context).scale(24),
            fontFamily: 'Montserrat'),
      );
    }

    int cnt = 0;
    for (int i = 0; i < _values.length; i++) {
      if ((showUnits[i] && _values[i] > 0) || (cnt < 2 && _values[i] > 0)) {
        cnt++;
        text.add(
          Text(
            _valueToString(_values[i]),
            style: TextStyle(
                color: Colors.white,
                fontSize: Scaler(context).scale(24),
                fontFamily: 'Montserrat'),
          ),
        );
        text.add(
          Text(
            _units[i].toString() + " ",
            style: TextStyle(
                color: Colors.white,
                fontSize: Scaler(context).scale(16),
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
