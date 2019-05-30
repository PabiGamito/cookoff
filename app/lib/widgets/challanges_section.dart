import 'package:cookoff/models/challenge.dart';
import 'package:cookoff/providers/challenge_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChallengesSection extends StatelessWidget {
  final ChallengeProvider _challengeProvider;

  ChallengesSection(ChallengeProvider challengeProvider)
      : _challengeProvider = challengeProvider;

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My challenges',
                      style: TextStyle(fontSize: 25, fontFamily: 'Montserrat'),
                      textAlign: TextAlign.left,
                    ),
                    CircleAddButton(),
                  ],
                ),
                Container(
                    margin: EdgeInsets.only(top: 10),
                    width: 45,
                    height: 6,
                    decoration: new BoxDecoration(
                      color: Color(0xFF8057E2),
                      borderRadius: BorderRadius.circular(
                          MediaQuery.of(context).size.width * 0.03),
                    ))
              ],
            ),
          ),
          StreamBuilder<Iterable<Challenge>>(
            stream: _challengeProvider.challengesStream('elena'),
            builder: (BuildContext context,
                AsyncSnapshot<Iterable<Challenge>> snapshots) {
              if (snapshots.hasData) {
                if (snapshots.data.length == 0) {
                  return NoChallenges();
                } else {
                  return Expanded(child: ChallengesList(snapshots.data));
                }
              }

              return NoChallenges();
            },
          ),
        ],
      );
}

class CircleAddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Color(0xFF8057E2),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: Text(
            '+',
            style: TextStyle(
                color: Colors.white, fontSize: 30, fontFamily: 'Montserrat'),
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
            width: 100,
            height: 100,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage(
                  'assets/apple.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 25),
            child: Text(
              'NO CURRENT\nCHALLENGES',
              style: TextStyle(
                  fontSize: 21,
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
        children:
            _challenges.map((challenge) => ChallengeItem(challenge)).toList(),
      );
}

class ChallengeItem extends StatelessWidget {
  final Challenge _challenge;

  ChallengeItem(Challenge challenge) : _challenge = challenge;

  String timeLeft(DateTime timeStamp) {
    return "5h:24m";
  }

  @override
  Widget build(BuildContext context) => Container(
      height: 100,
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Color(0xFF7C54EA),
        borderRadius:
            BorderRadius.circular(MediaQuery.of(context).size.width * 0.03),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Row(
            children: [
              Text(_challenge.ingredient),
              Text(timeLeft(_challenge.end))
            ],
          ),
        ],
      ));
}
