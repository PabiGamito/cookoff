//a date&time picker model
import 'package:cookoff/scalar.dart';
import 'package:cookoff/widgets/countdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class DurationPicker extends StatelessWidget {
  final Function _onDurationChange;
  final Color _bgColor;

  final Duration _duration;

  DurationPicker({
    Duration duration,
    Color bgColor,
    Function onDurationChange,
  })  : _duration = duration ?? Duration(days: 1),
        _onDurationChange = onDurationChange,
        _bgColor = bgColor;

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    const List<bool> _showAllButSecs = [true, true, true, false];
    return GestureDetector(
      onTap: () {
        DatePicker.showPicker(
          context,
          pickerModel: _DurationPickerModel(),
          onConfirm: _onDurationChange,
        );
      },
      child: Center(
        child: Container(
          width: mediaSize.width * 0.4,
          padding: EdgeInsets.only(
            left: mediaSize.width * 0.04,
            top: Scalar(context).scale(5),
            bottom: Scalar(context).scale(5),
          ),
          decoration: BoxDecoration(
            color: Color.lerp(_bgColor, Colors.black45, 0.3),
            borderRadius:
                BorderRadius.all(Radius.circular(Scalar(context).scale(5))),
          ),
          child: Center(
            child: TimeText(
              duration: _duration,
              alwaysShowDays: true,
              alwaysShowMinutes: true,
              alwaysShowHours: true,
            ),
          ),
        ),
      ),
    );
  }
}

class _DurationPickerModel extends CommonPickerModel {
  int maxDays;
  int minMinutes;

  _DurationPickerModel(
      {DateTime currentTime,
      LocaleType locale,
      this.maxDays = 30,
      this.minMinutes = 15})
      : super(locale: locale) {
    setLeftIndex(1);
    setMiddleIndex(0);
    setRightIndex(0);
  }

  String _localeDays(int index) {
    return index != 1 ? 'days' : 'day';
  }

  String _localeHours(int index) {
    return index != 1 ? 'hours' : 'hour';
  }

  String _localeMinutes(int index) {
    return 'min';
  }

  @override
  void setLeftIndex(index) {
    super.setLeftIndex(index);
    if (index == 0 && currentMiddleIndex() == 0) {
      setRightIndex(minMinutes);
    }
  }

  @override
  void setMiddleIndex(index) {
    super.setMiddleIndex(index);
    if (index == 0 && currentLeftIndex() == 0) {
      setRightIndex(minMinutes);
    }
  }

  @override
  String leftStringAtIndex(int index) {
    if (index >= 0 && index <= maxDays) {
      return "${index.toString()} ${_localeDays(index)}";
    }
    return null;
  }

  @override
  String middleStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return "${index.toString()} ${_localeHours(index)}";
    } else {
      return null;
    }
  }

  @override
  String rightStringAtIndex(int index) {
    if (currentLeftIndex() > 0 || currentMiddleIndex() > 0) {
      if (index >= 0 && index < 60) {
        return "${index.toString()} ${_localeMinutes(index)}";
      }
    } else if (index >= minMinutes && index < 60) {
      return "${index.toString()} ${_localeMinutes(index)}";
    }
    return null;
  }

  @override
  DateTime finalTime() {
    return DateTime(0, 0, currentLeftIndex() + 1, currentMiddleIndex(),
        currentRightIndex(), 0, 0);
  }

  @override
  List<int> layoutProportions() {
    return [1, 1, 1];
  }
}
