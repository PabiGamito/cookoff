import 'dart:async';

import 'package:cookoff/models/challenge.dart';
import 'package:cookoff/providers/challenge_provider.dart';
import 'package:cookoff/widgets/profile_icon.dart';
import 'package:cookoff/widgets/profile_list.dart';
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
          Expanded(
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
                  'assets/icons/apple.png',
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
              Image.asset(
                  'assets/ingredients/' + _challenge.ingredient + '.png'),
              TimeLeftWidget(_challenge.end),
            ],
          ),
          ProfileList(
            [
              ProfileIcon(
                'assets/faces/veronica.png',
                size: 50,
                borderWidth: 4,
              ),
              ProfileIcon(
                'assets/faces/veronica.png',
                size: 50,
                borderWidth: 4,
              ),
            ],
            iconOffset: -10,
            hasMoreIcon: false,
          ),
        ],
      ));
}

class TimeLeftWidget extends StatefulWidget {
  final DateTime _end;

  TimeLeftWidget(DateTime end) : _end = end;

  @override
  State<StatefulWidget> createState() => _TimeLeftWidgetState(_end);
}

class _TimeLeftWidgetState extends State<TimeLeftWidget> {
  final DateTime _end;
  String _timeValue;
  String _timeValueUnit;
  String _timeValueAlt;
  String _timeValueAltUnit;

  _TimeLeftWidgetState(this._end);

  @override
  void initState() {
    super.initState();

    updateTimeText();

    Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        updateTimeText();
      });
    });
  }

  void updateTimeText() {
    _timeValue = timeText()[0][0];
    _timeValueUnit = timeText()[1][0];
    _timeValueAlt = timeText()[0][1];
    _timeValueAltUnit = timeText()[1][1];
  }

  List<List<String>> timeText() {
    var _timeLeft = _end.difference(DateTime.now());

    int valueCnt = 0;

    var values = List<String>();
    var units = List<String>();

    if (_timeLeft.inDays > 0) {
      units.add('d');
      values.add(_timeLeft.inDays.toString());
      valueCnt++;
    }

    if (_timeLeft.inHours > 0) {
      units.add('h');
      var hours = _timeLeft.inHours - _timeLeft.inDays * 24;
      values.add(hours.toString());
      valueCnt++;
    }

    if (valueCnt < 2 && _timeLeft.inMinutes > 0) {
      units.add('m');
      var minutes = _timeLeft.inMinutes -
          _timeLeft.inHours * 60 -
          _timeLeft.inDays * 24 * 60;
      values.add(minutes.toString());
      valueCnt++;
    }

    if (valueCnt < 2 && _timeLeft.inSeconds > 0) {
      units.add('s');
      var seconds = _timeLeft.inSeconds -
          _timeLeft.inMinutes * 60 -
          _timeLeft.inHours * 60 * 60 -
          _timeLeft.inDays * 24 * 60 * 60;
      values.add(seconds.toString());
      valueCnt++;
    }

    var res = List<List<String>>();

    res.add(values);
    res.add(units);

    return res;
  }

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            _timeValue ?? '',
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontFamily: 'Montserrat'),
          ),
          Text(
            (_timeValueUnit ?? '') + " ",
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontFamily: 'Montserrat'),
          ),
          Text(
            _timeValueAlt ?? '',
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontFamily: 'Montserrat'),
          ),
          Text(
            _timeValueAltUnit ?? '',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontFamily: 'Montserrat'),
          ),
        ],
      );
}
