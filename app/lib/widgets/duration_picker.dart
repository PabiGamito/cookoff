//a date&time picker model
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class DurationPicker extends StatelessWidget {
  final Function _onDurationChange;
  final Widget _child;

  DurationPicker({
    Duration duration,
    Color bgColor,
    Function onDurationChange,
    Widget child,
  })  : _onDurationChange = onDurationChange,
        _child = child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        DatePicker.showPicker(
          context,
          pickerModel: _DurationPickerModel(),
          onConfirm: _onDurationChange,
        );
      },
      child: _child,
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
      this.minMinutes = 30})
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
    return DateTime(0, 0, currentLeftIndex(), currentMiddleIndex(),
        currentRightIndex(), 0, 0);
  }

  @override
  List<int> layoutProportions() {
    return [1, 1, 1];
  }
}
