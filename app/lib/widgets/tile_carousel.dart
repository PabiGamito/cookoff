import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TileCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      height: MediaQuery.of(context).size.width * 0.40,
      child: ListView(
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05),
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Tile("assets/cheese.png", Color(0xFF7C54EA)),
            Tile("assets/orange.png", Color(0xFFD0EB5C)),
            Tile("assets/cauliflower.png", Color(0xFF65D2EB)),
            Tile("assets/cheese.png", Color(0xFF7C54EA)),
            Tile("assets/orange.png", Color(0xFFD0EB5C)),
            Tile("assets/cauliflower.png", Color(0xFF65D2EB)),
          ]));
}

class Tile extends StatelessWidget {
  final String _iconPath;
  final Color _bgColor;

  Tile(String iconPath, Color bgColor)
      : _iconPath = iconPath,
        _bgColor = bgColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: new Container(
        width: MediaQuery.of(context).size.width * 0.25,
        height: MediaQuery.of(context).size.width * 0.25,
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.width * 0.03),
        ),
        child: Container(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.055),
            child: Image.asset(_iconPath)),
      ),
    );
  }
}
