import 'package:cookoff/blocs/game_bloc.dart';
import 'package:cookoff/blocs/game_event.dart';
import 'package:cookoff/models/challenge.dart';
import 'package:cookoff/models/ingredient.dart';
import 'package:cookoff/scalar.dart';
import 'package:cookoff/screens/camera.dart';
import 'package:cookoff/widgets/countdown.dart';
import 'package:cookoff/widgets/injector_widget.dart';
import 'package:cookoff/widgets/profile_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameHeader extends StatelessWidget {
  final Function _onExit;
  final GameBloc _bloc;

  GameHeader({Function onExit, GameBloc bloc})
      : _onExit = onExit,
        _bloc = bloc;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: Color(0x50000000),
            borderRadius: BorderRadius.circular(1000)),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          GameBackButton(onTap: _onExit),
          BlocBuilder<GameEvent, Challenge>(
              bloc: _bloc,
              builder: (context, challenge) {
                if (challenge.end == null) {
                  return Container();
                } else {
                  return Countdown(end: challenge.end);
                }
              }),
          GameTimeButton(onTap: () {})
        ]),
      );
}

class GameBackButton extends StatelessWidget {
  final Function _onTap;

  GameBackButton({Function onTap}) : _onTap = onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: _onTap,
      child: Container(
        width: Scalar(context).scale(100),
        height: Scalar(context).scale(60),
        child: Icon(Icons.keyboard_backspace,
            color: Colors.white, size: Scalar(context).scale(40)),
      ));
}

class GameTimeButton extends StatelessWidget {
  final Function _onTap;

  GameTimeButton({Function onTap}) : _onTap = onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: _onTap,
      child: Container(
        width: Scalar(context).scale(100),
        height: Scalar(context).scale(60),
        child: Icon(Icons.timer,
            color: Colors.white, size: Scalar(context).scale(32)),
      ));
}

class IngredientName extends StatelessWidget {
  final Ingredient _ingredient;

  IngredientName({Ingredient ingredient}) : _ingredient = ingredient;

  @override
  Widget build(BuildContext context) => Column(children: <Widget>[
        Text(
            '${_ingredient.name[0].toUpperCase()}${_ingredient.name.substring(1)}',
            style: TextStyle(
                fontSize: Scalar(context).scale(45),
                fontFamily: 'Montserrat',
                color: Colors.white,
                letterSpacing: 2)),
        Container(
            margin: EdgeInsets.only(top: Scalar(context).scale(15)),
            width: Scalar(context).scale(45),
            height: Scalar(context).scale(8),
            decoration: new BoxDecoration(
                color: Color(0x50000000),
                borderRadius: BorderRadius.circular(1000))),
      ]);
}

class IngredientIcon extends StatelessWidget {
  final Ingredient _ingredient;

  IngredientIcon({Ingredient ingredient}) : _ingredient = ingredient;

  @override
  Widget build(BuildContext context) => Container(
      width: Scalar(context).scale(160),
      height: Scalar(context).scale(160),
      child: Image.asset(_ingredient.imgPath));
}

class GameStartButton extends StatelessWidget {
  final Color _color;
  final GameBloc _bloc;

  GameStartButton({Color color, GameBloc bloc})
      : _color = color,
        _bloc = bloc;

  @override
  Widget build(BuildContext context) => BlocBuilder(
      bloc: _bloc,
      builder: (BuildContext context, Challenge challenge) => GestureDetector(
          onTap: () {
            if (!challenge.started) {
              _bloc.dispatch(GameButton(context));
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                        body: CameraScreen(
                          backgroundColor: _color,
                          bloc: _bloc,
                        ),
                      ),
                ),
              );
            }
          },
          child: Container(
              width: Scalar(context).scale(265),
              padding: EdgeInsets.symmetric(vertical: Scalar(context).scale(6)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                      Radius.circular(Scalar(context).scale(30)))),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: Scalar(context).scale(50),
                      width: Scalar(context).scale(50),
                      margin: EdgeInsets.only(right: Scalar(context).scale(15)),
                      child: Transform.rotate(
                        angle: challenge.started ? 0 : 1.1,
                        child: challenge.started
                            ? Icon(
                                Icons.add_a_photo,
                                color: _color,
                                size: Scalar(context).scale(35),
                              )
                            : Image.asset("assets/icons/rocket.png",
                                color: _color),
                      ),
                    ),
                    Text(challenge.started ? "SUBMIT" : "START",
                        style: TextStyle(
                          fontSize: Scalar(context).scale(23),
                          fontFamily: "Montserrat",
                          color: _color,
                          letterSpacing: 3,
                        ))
                  ]))));
}

class FriendProfiles extends StatelessWidget {
  final Color _color;
  final Function _onTap;
  final GameBloc _bloc;

  FriendProfiles({Color color, Function onTap, GameBloc bloc})
      : _color = color,
        _onTap = onTap,
        _bloc = bloc;

  @override
  Widget build(BuildContext context) => BlocBuilder<GameEvent, Challenge>(
      bloc: _bloc,
      builder: (context, challenge) => ProfileList(
              users: [
                for (var participant in challenge.participants)
                  InjectorWidget.of(context)
                      .injector
                      .userProvider
                      .userStream(participant)
              ],
              maxUsersShown: 4,
              iconSize: Scalar(context).scale(60),
              iconOffset: Scalar(context).scale(-10),
              onTap: _onTap,
              addMoreIcon: !challenge.started,
              color: _color,
              borderWidth: 6));
}
