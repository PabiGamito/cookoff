import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// TODO: Convert this into or wrap in a card deck widget for better code design
class ScrollableLayout extends StatefulWidget {
  final Widget main;
  final Widget card;

  final double maxOffset;
  final double minOffset;

  final bool Function() scrollable;

  final void Function(double scrolledAmount) onTopOverScroll;
  final void Function(double scrolledAmount) onBottomOverScroll;

  ScrollableLayout(
      {@required this.main,
      @required this.card,
      @required this.maxOffset,
      this.minOffset = 0,
      this.scrollable,
      this.onTopOverScroll,
      this.onBottomOverScroll});

  @override
  State<StatefulWidget> createState() => _ScrollableLayoutState(
      main: main,
      card: card,
      maxOffset: maxOffset,
      minOffset: minOffset,
      scrollable: scrollable,
      onTopOverScroll: onTopOverScroll,
      onBottomOverScroll: onBottomOverScroll);
}

class _ScrollableLayoutState extends State<ScrollableLayout> {
  final Widget main;
  final Widget card;

  final double maxOffset;
  final double minOffset;

  final bool Function() _scrollable;

  final void Function(double scrolledAmount) _onTopOverScroll;
  final void Function(double scrolledAmount) _onBottomOverScroll;

  double currentOffset;

  double _dragPos;

  _ScrollableLayoutState(
      {this.main,
      this.card,
      this.maxOffset,
      this.minOffset = 0,
      bool Function() scrollable,
      void Function(double scrolledAmount) onTopOverScroll,
      void Function(double scrolledAmount) onBottomOverScroll})
      : currentOffset = maxOffset,
        _scrollable = scrollable ?? (() => true),
        _onTopOverScroll = onTopOverScroll ?? ((d) => {}),
        _onBottomOverScroll = onBottomOverScroll ?? ((d) => {});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        main,
        Positioned(
          top: currentOffset,
          child: Container(
            height: MediaQuery.of(context).size.height - currentOffset,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              padding: EdgeInsets.all(0.000000001),
              physics: BouncingScrollPhysics(),
              children: [
                Container(
                  height: MediaQuery.of(context).size.height - currentOffset,
                  width: MediaQuery.of(context).size.width,
                  child: card,
                ),
              ],
            ),
          ),
        ),
      ],
    );

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
              if (!_scrollable()) return;

              var _change = details.globalPosition.dy - _dragPos;
              var _newOffset = currentOffset + _change;

              if (_newOffset > maxOffset) {
                _onBottomOverScroll(_newOffset - (maxOffset - currentOffset));
                setState(() {
                  currentOffset = maxOffset;
                });
              } else if (_newOffset < minOffset) {
                _onTopOverScroll(_newOffset - (currentOffset - minOffset));
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
              child: Scrollable(
                physics: BouncingScrollPhysics(),
                viewportBuilder:
                    (BuildContext context, ViewportOffset position) {
                  return Container(
                    height: MediaQuery.of(context).size.height - currentOffset,
                    width: MediaQuery.of(context).size.width,
                    child: card,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
