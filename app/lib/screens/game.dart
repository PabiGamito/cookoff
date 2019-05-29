import 'package:cookoff/widgets/featured_section.dart';
import 'package:cookoff/widgets/section_title.dart';
import 'package:cookoff/widgets/tile_carousel.dart';
import 'package:flutter/material.dart';

class Game extends StatelessWidget {
  final String _iconPath;
  final Color _bgColor;

  Game(String iconPath, Color bgColor)
      : _iconPath = iconPath,
        _bgColor = bgColor;

  @override
  Widget build(BuildContext context) {
    const double sectionOverlayHeight = 100;
    var initial;
    var distance;
    return GestureDetector(
        onPanStart: (DragStartDetails details) {
          initial = details.globalPosition.dx;
        },
        onPanUpdate: (DragUpdateDetails details) {
          distance = details.globalPosition.dx - initial;
        },
        onPanEnd: (DragEndDetails details) {
          initial = 0.0;
          print(distance);
          // Right swipe
          if (distance < -200.0) {
            // change page
            Navigator.pop(context);
          }
        },
        child: Container(
            color: _bgColor,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 25, bottom: 25),
                    child: Text(
                      "\u{2190}",
                      style: TextStyle(fontSize: 100, fontFamily: "Montserrat"),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: sectionOverlayHeight),
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.elliptical(50, 30),
                          topRight: Radius.elliptical(50, 30)),
                    ),
                    child:
                        FeaturedSection('Start cooking...', Color(0xFFA3FFB6)),
                  ),
                  Container(
                    transform:
                        Matrix4.translationValues(0, -sectionOverlayHeight, 0),
                    padding: EdgeInsets.all(20),
                    decoration: new BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.elliptical(50, 30),
                          topRight: Radius.elliptical(50, 30)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SectionTitle('My challanges', Color(0xFF8057E2)),
                        TileCarousel(),
                      ],
                    ),
                  ),
                ])));
  }
}
