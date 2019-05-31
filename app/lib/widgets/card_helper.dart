import 'package:flutter/widgets.dart';

class CardRoundedBorder extends StatelessWidget {
  final Widget _child;
  final double _cardHeight;

  CardRoundedBorder({double cardHeight = 0.0, Widget child})
      : _cardHeight = cardHeight,
        _child = child;

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Container(
      height: _cardHeight + mediaSize.height * 0.13,
      padding: EdgeInsets.only(
        top: 30,
        left: mediaSize.width * 0.07,
      ),
      decoration: new BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.only(
            topLeft: Radius.elliptical(50, 30),
            topRight: Radius.elliptical(50, 30)),
      ),
      child: _child,
    );
  }
}

class UpdateHeightOnScroll extends StatelessWidget {
  final double _dragPos;
  final Function _onScroll;
  final Function _onRelease;
  final Function _startScroll;
  final Widget _child;

  UpdateHeightOnScroll(
      {double dragPos = 0,
      Function onScroll,
      Function onRelease,
      Function onStartScroll,
      Widget child})
      : _dragPos = dragPos,
        _onRelease = onRelease,
        _onScroll = onScroll,
        _startScroll = onStartScroll,
        _child = child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (DragStartDetails details) {
        _startScroll(details.globalPosition.dy);
      },
      onPanUpdate: (DragUpdateDetails details) {
        print("Drag $_dragPos, Current ${details.globalPosition.dy}");
        double change = details.globalPosition.dy - _dragPos;
        _onScroll(change);
      },
      onPanEnd: _onRelease,
      child: _child,
    );
  }
}
