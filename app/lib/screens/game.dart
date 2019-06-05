import 'package:cookoff/blocs/auth_bloc.dart';
import 'package:cookoff/blocs/game_bloc.dart';
import 'package:cookoff/blocs/game_event.dart';
import 'package:cookoff/models/challenge.dart';
import 'package:cookoff/scalar.dart';
import 'package:cookoff/widgets/game/friends_tab.dart';
import 'package:cookoff/widgets/game/game_widgets.dart';
import 'package:cookoff/widgets/game/inspiration_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'camera.dart';

class GameScreen extends StatefulWidget {
  final Challenge _challenge;
  final Color _color;

  GameScreen.fromIngredient({String ingredient, Color color})
      : _challenge = Challenge(ingredient),
        _color = color;

  GameScreen.fromChallenge({Challenge challenge, Color color})
      : _challenge = challenge,
        _color = color;

  @override
  State<StatefulWidget> createState() => _GameScreenState(_challenge);
}

class _GameScreenState extends State<GameScreen> {
  final GameBloc _bloc;
  bool _friendsTabOpen = false;

  _GameScreenState(Challenge challenge) : _bloc = GameBloc(challenge) {
    AuthBloc.instance.state.listen((user) => _bloc.dispatch(SetOwner(user)));
  }

  _popScreen() {
    // Close the friends tab on back press
    if (_friendsTabOpen) {
      _friendsTabOpen = false;
      return;
    }

    // Set status bar color on Android to match header
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Color(0xFFFFC544),
    ));

    Navigator.pop(context);
  }

  @override
  initState() {
    super.initState();
    // Set status bar color on android to match header
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: widget._color,
    ));
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
      onWillPop: () {
        _popScreen();
      },
      child: Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: <Widget>[
            Container(color: widget._color),
            Container(
              padding: EdgeInsets.symmetric(
                  vertical: Scalar(context).scale(60),
                  horizontal: Scalar(context).scale(35)),
              margin: EdgeInsets.only(bottom: Scalar(context).scale(130)),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GameHeader(onExit: _popScreen, bloc: _bloc),
                    IngredientName(bloc: _bloc),
                    IngredientIcon(bloc: _bloc),
                    GameStartButton(color: widget._color, bloc: _bloc),
                    CameraButton(
                      backgroundColor: widget._color,
                    ),
                    FriendProfiles(
                        color: widget._color,
                        onTap: () {
                          setState(() {
                            _friendsTabOpen = true;
                          });
                        },
                        bloc: _bloc)
                  ]),
            ),
            InspirationCard(),
            Visibility(
                visible: _friendsTabOpen,
                child: FriendsTab(
                    onClose: () {
                      setState(() {
                        _friendsTabOpen = false;
                      });
                    },
                    bloc: _bloc))
          ]));
}

class CameraButton extends StatelessWidget {
  final Color _bgColor;

  CameraButton({Color backgroundColor}) : _bgColor = backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
                  body: CameraScreen(backgroundColor: _bgColor),
                ),
          ),
        );
      },
      child: Container(
        height: 60,
        margin: EdgeInsets.symmetric(horizontal: Scalar(context).scale(170)),
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(30))),
        child: Center(
          child: Icon(
            Icons.photo_camera,
            color: Colors.lightBlue,
          ),
        ),
      ),
    );
  }
}
