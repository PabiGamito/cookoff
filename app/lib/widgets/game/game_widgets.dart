import 'package:cookoff/blocs/game_bloc.dart';
import 'package:cookoff/blocs/game_event.dart';
import 'package:cookoff/models/challenge.dart';
import 'package:cookoff/models/ingredient.dart';
import 'package:cookoff/scalar.dart';
import 'package:cookoff/screens/camera.dart';
import 'package:cookoff/widgets/countdown.dart';
import 'package:cookoff/widgets/duration_picker.dart';
import 'package:cookoff/widgets/injector_widget.dart';
import 'package:cookoff/widgets/profile_list.dart';
import 'package:cookoff/widgets/user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../camera.dart';

class GameHeader extends StatelessWidget {
  final Function _onExit;
  final GameBloc _bloc;
  final Color _color;

  GameHeader({Function onExit, GameBloc bloc, Color color})
      : _onExit = onExit,
        _bloc = bloc,
        _color = color;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: Color(0x50000000),
            borderRadius: BorderRadius.circular(1000)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GameBackButton(onTap: _onExit),
            GameDurationText(bloc: _bloc),
            GameTimeButton(
              bloc: _bloc,
              color: _color,
            )
          ],
        ),
      );
}

class GameBackButton extends StatelessWidget {
  final Function _onTap;

  GameBackButton({Function onTap}) : _onTap = onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: _onTap,
        child: Container(
          width: Scaler(context).scale(100),
          height: Scaler(context).scale(60),
          child: Icon(Icons.keyboard_backspace,
              color: Colors.white, size: Scaler(context).scale(40)),
        ),
      );
}

class GameDurationText extends StatelessWidget {
  final GameBloc _bloc;

  const GameDurationText({GameBloc bloc}) : _bloc = bloc;

  @override
  Widget build(BuildContext context) => BlocBuilder<GameEvent, Challenge>(
      bloc: _bloc,
      builder: (context, challenge) {
        if (challenge.end == null) {
          return Container();
        }
        if (challenge.started) {
          return Countdown(
            end: challenge.end,
            callback: () => {
                  if (!challenge.complete)
                    {
                      _bloc.dispatch(CompleteChallenge(
                          InjectorWidget.of(context)
                              .injector
                              .challengeProvider))
                    }
                },
          );
        } else {
          return TimeText(
            duration: challenge.end.difference(DateTime(0, 0, 0)),
            alwaysShowHours: true,
            alwaysShowMinutes: true,
          );
        }
      });
}

class GameTimeButton extends StatelessWidget {
  final GameBloc _bloc;
  final Color _color;

  const GameTimeButton({Key key, GameBloc bloc, Color color})
      : _bloc = bloc,
        _color = color;

  @override
  Widget build(BuildContext context) => BlocBuilder<GameEvent, Challenge>(
        bloc: _bloc,
        builder: (context, challenge) => challenge.started
            ? _GameTimeIcon()
            : _GameTimeButton(
                bloc: _bloc,
                color: _color,
              ),
      );
}

class _GameTimeButton extends StatelessWidget {
  final GameBloc _bloc;
  final Color _color;

  const _GameTimeButton({Key key, GameBloc bloc, Color color})
      : _bloc = bloc,
        _color = color;

  @override
  Widget build(BuildContext context) => BlocBuilder<GameEvent, Challenge>(
        bloc: _bloc,
        builder: (context, challenge) => DurationPicker(
              onDurationChange: (DateTime duration) {
                _bloc.dispatch(SetDuration(duration,
                    InjectorWidget.of(context).injector.challengeProvider));
              },
              child: Container(
                width: Scaler(context).scale(70),
                height: Scaler(context).scale(70),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(Scaler(context).scale(40)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x33FFFFFF),
                      spreadRadius: Scaler(context).scale(1),
                    )
                  ],
                ),
                child: Icon(Icons.timer,
                    color: _color, size: Scaler(context).scale(38)),
              ),
            ),
      );
}

class _GameTimeIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: Scaler(context).scale(70),
        height: Scaler(context).scale(70),
        decoration: BoxDecoration(
          color: Color(0x00000000),
          borderRadius: BorderRadius.circular(Scaler(context).scale(40)),
          boxShadow: [
            BoxShadow(
              color: Color(0x00000000),
              spreadRadius: Scaler(context).scale(1),
            )
          ],
        ),
        child: Icon(Icons.timer,
            color: Colors.white, size: Scaler(context).scale(38)),
      );
}

class IngredientName extends StatelessWidget {
  final Ingredient _ingredient;

  IngredientName({Ingredient ingredient}) : _ingredient = ingredient;

  @override
  Widget build(BuildContext context) => Column(children: <Widget>[
        Text(
            '${_ingredient.name[0].toUpperCase()}${_ingredient.name.substring(1)}',
            style: TextStyle(
                fontSize: Scaler(context).scale(45),
                fontFamily: 'Montserrat',
                color: Colors.white,
                letterSpacing: 2)),
        Container(
            margin: EdgeInsets.only(top: Scaler(context).scale(15)),
            width: Scaler(context).scale(45),
            height: Scaler(context).scale(8),
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
      width: Scaler(context).scale(160),
      height: Scaler(context).scale(160),
      child: Image.asset(_ingredient.imgPath));
}

class GameScreenButton extends StatelessWidget {
  final Color _color;
  final GameBloc _bloc;

  GameScreenButton({Color color, GameBloc bloc})
      : _color = color,
        _bloc = bloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: _bloc,
        builder: (BuildContext context, Challenge challenge) {
          var user = UserWidget.of(context).user;
          if (challenge.userHasFinished(user) || challenge.complete) {
            return GameScreenBrowseButton(
              color: _color,
              bloc: _bloc,
            );
          } else if (challenge.started) {
            return GameSubmitButton(
              color: _color,
              bloc: _bloc,
            );
          } else {
            return GameStartButton(
              color: _color,
              bloc: _bloc,
            );
          }
        });
  }
}

class GameStartButton extends StatelessWidget {
  final Color _color;
  final GameBloc _bloc;

  GameStartButton({Color color, GameBloc bloc})
      : _color = color,
        _bloc = bloc;

  @override
  Widget build(BuildContext context) => BlocBuilder<GameEvent, Challenge>(
        bloc: _bloc,
        builder: (context, snapshot) => _GameScreenButton(
              color: _color,
              bloc: _bloc,
              text: "START",
              icon: Container(
                height: Scaler(context).scale(50),
                width: Scaler(context).scale(50),
                margin: EdgeInsets.only(right: Scaler(context).scale(15)),
                child: Transform.rotate(
                  angle: 1.1,
                  child: Image.asset("assets/icons/rocket.png", color: _color),
                ),
              ),
              onTap: () {
                if (snapshot.participants.length <= 1) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text('Can\'t start challenge'),
                          content: Text(
                              'Please add at least one friend to the challenge.'),
                          actions: [
                            FlatButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                  );
                } else {
                  _bloc.dispatch(GameButton(
                      InjectorWidget.of(context).injector.challengeProvider));
                }
              },
            ),
      );
}

class GameSubmitButton extends StatelessWidget {
  final Color _color;
  final GameBloc _bloc;

  GameSubmitButton({Color color, GameBloc bloc})
      : _color = color,
        _bloc = bloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameEvent, Challenge>(
      bloc: _bloc,
      builder: (context, challenge) => _GameScreenButton(
            color: _color,
            text: "SUBMIT",
            icon: Container(
              height: Scaler(context).scale(50),
              width: Scaler(context).scale(50),
              margin: EdgeInsets.only(right: Scaler(context).scale(15)),
              child: Icon(
                Icons.add_a_photo,
                color: _color,
                size: Scaler(context).scale(35),
              ),
            ),
            onTap: () async {
              var compressedImage = await getImageFromSource();
              if (compressedImage != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Scaffold(
                          body: CameraScreen(
                            backgroundColor: _color,
                            bloc: _bloc,
                            image: compressedImage,
                          ),
                        ),
                  ),
                );
              }
            },
          ),
    );
  }
}

class GameScreenBrowseButton extends StatelessWidget {
  final Color _color;
  final GameBloc _bloc;

  GameScreenBrowseButton({Color color, GameBloc bloc})
      : _color = color,
        _bloc = bloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameEvent, Challenge>(
      bloc: _bloc,
      builder: (context, challenge) => _GameScreenButton(
            color: _color,
            text: "BROWSE",
            icon: Container(
              height: Scaler(context).scale(50),
              width: Scaler(context).scale(50),
              margin: EdgeInsets.only(right: Scaler(context).scale(15)),
              child: Icon(
                Icons.photo,
                color: _color,
                size: Scaler(context).scale(35),
              ),
            ),
            onTap: () {
              // Open friends image carousel
            },
          ),
    );
  }
}

class _GameScreenButton extends StatelessWidget {
  final Color _color;
  final Function _onTap;
  final String _text;
  final Widget _icon;

  _GameScreenButton(
      {Color color, GameBloc bloc, Function onTap, String text, Widget icon})
      : _color = color,
        _onTap = onTap,
        _text = text,
        _icon = icon;

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: _onTap,
      child: Container(
          width: Scaler(context).scale(265),
          padding: EdgeInsets.symmetric(vertical: Scaler(context).scale(6)),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.all(Radius.circular(Scaler(context).scale(30)))),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _icon,
                Text(_text,
                    style: TextStyle(
                      fontSize: Scaler(context).scale(23),
                      fontFamily: "Montserrat",
                      color: _color,
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
              size: Scaler(context).scale(60),
              color: _color,
              maxIcons: 4,
              onAddMore: challenge.started ? null : _onTap));
}
