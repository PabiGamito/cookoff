import 'package:flutter/widgets.dart';

class ScrollableLayout extends StatefulWidget {
  final Widget main;
  final Widget card;

  final double maxOffset;
  final double minOffset;

  ScrollableLayout(
      {@required this.main,
      @required this.card,
      @required this.maxOffset,
      this.minOffset = 0});

  @override
  State<StatefulWidget> createState() => _ScrollableLayoutState(
      main: main, card: card, maxOffset: maxOffset, minOffset: minOffset);
}

class _ScrollableLayoutState extends State<ScrollableLayout> {
  final Widget main;
  final Widget card;

  final double maxOffset;
  final double minOffset;

  double currentOffset;

  double _dragPos;

  _ScrollableLayoutState({this.main, this.card, this.maxOffset, this.minOffset})
      : currentOffset = maxOffset;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        main,
        Positioned(
          top: currentOffset,
          child: GestureDetector(
            onPanStart: (DragStartDetails details) {
              _dragPos = details.globalPosition.dy;
            },
            onPanUpdate: (DragUpdateDetails details) {
              var _change = details.globalPosition.dy - _dragPos;
              var _newOffset = currentOffset + _change;

              if (_newOffset > maxOffset) {
                setState(() {
                  currentOffset = maxOffset;
//                  if (_onTopScrollLimit != null) _onTopScrollLimit();
                });
              } else if (_newOffset < minOffset) {
                setState(() {
                  currentOffset = minOffset;
                });
              } else {
                setState(() {
                  currentOffset = _newOffset;
                });
              }

              _dragPos = details.globalPosition.dy;
            },
            child: Container(
              height: MediaQuery.of(context).size.height - currentOffset,
              width: MediaQuery.of(context).size.width,
              child: card,
            ),
          ),
        ),
      ],
    );
  }
}
