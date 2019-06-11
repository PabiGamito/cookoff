import 'dart:math';

import 'package:cookoff/blocs/game_bloc.dart';
import 'package:cookoff/providers/picture_provider.dart';
import 'package:cookoff/scalar.dart';
import 'package:cookoff/widgets/rounded_card.dart';
import 'package:cookoff/widgets/titled_section.dart';
import 'package:cookoff/widgets/user_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../injector.dart';

class GameScreenCard extends StatelessWidget {
  final PictureProvider _pictureProvider;
  final GameBloc _bloc;

  const GameScreenCard(
      {Key key, PictureProvider pictureProvider, GameBloc bloc})
      : _bloc = bloc,
        _pictureProvider = pictureProvider,
        super(key: key);

  @override
  Widget build(BuildContext context) =>
      _bloc.currentState.userHasFinished(UserWidget.of(context).user)
          ? BrowseCard(
              pictureProvider: _pictureProvider,
              bloc: _bloc,
            )
          : InspirationCard(
              pictureProvider: _pictureProvider,
              bloc: _bloc,
            );
}

class InspirationCard extends StatelessWidget {
  final PictureProvider _pictureProvider;
  final GameBloc _bloc;

  const InspirationCard(
      {Key key, PictureProvider pictureProvider, GameBloc bloc})
      : _bloc = bloc,
        _pictureProvider = pictureProvider,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return _GameScreenCard(
        stream: _pictureProvider.picturesStream(_bloc.currentState.ingredient),
        title: "Some Inspiration...");
  }
}

class BrowseCard extends StatelessWidget {
  final PictureProvider _pictureProvider;
  final GameBloc _bloc;

  const BrowseCard({Key key, PictureProvider pictureProvider, GameBloc bloc})
      : _bloc = bloc,
        _pictureProvider = pictureProvider,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return _GameScreenCard(
        stream: _pictureProvider.challengePictureStream(_bloc.currentState),
        title: "Browse Dishes...");
  }
}

// Game Screen Card
class _GameScreenCard extends StatelessWidget {
  final Stream<Iterable<String>> _stream;
  final PictureProvider _pictureProvider;
  final String _title;

  _GameScreenCard({@required Stream<Iterable<String>> stream, String title})
      : _pictureProvider = Injector().pictureProvider,
        _stream = stream,
        _title = title;

  @override
  Widget build(BuildContext context) {
    return Card(
      minHeight: Scaler(context).scale(130),
      child: RoundedCard(
        child: Container(
          child: TitledSection(
            title: _title,
            underlineColor: Color(0xFF65D2EB),
            child: StreamBuilder<Iterable<String>>(
                stream: _stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }

                  return Column(
                    children: snapshot.data
                        .map(
                          (url) => Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: Scaler(context).scale(10)),
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.width,
                                decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Scaler(context).scale(25)),
                                    image: new DecorationImage(
                                        fit: BoxFit.cover,
                                        image: new NetworkImage(url))),
                              ),
                        )
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
