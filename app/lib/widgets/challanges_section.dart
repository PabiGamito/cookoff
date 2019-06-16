import 'package:cookoff/models/challenge.dart';
import 'package:cookoff/models/ingredient.dart';
import 'package:cookoff/models/user.dart';
import 'package:cookoff/scalar.dart';
import 'package:cookoff/screens/game.dart';
import 'package:cookoff/widgets/countdown.dart';
import 'package:cookoff/widgets/injector_widget.dart';
import 'package:cookoff/widgets/profile_list.dart';
import 'package:cookoff/widgets/titled_section.dart';
import 'package:cookoff/widgets/user_widget.dart';
import 'package:flutter/material.dart';

class ChallengesSection extends StatelessWidget {
  final Stream _challenges;
  final void Function(BuildContext) _onAddChallenge;
  final String _title;
  final String _fillText;

  ChallengesSection(Stream<Iterable<Challenge>> challenges,
      {void Function(BuildContext) onAddChallenge,
      String title = "My Challenges",
      String noChallengesFill = "NO CURRENT\nCHALLENGES"})
      : _challenges = challenges,
        _title = title,
        _fillText = noChallengesFill,
        _onAddChallenge = onAddChallenge;

  @override
  Widget build(BuildContext context) => Stack(
        overflow: Overflow.visible,
        children: [
          TitledSection(
            title: 'My challenges',
            underlineColor: Color(0xFF8057E2),
            child: StreamBuilder<Iterable<Challenge>>(
              stream: _challenges,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data.length == 0) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    child: NoChallenges(fillText: _fillText),
                  );
                }

                return ChallengesList(challenges: snapshot.data);
              },
            ),
          ),
          Positioned(
            top: -Scaler(context).scale(8),
            right: Scaler(context).scale(35),
            child: CircleAddButton(
              onTap: () => _onAddChallenge(context),
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
  final String _fillText;

  const NoChallenges({String fillText}) : _fillText = fillText;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: Scaler(context).scale(100),
            height: Scaler(context).scale(100),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/icons/apple.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: Scaler(context).scale(25)),
            child: Text(
              _fillText,
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

  ChallengesList({Iterable<Challenge> challenges}) : _challenges = challenges;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: Scaler(context).scale(35)),
        margin: EdgeInsets.only(bottom: Scaler(context).scale(25)),
        child: Column(
          children: [
            for (var challenge in _challenges) ChallengeItem(challenge),
          ],
        ),
      );
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
              builder: (context) => Scaffold(
                    body: GameScreen(challenge: _challenge),
                  ),
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
              margin: EdgeInsets.only(bottom: Scaler(context).scale(20)),
              padding: EdgeInsets.all(Scaler(context).scale(25)),
              decoration: BoxDecoration(
                color: ingredient.color,
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.03),
              ),
              child: ChallengeInnerContent(
                  challenge: _challenge, ingredient: ingredient),
            );
          },
        ),
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
          Image.asset(
            'assets/ingredients/' + _challenge.ingredient + '.png',
            height: Scaler(context).scale(50),
          ),
          Container(child: Countdown(end: _challenge.end)),
          ProfileList(
              users: profileListContent(context),
              size: Scaler(context).scale(45),
              color: _ingredient.color,
              maxIcons: 2)
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
