import 'package:cookoff/models/challenge.dart';
import 'package:cookoff/models/ingredient.dart';
import 'package:cookoff/scalar.dart';
import 'package:cookoff/screens/game.dart';
import 'package:cookoff/widgets/user_widget.dart';
import 'package:flutter/material.dart';

class TileCarousel extends StatelessWidget {
  final List<Widget> _tiles;

  TileCarousel({@required List<Widget> tiles}) : _tiles = tiles;

  @override
  Widget build(BuildContext context) => Container(
        width: MediaQuery.of(context).size.width - Scaler(context).scale(70),
        height: Scaler(context).scale(100),
        child: Stack(
          overflow: Overflow.visible,
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: -Scaler(context).scale(35),
              right: -Scaler(context).scale(35),
              child: ListView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: [
                  Container(width: Scaler(context).scale(35)),
                  ..._tiles,
                  Container(width: Scaler(context).scale(15))
                ],
              ),
            ),
          ],
        ),
      );
}

class Tile extends StatelessWidget {
  final String _iconPath;
  final Color _bgColor;
  final void Function(BuildContext) _onTap;
  final Widget _child;

  Tile(
      {String iconPath,
      @required Color bgColor,
      void Function(BuildContext) onTap,
      Widget child})
      : _iconPath = iconPath,
        _bgColor = bgColor,
        _onTap = onTap,
        _child = child {
    assert((iconPath != null || child != null) && bgColor != null);
  }

  @override
  Widget build(BuildContext context) {
    var child;

    if (_child == null) {
      child = Container(
          padding: EdgeInsets.all(Scaler(context).scale(20)),
          child: Image.asset(_iconPath));
    } else {
      child = _child;
    }

    return GestureDetector(
      onTap: () => _onTap(context),
      child: Center(
        child: new Container(
          width: Scaler(context).scale(100),
          height: Scaler(context).scale(100),
          margin: EdgeInsets.only(right: Scaler(context).scale(20)),
          decoration: BoxDecoration(
            color: _bgColor,
            borderRadius:
                BorderRadius.circular(MediaQuery.of(context).size.width * 0.03),
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}

class IngredientTile extends StatelessWidget {
  final Ingredient _ingredient;

  IngredientTile(Ingredient ingredient) : _ingredient = ingredient;

  @override
  Widget build(BuildContext context) => Tile(
      iconPath: _ingredient.imgPath,
      bgColor: _ingredient.color,
      onTap: (context) => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Scaffold(
                  body: GameScreen(
                      challenge: Challenge(
                          owner: UserWidget.of(context).user.id,
                          ingredient: _ingredient.name,
                          end: DateTime(0, 0)))))));
}
