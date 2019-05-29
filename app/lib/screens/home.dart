import 'package:cookoff/widgets/featured_section.dart';
import 'package:cookoff/widgets/home_header.dart';
import 'package:cookoff/widgets/section_title.dart';
import 'package:cookoff/widgets/tile_carousel.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const double sectionOverlayHeight = 100;
    return Container(
        color: Color(0xFFFFC544),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            padding: EdgeInsets.only(top: 25, bottom: 25),
            child: HomeHeader('Veronica', 3, 'assets/veronica.png'),
          ),
          Container(
            padding: EdgeInsets.only(bottom: sectionOverlayHeight),
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(50, 30),
                  topRight: Radius.elliptical(50, 30)),
            ),
            child: FeaturedSection('Start cooking...', Color(0xFF8EE5B6)),
          ),
          Container(
            transform: Matrix4.translationValues(0, -sectionOverlayHeight, 0),
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
        ]));
  }
}
