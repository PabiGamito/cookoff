import 'package:cookoff/models/challenge.dart';
import 'package:cookoff/providers/challenge_provider.dart';
import 'package:cookoff/scalar.dart';
import 'package:cookoff/screens/game.dart';
import 'package:cookoff/widgets/fragment.dart';
import 'package:cookoff/widgets/profile_icon.dart';
import 'package:cookoff/widgets/profile_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'countdown.dart';

class ChallengesSection extends StatelessWidget {
  final ChallengeProvider _challengeProvider;

  ChallengesSection(ChallengeProvider challengeProvider)
      : _challengeProvider = challengeProvider;

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                left: Scalar(context).scale(30),
                right: Scalar(context).scale(30)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My challenges',
                      style: TextStyle(
                          fontSize: Scalar(context).scale(25),
                          fontFamily: 'Montserrat'),
                      textAlign: TextAlign.left,
                    ),
                    CircleAddButton(
                      onTap: () =>
                          FragmentNavigator.navigateTo(context, 'ingredients'),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: Scalar(context).scale(10)),
                  width: Scalar(context).scale(45),
                  height: Scalar(context).scale(6),
                  decoration: new BoxDecoration(
                    color: Color(0xFF8057E2),
                    borderRadius: BorderRadius.circular(
                        MediaQuery.of(context).size.width * 0.03),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                  left: Scalar(context).scale(30),
                  right: Scalar(context).scale(30)),
              child: StreamBuilder<Iterable<Challenge>>(
                stream: _challengeProvider.challengesStream('elena'),
                builder: (BuildContext context,
                    AsyncSnapshot<Iterable<Challenge>> snapshots) {
                  if (snapshots.hasData) {
                    if (snapshots.data.length == 0) {
                      return NoChallenges();
                    } else {
                      return ChallengesList(snapshots.data);
                    }
                  }

                  return NoChallenges();
                },
              ),
            ),
          ),
        ],
      );
}

class CircleAddButton extends StatelessWidget {
  final GestureTapCallback _onTap;

  CircleAddButton({GestureTapCallback onTap}) : _onTap = onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: _onTap,
        child: Container(
          width: Scalar(context).scale(40),
          height: Scalar(context).scale(40),
          decoration: BoxDecoration(
            color: Color(0xFF8057E2),
            borderRadius: BorderRadius.circular(Scalar(context).scale(40)),
          ),
          child: Center(
            child: Text(
              '+',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: Scalar(context).scale(30),
                  fontFamily: 'Montserrat'),
            ),
          ),
        ),
      );
}

class NoChallenges extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: Scalar(context).scale(100),
            height: Scalar(context).scale(100),
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage(
                  'assets/icons/apple.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: Scalar(context).scale(25)),
            child: Text(
              'NO CURRENT\nCHALLENGES',
              style: TextStyle(
                  fontSize: Scalar(context).scale(21),
                  fontFamily: 'Montserrat',
                  color: Color(0xFFC1C1C1),
                  letterSpacing: 2.0),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      );
}

class ChallengesList extends StatelessWidget {
  final Iterable<Challenge> _challenges;

  ChallengesList(Iterable<Challenge> challenges) : _challenges = challenges;

  @override
  Widget build(BuildContext context) => ListView(
        padding: EdgeInsets.only(
          top: Scalar(context).scale(15),
          bottom: Scalar(context).scale(15),
          left: Scalar(context).scale(0),
          right: Scalar(context).scale(0),
        ),
        children:
            _challenges.map((challenge) => ChallengeItem(challenge)).toList(),
      );
}

class ChallengeItem extends StatelessWidget {
  final Challenge _challenge;
  final Color bgColor = Color(0xFF7C54EA);

  ChallengeItem(Challenge challenge) : _challenge = challenge;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                      body: GameScreen(
                    "cheese",
                    "assets/ingredients/cheese.png",
                    bgColor,
                    challenge: _challenge,
                  )),
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.only(
              top: Scalar(context).scale(10),
              bottom: Scalar(context).scale(10)),
          height: Scalar(context).scale(100),
          decoration: BoxDecoration(
            color: Color(0xFF7C54EA),
            borderRadius:
                BorderRadius.circular(MediaQuery.of(context).size.width * 0.03),
          ),
          child: ChallengeInnerContent(_challenge),
        ),
      );
}

class ChallengeInnerContent extends StatelessWidget {
  final Challenge _challenge;

  ChallengeInnerContent(Challenge challenge) : _challenge = challenge;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(Scalar(context).scale(25)),
                child: Image.asset(
                    'assets/ingredients/' + _challenge.ingredient + '.png'),
              ),
              Container(
                child: Countdown(_challenge.end),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.only(right: Scalar(context).scale(25)),
            child: ProfileList(
              [
                ProfileIcon(
                  // random network image until we get users sorted out properly
                  'https://t4.ftcdn.net/jpg/00/64/67/27/240_F_64672736_U5kpdGs9keUll8CRQ3p3YaEv2M6qkVY5.jpg',
                  size: Scalar(context).scale(45),
                  borderWidth: Scalar(context).scale(4),
                ),
                ProfileIcon(
                  // random network image until we get users sorted out properly
                  'https://t4.ftcdn.net/jpg/00/64/67/27/240_F_64672736_U5kpdGs9keUll8CRQ3p3YaEv2M6qkVY5.jpg',
                  size: Scalar(context).scale(45),
                  borderWidth: Scalar(context).scale(4),
                ),
              ],
              iconSize: Scalar(context).scale(45),
              iconOffset: Scalar(context).scale(-10),
              hasMoreIcon: false,
            ),
          ),
        ],
      );
}
