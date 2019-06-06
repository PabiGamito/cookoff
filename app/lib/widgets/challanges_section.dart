import 'package:cookoff/models/challenge.dart';
import 'package:cookoff/models/ingredient.dart';
import 'package:cookoff/models/user.dart';
import 'package:cookoff/providers/challenge_provider.dart';
import 'package:cookoff/scalar.dart';
import 'package:cookoff/screens/game.dart';
import 'package:cookoff/widgets/countdown.dart';
import 'package:cookoff/widgets/injector_widget.dart';
import 'package:cookoff/widgets/profile_list.dart';
import 'package:cookoff/widgets/user_widget.dart';
import 'package:flutter/material.dart';

class ChallengesSection extends StatelessWidget {
  final ChallengeProvider _challengeProvider;
  final bool _scrollable;
  final void Function(BuildContext) _onAddChallenge;

  ChallengesSection(ChallengeProvider challengeProvider,
      {bool scrollable = true, void Function(BuildContext) onAddChallenge})
      : _challengeProvider = challengeProvider,
        _scrollable = scrollable,
        _onAddChallenge = onAddChallenge ?? ((c) {});

  @override
  Widget build(BuildContext context) => Column(children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              top: Scaler(context).scale(30),
              left: Scaler(context).scale(30),
              right: Scaler(context).scale(30)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My challenges',
                    style: TextStyle(
                        fontSize: Scaler(context).scale(25),
                        fontFamily: 'Montserrat'),
                    textAlign: TextAlign.left,
                  ),
                  CircleAddButton(
                    onTap: () => _onAddChallenge(context),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: Scaler(context).scale(10)),
                width: Scaler(context).scale(35),
                height: Scaler(context).scale(6),
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
                    left: Scaler(context).scale(30),
                    right: Scaler(context).scale(30)),
                child: StreamBuilder<Iterable<Challenge>>(
                    stream: _challengeProvider
                        .challengesStream(UserWidget.of(context).user.id),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data.length == 0) {
                        return NoChallenges();
                      }

                      return ChallengesList(
                          challenges: snapshot.data, scrollable: _scrollable);
                    })))
      ]);
}

class CircleAddButton extends StatelessWidget {
  final GestureTapCallback _onTap;

  CircleAddButton({GestureTapCallback onTap}) : _onTap = onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: _onTap,
        child: Container(
          width: Scaler(context).scale(48),
          height: Scaler(context).scale(48),
          decoration: BoxDecoration(
            color: Color(0xFF8057E2),
            borderRadius: BorderRadius.circular(Scaler(context).scale(40)),
          ),
          child: Center(
            child: Text(
              '+',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: Scaler(context).scale(30),
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
            width: Scaler(context).scale(100),
            height: Scaler(context).scale(100),
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
            padding: EdgeInsets.only(top: Scaler(context).scale(25)),
            child: Text(
              'NO CURRENT\nCHALLENGES',
              style: TextStyle(
                  fontSize: Scaler(context).scale(21),
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
  final bool _scrollable;

  ChallengesList({Iterable<Challenge> challenges, bool scrollable = true})
      : _challenges = challenges,
        _scrollable = scrollable;

  @override
  Widget build(BuildContext context) => ListView(
      physics: _scrollable
          ? const BouncingScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(
        top: Scaler(context).scale(15),
        bottom: Scaler(context).scale(15),
        left: Scaler(context).scale(0),
        right: Scaler(context).scale(0),
      ),
      children:
          _challenges.map((challenge) => ChallengeItem(challenge)).toList());
}

class ChallengeItem extends StatelessWidget {
  final Challenge _challenge;

  ChallengeItem(Challenge challenge) : _challenge = challenge;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Scaffold(body: GameScreen(challenge: _challenge)),
            ),
          );
        },
        child: StreamBuilder<Ingredient>(
            stream: InjectorWidget.of(context)
                .injector
                .ingredientProvider
                .ingredientStream(_challenge.ingredient),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                // Loading...
                return Container();
              }

              var ingredient = snapshot.data;

              return Container(
                margin: EdgeInsets.only(
                    top: Scaler(context).scale(10),
                    bottom: Scaler(context).scale(10)),
                height: Scaler(context).scale(100),
                decoration: BoxDecoration(
                  color: ingredient.color,
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.03),
                ),
                child: ChallengeInnerContent(
                    challenge: _challenge, ingredient: ingredient),
              );
            }),
      );
}

class ChallengeInnerContent extends StatelessWidget {
  final Challenge _challenge;
  final Ingredient _ingredient;

  ChallengeInnerContent(
      {@required Challenge challenge, @required Ingredient ingredient})
      : _challenge = challenge,
        _ingredient = ingredient;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(Scaler(context).scale(25)),
                child: Image.asset(
                    'assets/ingredients/' + _challenge.ingredient + '.png'),
              ),
              Container(
                child: Countdown(end: _challenge.end),
              ),
            ],
          ),
          Container(
              padding: EdgeInsets.only(right: Scaler(context).scale(25)),
              child: ProfileList(
                  users: profileListContent(context),
                  size: Scaler(context).scale(45),
                  color: _ingredient.color,
                  maxIcons: 2))
        ],
      );

  // Returns a list of max 2 users for home screen
  List<Stream<User>> profileListContent(BuildContext context) =>
      _challenge.participants
          .where((participant) => participant != UserWidget.of(context).user.id)
          .map((participant) => InjectorWidget.of(context)
              .injector
              .userProvider
              .userStream(participant))
          .toList();
}
