import 'package:cookoff/models/ingredient.dart';
import 'package:cookoff/scalar.dart';
import 'package:cookoff/screens/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TileCarousel extends StatelessWidget {
  final List<Tile> _tiles;

  TileCarousel({@required List<Tile> tiles}) : _tiles = tiles;

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.only(
          top: Scalar(context).scale(25),
          bottom: Scalar(context).scale(25),
        ),
        height: Scalar(context).scale(100),
        child: ListView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            left: Scalar(context).scale(20),
            right: Scalar(context).scale(20),
          ),
          scrollDirection: Axis.horizontal,
          children: _tiles,
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
        _onTap = onTap ?? ((c) => {}),
        _child = child {
    assert((iconPath != null || child != null) && bgColor != null);
  }

  @override
  Widget build(BuildContext context) {
    var child;

    if (_child == null) {
      child = Container(
          padding: EdgeInsets.all(Scalar(context).scale(20)),
          child: Image.asset(_iconPath));
    } else {
      child = _child;
    }

    return GestureDetector(
      onTap: () => _onTap(context),
      child: Center(
        child: new Container(
          width: Scalar(context).scale(100),
          height: Scalar(context).scale(100),
          margin: EdgeInsets.only(
              left: Scalar(context).scale(10.0),
              right: Scalar(context).scale(10.0)),
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

class IngredientTile extends Tile {
  final Ingredient _ingredient;

  IngredientTile(Ingredient ingredient)
      : _ingredient = ingredient,
        super(
          iconPath: ingredient.imgPath,
          bgColor: ingredient.bgColor,
          onTap: (context) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                      body: GameScreen(ingredient.name, ingredient.bgColor)),
                ),
              ),
        );
}
