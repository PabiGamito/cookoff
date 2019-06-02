import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class VerticalScrollable extends StatefulWidget {
  final Widget _child;
  final double _maxHeight;
  final double _minHeight;

  // Callback variable that updates based on scroll
  final double _startingHeightOffset;

  // Callback function when reached max scroll height
  Function _onTopScrollLimit;

  VerticalScrollable(
      {@required double startingHeightOffset,
      double maxHeight = 200,
      double minHeight = 100,
      Function onScrollLimit,
      Widget child})
      : _startingHeightOffset = startingHeightOffset,
        _minHeight = minHeight,
        _maxHeight = maxHeight,
        _onTopScrollLimit = onScrollLimit,
        _child = child;

  @override
  State<StatefulWidget> createState() => _ScrollableState(
      maxHeight: _maxHeight,
      minHeight: _minHeight,
      startingHeightOffset: _startingHeightOffset,
      onScrollLimit: _onTopScrollLimit,
      child: _child);
}

class _ScrollableState extends State<VerticalScrollable> {
  Widget _child;
  double _maxHeight;
  double _currentHeightOffset;
  double _minHeight;

  Function _onTopScrollLimit;

  double _dragPos;

  _ScrollableState(
      {@required double startingHeightOffset,
      double maxHeight = 200,
      double minHeight = 100,
      Function onScrollLimit,
      Widget child})
      : _currentHeightOffset = startingHeightOffset,
        _minHeight = minHeight,
        _maxHeight = maxHeight,
        _onTopScrollLimit = onScrollLimit,
        _child = child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height + _maxHeight,
      width: MediaQuery.of(context).size.width,

      // Translates the child widget to the initial height set, grows based on scroll height
      transform: Matrix4.translationValues(0, -_currentHeightOffset, 0),
      child: GestureDetector(
        onPanStart: (DragStartDetails details) {
          _dragPos = details.globalPosition.dy;
        },
        onPanUpdate: (DragUpdateDetails details) {
          var _change = details.globalPosition.dy - _dragPos;
          var _newHeightOffset = _currentHeightOffset - _change;

          if (_newHeightOffset > _maxHeight) {
            setState(() {
              _currentHeightOffset = _maxHeight;
              if (_onTopScrollLimit != null) _onTopScrollLimit();
            });
          } else if (_newHeightOffset < _minHeight) {
            setState(() {
              _currentHeightOffset = _minHeight;
            });
          } else {
            setState(() {
              _currentHeightOffset = _newHeightOffset;
            });
          }

          _dragPos = details.globalPosition.dy;
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
              height: MediaQuery.of(context).size.height + _currentHeightOffset,
              width: MediaQuery.of(context).size.width,
              child: _child),
        ),
      ),
    );
  }
}
