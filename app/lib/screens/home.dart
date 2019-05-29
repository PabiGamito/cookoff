import 'package:cookoff/widgets/challanges_section.dart';
import 'package:cookoff/widgets/featured_section.dart';
import 'package:cookoff/widgets/home_header.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      color: Color(0xFFFFC544),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          padding: EdgeInsets.only(top: 25, bottom: 25),
          child: HomeHeader('Veronica', 3, 'assets/veronica.png'),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(top: 40),
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(38), topRight: Radius.circular(38)),
            ),
            child: Column(children: [
              Container(
                padding: EdgeInsets.only(bottom: 20),
                child: FeaturedSection('Start cooking...', Color(0xFF8EE5B6)),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(top: 40),
                  decoration: new BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(38),
                      topRight: Radius.circular(38),
                    ),
                  ),
                  child: ChallengesSection(),
                ),
              ),
            ]),
          ),
        ),
      ]));
}
