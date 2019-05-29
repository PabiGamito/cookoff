import 'package:cookoff/providers/challenge_provider.dart';
import 'package:cookoff/widgets/challanges_section.dart';
import 'package:cookoff/widgets/featured_section.dart';
import 'package:cookoff/widgets/home_header.dart';
import 'package:cookoff/widgets/injector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Set status bar color on android to match header
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Color(0xFFFFC544),
    ));

    // Challenge provider for challenge section
    ChallengeProvider challengeProvider =
        InjectorWidget
            .of(context)
            .injector
            .challengeProvider;

    return Container(
        color: Color(0xFFFFC544),
        child:
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            padding: EdgeInsets.only(top: 55, bottom: 35),
            child: HomeHeader('Elena', 3, 'assets/faces/Elena.jpg'),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 40),
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(38),
                    topRight: Radius.circular(38)),
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
                    child: ChallengesSection(challengeProvider),
                  ),
                ),
              ]),
            ),
          ),
          ]),
    );
  }
}
