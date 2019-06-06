import 'dart:math';

import 'package:cookoff/models/ingredient.dart';
import 'package:cookoff/providers/picture_provider.dart';
import 'package:cookoff/scalar.dart';
import 'package:cookoff/widgets/rounded_card.dart';
import 'package:cookoff/widgets/titled_section.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../injector.dart';

class InspirationCard extends StatelessWidget {
  final Ingredient _ingredient;
  final PictureProvider _pictureProvider;

  InspirationCard({Key key, @required Ingredient ingredient})
      : _pictureProvider = Injector().pictureProvider,
        _ingredient = ingredient,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      minHeight: Scaler(context).scale(130),
      child: RoundedCard(
        child: Container(
          padding: EdgeInsets.only(bottom: Scaler(context).scale(60)),
          child: TitledSection(
            title: 'Some inspiration',
            underlineColor: Color(0xFF65D2EB),
            child: StreamBuilder<Iterable<String>>(
                stream: _pictureProvider.picturesStream(_ingredient.name),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }

                  return Column(
                    children: snapshot.data
                        .map((url) => ClipRRect(
                              borderRadius: new BorderRadius.circular(
                                  Scaler(context).scale(20)),
                              child: Image.network(
                                url,
                                height: MediaQuery.of(context).size.width,
                                width: MediaQuery.of(context).size.width,
                              ),
                            ))
                        .toList(),
                  );
                }),
          ),
        ),
      ),
    );
  }
}

class Card extends StatefulWidget {
  final Function _onClose;
  final Widget _child;
  final double _minHeight; // Also initial height

  final void Function(TapDownDetails) _onClickOut;

  const Card(
      {Function onClose,
      Widget child,
      double minHeight,
      void Function(TapDownDetails) onClickOut})
      : _onClose = onClose,
        _child = child,
        _onClickOut = onClickOut,
        _minHeight = minHeight ?? 100;

  @override
  _CardState createState() => _CardState(minHeight: _minHeight);
}

class _CardState extends State<Card> {
  final ScrollController _controller = ScrollController();
  double _lastHeight = 0;
  double _height = 0;
  double _startBounceHeight = 0;

  double _startScrollPos;
  double _bounceHeight = 0;

  _CardState({double minHeight}) {
    _lastHeight = minHeight;
    _height = minHeight;
    _startBounceHeight = _height;
  }

  bool fullHeight(BuildContext context) {
    return MediaQuery.of(context).size.height <= _height;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (details) {
        _startScrollPos = details.globalPosition.dy;
      },
      onVerticalDragUpdate: (details) {
        var _scrolledAmount = details.globalPosition.dy - _startScrollPos;
        var _newHeight = _lastHeight - _scrolledAmount;

        if (_controller.position.maxScrollExtent <= 0 &&
            _newHeight - _startBounceHeight > 0) {
          return;
        }

        _startBounceHeight = _height;

        setState(() {
          _bounceHeight = 0;
        });

        if (_newHeight > MediaQuery.of(context).size.height) {
          _controller.jumpTo(_newHeight - MediaQuery.of(context).size.height);
        }

        if (_newHeight < widget._minHeight) {
          _controller.jumpTo(_newHeight - widget._minHeight);
          _newHeight = widget._minHeight;
        }

        setState(() {
          var _maxHeight = _controller.position.maxScrollExtent +
              MediaQuery.of(context).size.height;
          _height = min(_maxHeight, _newHeight);
        });
      },
      onVerticalDragEnd: (details) {
        setState(() {
          _bounceHeight = 0;
        });

        _lastHeight = _height;
      },
      child: Container(
        height: _height,
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: <Widget>[
            if (_height >= MediaQuery.of(context).size.height)
              Container(
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white),
//            Container(height: _bounceHeight, color: Colors.white),
            ListView(
                padding: EdgeInsets.zero,
                controller: _controller,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  widget._child,
                ]),
            FadedBottom(),
          ],
        ),
      ),
    );
  }
}

class FadedBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        IgnorePointer(
          child: Container(
            height: Scaler(context).scale(35),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0.4, 1],
                colors: [
                  Color(0x00FFFFFF),
                  Color(0x80FFFFFF),
                  Color(0xFFFFFFFF),
                ],
              ),
            ),
          ),
        ),
      ]);
}
