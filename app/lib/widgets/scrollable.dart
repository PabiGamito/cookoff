import 'package:flutter/widgets.dart';

class VerticalScrollable extends StatefulWidget {
  final Widget _child;
  final double _width;
  final double _height;
  final double _maxHeight;
  final double _initialHeight;

  // Callback variable that updates based on scroll
  double heightOffset;

  // Callback function when reached max scroll height
  Function _onTopScrollLimit;

  VerticalScrollable(
      {@required double heightOffset,
      double initialHeight = 100,
      double initialWidth = 100,
      double maxHeight = 200,
      double initialHeightOffset = 100,
      Function onScrollLimit,
      Widget child})
      : heightOffset = heightOffset,
        _height = initialHeight,
        _width = initialWidth,
        _initialHeight = initialHeightOffset,
        _maxHeight = maxHeight,
        _onTopScrollLimit = onScrollLimit,
        _child = child;

  @override
  State<StatefulWidget> createState() => _ScrollableState(
      initialWidth: _width,
      initialHeight: _height,
      maxHeight: _maxHeight,
      initialHeightOffset: _initialHeight,
      heightOffset: heightOffset,
      onScrollLimit: _onTopScrollLimit,
      child: _child);
}

class _ScrollableState extends State<VerticalScrollable> {
  Widget _child;
  double _width;
  double _height;
  double _maxHeight;
  double _initialHeight;
  double heightOffset;

  Function _onTopScrollLimit;

  double _dragPos;

  _ScrollableState(
      {@required double heightOffset,
      double initialHeight = 100,
      double initialWidth = 100,
      double maxHeight = 200,
      double initialHeightOffset = 100,
      Function onScrollLimit,
      Widget child})
      : heightOffset = heightOffset,
        _height = initialHeight,
        _width = initialWidth,
        _initialHeight = initialHeightOffset,
        _maxHeight = maxHeight,
        _onTopScrollLimit = onScrollLimit,
        _child = child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      width: _width,

      // Translates the child widget to the initial height set, grows based on scroll height
      transform: Matrix4.translationValues(0, _initialHeight - heightOffset, 0),
      child: GestureDetector(
        onPanStart: (DragStartDetails details) {
          _dragPos = details.globalPosition.dy;
        },
        onPanUpdate: (DragUpdateDetails details) {
          var change = details.globalPosition.dy - _dragPos;
          if (heightOffset - change >= 0 &&
              heightOffset - change < _maxHeight) {
            setState(() {
              heightOffset -= change;
            });
          } else {
            if (_onTopScrollLimit != null) _onTopScrollLimit();
          }
          _dragPos = details.globalPosition.dy;
        },
        child: _child,
      ),
    );
  }
}
