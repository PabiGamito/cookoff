import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'rounded_card.dart';

class ScrollableCard extends StatefulWidget {
  final Widget _background;
  final Widget _card;
  final Color _cardColor;
  final double _minHeight;
  final double _maxHeight;
  final double _startingHeight;

  ScrollableCard({
    Widget background,
    Widget card,
    Color cardColor = Colors.white,
    double minHeight = 100,
    double maxHeight,
    double startingHeight,
  })  : _background = background,
        _card = card,
        _cardColor = cardColor,
        _minHeight = minHeight,
        _maxHeight = maxHeight,
        _startingHeight = startingHeight ?? minHeight;

  @override
  State<StatefulWidget> createState() => _ScrollableCardState(
      background: _background,
      card: _card,
      cardColor: _cardColor,
      minHeight: _minHeight,
      maxHeight: _maxHeight,
      startingHeight: _startingHeight);
}

class _ScrollableCardState extends State<ScrollableCard> {
  final Widget _background;
  final Widget _card;
  final Color _cardColor;

  final double _minHeight;
  double _maxHeight;

  double _cardHeight;
  double _dragPos = 0.0;

  _ScrollableCardState({
    Widget background,
    Widget card,
    Color cardColor = Colors.white,
    double minHeight = 100,
    double maxHeight,
    double startingHeight,
  })  : _background = background,
        _card = card,
        _cardColor = cardColor,
        _minHeight = minHeight,
        _maxHeight = maxHeight,
        _cardHeight = startingHeight ?? minHeight;

  @override
  Widget build(BuildContext context) {
    if (_maxHeight == null) {
      _maxHeight = MediaQuery.of(context).size.height;
    }

    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () => setState(() {
                _cardHeight = _minHeight;
              }),
          child: Container(
            child: _background,
          ),
        ),
        Container(
          transform: Matrix4.translationValues(
              0, MediaQuery.of(context).size.height - _cardHeight, 0),
          child: GestureDetector(
            onPanStart: (DragStartDetails details) {
              _dragPos = details.globalPosition.dy;
            },
            onPanUpdate: (DragUpdateDetails details) {
              var _change = details.globalPosition.dy - _dragPos;
              var _newCardHeight = _cardHeight - _change;

              if (_newCardHeight < _minHeight) {
                // Min Height Reached
                _cardHeight = _minHeight;
              } else if (_newCardHeight > _maxHeight) {
                // Max Height Reached
                _cardHeight = _maxHeight;
              } else {
                // Scroll card
                setState(() {
                  _cardHeight = _newCardHeight;
                });
              }

              _dragPos = details.globalPosition.dy;
            },
            child: RoundedCard(
              child: _card,
              backgroundColor: _cardColor,
            ),
          ),
        ),
      ],
    );
  }
}
