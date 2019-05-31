import 'package:cookoff/models/ingredient.dart';
import 'package:cookoff/screens/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TileCarousel extends StatelessWidget {
  final List<Tile> _tiles;

  TileCarousel({@required List<Tile> tiles}) : _tiles = tiles;

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.only(
          top: 25,
          bottom: 25,
        ),
        height: 100,
        child: ListView(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
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
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.055),
          child: Image.asset(_iconPath));
    } else {
      child = _child;
    }

    return GestureDetector(
      onTap: () => _onTap(context),
      child: Center(
        child: new Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.only(left: 10.0, right: 10.0),
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
                      body: GameScreen(ingredient.name, ingredient.imgPath,
                          ingredient.bgColor)),
                ),
              ),
        );
}
