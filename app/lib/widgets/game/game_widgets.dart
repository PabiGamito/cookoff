import 'package:cookoff/blocs/auth_bloc.dart';
import 'package:cookoff/blocs/game_bloc.dart';
import 'package:cookoff/blocs/game_event.dart';
import 'package:cookoff/models/challenge.dart';
import 'package:cookoff/models/user.dart';
import 'package:cookoff/scalar.dart';
import 'package:cookoff/widgets/profile_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameHeader extends StatelessWidget {
  final Function _onExit;

  GameHeader({Function onExit}) : _onExit = onExit;

  @override
  Widget build(BuildContext context) =>
      Row(children: [GameBackButton(onTap: _onExit)]);
}

class GameBackButton extends StatelessWidget {
  final Function _onTap;

  GameBackButton({Function onTap}) : _onTap = onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: _onTap,
      child: Container(
        width: Scalar(context).scale(60),
        height: Scalar(context).scale(60),
        decoration: BoxDecoration(
            color: Color(0x40000000),
            borderRadius: BorderRadius.circular(Scalar(context).scale(30))),
        child: Center(
          child: Icon(Icons.keyboard_backspace,
              color: Colors.white, size: Scalar(context).scale(40)),
        ),
      ));
}

class IngredientName extends StatelessWidget {
  final GameBloc _bloc;

  IngredientName({GameBloc bloc}) : _bloc = bloc;

  @override
  Widget build(BuildContext context) => BlocBuilder(
      bloc: _bloc,
      builder: (BuildContext context, Challenge challenge) {
        var ingredient = challenge.ingredient;
        return Container(
            child: Text(
                '${ingredient[0].toUpperCase()}${ingredient.substring(1)}',
                style: TextStyle(
                    fontSize: Scalar(context).scale(50),
                    fontFamily: 'Montserrat',
                    color: Colors.white,
                    letterSpacing: 2)));
      });
}

class IngredientIcon extends StatelessWidget {
  final GameBloc _bloc;

  IngredientIcon({GameBloc bloc}) : _bloc = bloc;

  @override
  Widget build(BuildContext context) => BlocBuilder(
      bloc: _bloc,
      builder: (BuildContext context, Challenge challenge) => Container(
          width: Scalar(context).scale(180),
          height: Scalar(context).scale(180),
          child: Image.asset(
              'assets/ingredients/${challenge.ingredient.toLowerCase()}.png')));
}

class GameStartButton extends StatelessWidget {
  final GameBloc _bloc;

  GameStartButton({GameBloc bloc}) : _bloc = bloc;

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () {
        _bloc.dispatch(GameButton(context));
      },
      child: Container(
          width: Scalar(context).scale(270),
          padding: EdgeInsets.symmetric(vertical: Scalar(context).scale(5)),
          decoration: BoxDecoration(
              color: Color(0x60000000),
              borderRadius:
                  BorderRadius.all(Radius.circular(Scalar(context).scale(30)))),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: Scalar(context).scale(55),
                  width: Scalar(context).scale(55),
                  margin: EdgeInsets.only(right: Scalar(context).scale(15)),
                  child: Transform.rotate(
                    angle: 1.1,
                    child: Image.asset("assets/icons/rocket.png"),
                  ),
                ),
                Text("START",
                    style: TextStyle(
                      fontSize: Scalar(context).scale(24),
                      fontFamily: "Montserrat",
                      color: Colors.white,
                      letterSpacing: 3,
                    ))
              ])));
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
  Widget build(BuildContext context) => BlocBuilder(
      bloc: AuthBloc.instance,
      builder: (BuildContext context, User user) => BlocBuilder(
          bloc: _bloc,
          builder: (BuildContext context, Challenge challenge) => ProfileList(
                  users: [
                    Stream.fromFuture(Future.value(user)),
                    for (var friend in user.friendsList)
                      if (challenge.participants.contains(friend.userId))
                        Stream.fromFuture(Future.value(friend))
                  ],
                  iconSize: Scalar(context).scale(55),
                  iconOffset: Scalar(context).scale(-10),
                  onTap: _onTap,
                  hasMoreIcon: !challenge.started,
                  color: _color,
                  borderWidth: 5)));
}
