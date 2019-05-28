import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TileCarousel extends StatelessWidget {
  final String _title;
  final Color _titleUnderlineColor;

  TileCarousel(String title, Color titleUnderlineColor)
      : _title = title,
        _titleUnderlineColor = titleUnderlineColor;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.width * 0.05,
                  left: MediaQuery.of(context).size.width * 0.07),
              child: TileCarouselTitle("Start cooking...", _titleUnderlineColor)),
          Container(
              height: MediaQuery.of(context).size.width * 0.40,
              child: ListView(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                      right: MediaQuery.of(context).size.width * 0.05),
                  // This next line does the trick.
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Tile("assets/cheese.png", Color(0xFF7C54EA)),
                    Tile("assets/orange.png", Color(0xFFD0EB5C)),
                    Tile("assets/cauliflower.png", Color(0xFF65D2EB)),
                    Tile("assets/cheese.png", Color(0xFF7C54EA)),
                    Tile("assets/orange.png", Color(0xFFD0EB5C)),
                    Tile("assets/cauliflower.png", Color(0xFF65D2EB)),
                  ]))
        ],
      );
}

class TileCarouselTitle extends StatelessWidget {
  final String _title;
  final Color _color;

  const TileCarouselTitle(String title, Color color)
      : _title = title,
        _color = color;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _title,
            style: TextStyle(fontSize: 25, fontFamily: 'Montserrat'),
            textAlign: TextAlign.left,
          ),
          Container(
              margin: EdgeInsets.only(top: 10),
              width: 45,
              height: 6,
              decoration: new BoxDecoration(
                color: _color,
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.03),
              ))
        ],
      ),
    );
  }
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
        decoration: new BoxDecoration(
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
