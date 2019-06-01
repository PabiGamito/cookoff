import 'package:cookoff/scalar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GameBackButton extends StatelessWidget {
  final Function _popScreen;

  GameBackButton(Function popScreen) : _popScreen = popScreen;

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Container(
      height: Scalar(context).scale(135),
      padding: EdgeInsets.only(
        top: Scalar(context).scale(35),
        bottom: Scalar(context).scale(18),
      ),
      margin: EdgeInsets.only(left: Scalar(context).scale(20)),
      child: Wrap(children: [
        GestureDetector(
          onTap: _popScreen,
          child: Text(
            "\u{2190}",
            style: TextStyle(
              fontSize: Scalar(context).scale(60),
              fontFamily: "Montserrat",
              color: Colors.white,
            ),
          ),
        ),
      ]),
    );
  }
}

class IngredientName extends StatelessWidget {
  final String _ingredientName;

  IngredientName(String ingredientName) : _ingredientName = ingredientName;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: Text(
          "${_ingredientName[0].toUpperCase()}${_ingredientName.substring(1)}",
          style: TextStyle(
            fontSize: Scalar(context).scale(50),
            fontFamily: "Montserrat",
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}

class IngredientIcon extends StatelessWidget {
  final double _size;
  final String _iconPath;
  final EdgeInsets _margin;

  IngredientIcon(double size, String iconPath, {EdgeInsets margin})
      : _size = size,
        _iconPath = iconPath,
        _margin = margin ?? EdgeInsets.only(bottom: size);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      margin: _margin,
      child: Image.asset(_iconPath),
    );
  }
}

class GameStartButton extends StatelessWidget {
  final Function _startGame;
  final Widget _timeLeftWidget;
  final bool _gameStarted;
  final double _iconDistanceScale;

  GameStartButton(
      {Function onGameStart,
      Widget countdownWidget,
      bool gameStarted = false,
      double iconDistanceScale = 0.05})
      : _startGame = onGameStart,
        _timeLeftWidget = countdownWidget,
        _gameStarted = gameStarted,
        _iconDistanceScale = iconDistanceScale;

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        if (!_gameStarted) {
          _startGame();
        }
      },
      child: Center(
        child: Container(
          padding: EdgeInsets.only(
            top: Scalar(context).scale(5),
            bottom: Scalar(context).scale(5),
            left: Scalar(context).scale(5),
            right: Scalar(context).scale(5),
          ),
          margin:
              EdgeInsets.only(bottom: mediaSize.height * _iconDistanceScale),
          decoration: BoxDecoration(
            color: Color(0x65000000),
            borderRadius:
                BorderRadius.all(Radius.circular(Scalar(context).scale(30))),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Visibility(
              visible: !_gameStarted,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // Rocket Icon
                    Container(
                      margin: EdgeInsets.only(
                        left: Scalar(context).scale(30),
                      ),
                      height: Scalar(context).scale(50),
                      width: Scalar(context).scale(50),
                      child: Transform.rotate(
                        angle: 1.2,
                        child: Image.asset("assets/icons/rocket.png"),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: Scalar(context).scale(10),
                        right: Scalar(context).scale(30),
                      ),
                      child: Text(
                        "START",
                        style: TextStyle(
                          fontSize: Scalar(context).scale(20),
                          fontFamily: "Montserrat",
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ]),
            ),
            Visibility(
              visible: _gameStarted,
              child: Container(
                margin: EdgeInsets.only(
                  top: Scalar(context).scale(10),
                  bottom: Scalar(context).scale(10),
                  left: Scalar(context).scale(25),
                  right: Scalar(context).scale(25),
                ),
                child: _timeLeftWidget,
              ),
            )
          ]),
        ),
      ),
    );
  }
}
