import 'package:cookoff/screens/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TileCarousel extends StatelessWidget {
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
          children: <Widget>[
            Tile("cheese", "assets/ingredients/cheese.png", Color(0xFF7C54EA)),
            Tile("orange", "assets/ingredients/orange.png", Color(0xFFD0EB5C)),
            Tile("cauliflower", "assets/ingredients/cauliflower.png",
                Color(0xFF65D2EB)),
            Tile("cheese", "assets/ingredients/cheese.png", Color(0xFF7C54EA)),
            Tile("orange", "assets/ingredients/orange.png", Color(0xFFD0EB5C)),
            Tile("cauliflower", "assets/ingredients/cauliflower.png",
                Color(0xFF65D2EB)),
          ]));
}

class Tile extends StatelessWidget {
  final String _iconPath;
  final Color _bgColor;
  final String ingredientName;

  Tile(this.ingredientName, String iconPath, Color bgColor)
      : _iconPath = iconPath,
        _bgColor = bgColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Some sort of event trigger
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                Scaffold(body: Game(ingredientName, _iconPath, _bgColor)),
          ),
        );
      },
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
          child: Container(
              padding:
                  EdgeInsets.all(MediaQuery.of(context).size.width * 0.055),
              child: Image.asset(_iconPath)),
        ),
      ),
    );
  }
}
