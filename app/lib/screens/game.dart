import 'package:cookoff/blocs/auth_bloc.dart';
import 'package:cookoff/blocs/friends_selection_bloc.dart';
import 'package:cookoff/models/challenge.dart';
import 'package:cookoff/models/user.dart';
import 'package:cookoff/providers/challenge_provider.dart';
import 'package:cookoff/scalar.dart';
import 'package:cookoff/widgets/countdown.dart';
import 'package:cookoff/widgets/duration_picker.dart';
import 'package:cookoff/widgets/friends_card.dart';
import 'package:cookoff/widgets/game_screen_ui.dart';
import 'package:cookoff/widgets/injector_widget.dart';
import 'package:cookoff/widgets/profile_list.dart';
import 'package:cookoff/widgets/rounded_card.dart';
import 'package:cookoff/widgets/scrollable.dart';
import 'package:cookoff/widgets/titled_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

class GameScreen extends StatefulWidget {
  final String _ingredientName;
  final Color _bgColor;
  final Challenge _challenge;

  GameScreen(String ingredientName, Color bgColor, {Challenge challenge})
      : _challenge = challenge,
        _ingredientName =
            challenge == null ? ingredientName : challenge.ingredient,
        _bgColor = bgColor;

  @override
  State<StatefulWidget> createState() =>
      _GameScreenState(_ingredientName, _bgColor, _challenge);
}

class _GameScreenState extends State<GameScreen> {
  final FriendsSelectionBloc _friendsBloc = FriendsSelectionBloc();
  final String _ingredientName;
  final Color _bgColor;
  final double _smallProfileScale = 0.13;

  Challenge _challenge;
  double _cardHeight = 0.0;
  bool _displayPlayers = true;
  bool _displayFriends = false;
  bool _gameStarted;
  Duration _gameDuration;

  Countdown _timeLeftWidget;

  _GameScreenState(String ingredientName, Color bgColor, [Challenge challenge])
      : _challenge = challenge,
        _ingredientName = ingredientName,
        _bgColor = bgColor {
    _gameStarted = _challenge != null;
    _timeLeftWidget = _challenge != null ? Countdown(_challenge.end) : null;
  }

  void _popScreen() {
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
      statusBarColor: _bgColor,
    ));
  }

  @override
  Widget build(BuildContext context) {
    ChallengeProvider challengeProvider =
        InjectorWidget.of(context).injector.challengeProvider;
    var mediaSize = MediaQuery.of(context).size;

    var _iconPath = "assets/ingredients/${_ingredientName.toLowerCase()}.png";

    return WillPopScope(
      onWillPop: () {
        _popScreen();
      },
      child: BlocBuilder(
          bloc: _friendsBloc,
          builder: (BuildContext context, Set<String> ticked) {
            return Container(
              color: _bgColor,
              child: Stack(children: <Widget>[
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GameBackButton(_popScreen),
                      IngredientName(_ingredientName),
                      IngredientIcon(
                        Scalar(context).scale(180),
                        _iconPath,
                        margin: EdgeInsets.only(
                          bottom: Scalar(context).scale(50),
                        ),
                      ),
                      // Duration Button
                      Visibility(
                          visible: !_gameStarted,
                          child: DurationPicker(
                            duration: _gameDuration,
                            bgColor: _bgColor,
                            onDurationChange: (DateTime time) {
                              setState(() {
                                _gameDuration = Duration(
                                    days: time.day - 1,
                                    minutes: time.minute,
                                    hours: time.hour);
                              });
                            },
                          )),

                      // Start button
                      BlocBuilder(
                          bloc: AuthBloc.instance,
                          builder: (BuildContext context, User owner) =>
                              GameStartButton(
                                onGameStart: () {
                                  setState(() {
                                    _challenge = Challenge(
                                        owner: owner.userId,
                                        participants: List.of(ticked)
                                          ..add(owner.userId),
                                        ingredient: _ingredientName,
                                        complete: false,
                                        end: DateTime.now().add(_gameDuration ??
                                            Duration(days: 1)));
                                    challengeProvider.addChallenge(_challenge);
                                    _gameStarted = true;
                                    _timeLeftWidget = Countdown(_challenge.end);
                                  });
                                },
                                gameStarted: _gameStarted,
                                countdownWidget: _timeLeftWidget,
                              )),
                      // Friends list display
                      Center(
                        child: Visibility(
                          visible: _displayPlayers,
                          child: Container(
                              height:
                                  mediaSize.width * _smallProfileScale * 1.4,
                              child: BlocBuilder(
                                  bloc: AuthBloc.instance,
                                  builder: (BuildContext context, User user) =>
                                      ProfileList(
                                        user.friendsList
                                            .where((friend) {
                                              var list = _gameStarted
                                                  ? _challenge.participants
                                                  : ticked;
                                              return list
                                                  .contains(friend.userId);
                                            })
                                            .map(
                                                (user) => Observable.just(user))
                                            .toList(),
                                        iconSize: Scalar(context).scale(55),
                                        iconOffset: Scalar(context).scale(-10),
                                        hasMoreIcon: !_gameStarted,
                                        onTap: () {
                                          setState(() {
                                            _displayFriends = true;
                                            _cardHeight = 0;
                                          });
                                        },
                                        color: _bgColor,
                                      ))),
                        ),
                      ),
                      Container(
                        height: Scalar(context).scale(90),
                      )
                    ]),
                // Inspiration tab
                VerticalScrollable(
                  heightOffset: _cardHeight,
                  initialHeight: mediaSize.height,
                  initialWidth: mediaSize.width,
                  maxHeight: mediaSize.height * 0.76,
                  initialHeightOffset: mediaSize.height * 0.89,
                  child: RoundedCard(
                      child: TitledSection(
                          title: 'Some inspiration...',
                          underlineColor: Color(_bgColor.value + 0x00112211),
                          child: Container(
                            padding: EdgeInsets.only(
                                bottom: Scalar(context).scale(20)),
                          ))),
                ),
                // Friends tab
                Visibility(
                  visible: _displayFriends,
                  child: Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => setState(() {
                                _displayFriends = false;
                                _cardHeight = 0;
                              }),
                          child: Container(
                            height: mediaSize.height,
                            width: mediaSize.width,
                            color: Color(0x66000000),
                          ),
                        ),
                        ListView(
                            physics: BouncingScrollPhysics(),
                            padding: EdgeInsets.zero,
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height -
                                        Scalar(context).scale(500)),
                                child: FriendsCard(bloc: _friendsBloc),
                              )
                            ]),
                        FriendsSelectButton(onTap: () {
                          setState(() {
                            _displayFriends = false;
                            _cardHeight = 0;
                          });
                        })
                      ]),
                ),
              ]),
            );
          }),
    );
  }
}
