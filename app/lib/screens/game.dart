import 'package:cookoff/blocs/friends_bloc.dart';
import 'package:cookoff/models/challenge.dart';
import 'package:cookoff/providers/challenge_provider.dart';
import 'package:cookoff/scalar.dart';
import 'package:cookoff/widgets/card_helper.dart';
import 'package:cookoff/widgets/countdown.dart';
import 'package:cookoff/widgets/friends_selection.dart';
import 'package:cookoff/widgets/game_screen_ui.dart';
import 'package:cookoff/widgets/injector_widget.dart';
import 'package:cookoff/widgets/profile_icon.dart';
import 'package:cookoff/widgets/profile_list.dart';
import 'package:cookoff/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameScreen extends StatefulWidget {
  final String _ingredientName;
  final String _iconPath;
  final Color _bgColor;
  final Challenge _challenge;

  GameScreen(String ingredientName, String iconPath, Color bgColor,
      {Challenge challenge})
      : _challenge = challenge,
        _ingredientName =
            challenge == null ? ingredientName : challenge.ingredient,
        _iconPath = challenge == null
            ? iconPath
            : "assets/ingredients/${challenge.ingredient.toLowerCase()}.png",
        _bgColor = bgColor;

  @override
  State<StatefulWidget> createState() =>
      _GameScreenState(_ingredientName, _iconPath, _bgColor, _challenge);
}

class _GameScreenState extends State<GameScreen> {
  final FriendsBloc _friendsBloc = FriendsBloc();
  final String _ingredientName;
  final String _iconPath;
  final Color _bgColor;
  final double _smallProfileScale = 0.13;

  Challenge _challenge;
  double _cardHeight = 0.0;
  double _dragPos = 0.0;
  bool _displayPlayers = true;
  bool _displayFriends = false;
  bool _gameStarted;
  Duration _duration = Duration(days: 1, hours: 1);
  String _owner = "elena";
  Countdown _timeLeftWidget;

  _GameScreenState(String ingredientName, String iconPath, Color bgColor,
      [Challenge challenge])
      : _challenge = challenge,
        _ingredientName = ingredientName,
        _iconPath = iconPath,
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
    var initial = 0.0;
    var friendsList = <ProfileIcon>[
      ProfileIcon(
          "https://t4.ftcdn.net/jpg/00/64/67/27/240_F_64672736_U5kpdGs9keUll8CRQ3p3YaEv2M6qkVY5.jpg",
          size: mediaSize.width * 0.155,
          profileName: "Archie Candoro"),
      ProfileIcon(
          "https://t4.ftcdn.net/jpg/00/64/67/27/240_F_64672736_U5kpdGs9keUll8CRQ3p3YaEv2M6qkVY5.jpg",
          size: mediaSize.width * 0.155,
          profileName: "Cheryl Sinatra"),
      ProfileIcon(
        "https://t4.ftcdn.net/jpg/00/64/67/27/240_F_64672736_U5kpdGs9keUll8CRQ3p3YaEv2M6qkVY5.jpg",
        size: mediaSize.width * 0.155,
        profileName: "Betty White",
      ),
      ProfileIcon(
          "https://t4.ftcdn.net/jpg/00/64/67/27/240_F_64672736_U5kpdGs9keUll8CRQ3p3YaEv2M6qkVY5.jpg",
          size: mediaSize.width * 0.155,
          profileName: "Jughead Jones"),
    ];

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

                      // Start button
                      GameStartButton(
                        onGameStart: () {
                          setState(() {
                            _challenge = Challenge(
                                owner: _owner,
                                participants: List.of(ticked)..add(_owner),
                                ingredient: _ingredientName,
                                complete: false,
                                end: DateTime.now().add(_duration));
                            challengeProvider.addChallenge(_challenge);
                            _gameStarted = true;
                            _timeLeftWidget = Countdown(_challenge.end);
                          });
                        },
                        gameStarted: _gameStarted,
                        countdownWidget: _timeLeftWidget,
                      ),
                      // Friends list display
                      Center(
                        child: Visibility(
                          visible: _displayPlayers,
                          child: Container(
                            height: mediaSize.width * _smallProfileScale * 1.4,
                            child: ProfileList(
                              friendsList.where((f) {
                                var list = _gameStarted
                                    ? _challenge.participants
                                    : ticked;
                                return list.contains(f.name);
                              }).toList(),
                              iconSize: Scalar(context).scale(50),
                              iconOffset: Scalar(context).scale(-10),
                              hasMoreIcon: !_gameStarted,
                              onTap: () {
                                setState(() {
                                  _displayFriends = true;
                                  _cardHeight = 0;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: Scalar(context).scale(90),
                      )
                    ]),
                // Inspiration tab
                Visibility(
                  visible: !_displayFriends,
                  child: Container(
                    transform: Matrix4.translationValues(
                        0, mediaSize.height * 0.89 - _cardHeight, 0),
                    child: GestureDetector(
                      onPanStart: (DragStartDetails details) {
                        _dragPos = details.globalPosition.dy;
                      },
                      onPanUpdate: (DragUpdateDetails details) {
                        var change = details.globalPosition.dy - _dragPos;
                        if (_cardHeight - change >= 0 &&
                            _cardHeight - change < mediaSize.height * 0.76)
                          setState(() {
                            _cardHeight -= change;
                          });
                        _dragPos = details.globalPosition.dy;
                      },
                      child: CardRoundedBorder(
                        cardHeight: _cardHeight,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SectionTitle(
                              'Some inspiration...',
                              Color(_bgColor.value + 0x00112211),
                              fontSize: Scalar(context).scale(25),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  bottom: Scalar(context).scale(20)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Friends tab
                Visibility(
                  visible: _displayFriends,
                  child: Center(
                    child: Stack(children: <Widget>[
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
                      Container(
                        height: mediaSize.height,
                        width: mediaSize.width,
                        transform: Matrix4.translationValues(
                            0, mediaSize.height * 0.45 - _cardHeight, 0),
                        child: GestureDetector(
                          onPanStart: (DragStartDetails details) {
                            _dragPos = details.globalPosition.dy;
                          },
                          onPanUpdate: (DragUpdateDetails details) {
                            var change = details.globalPosition.dy - _dragPos;
                            if (_cardHeight - change >= 0 &&
                                _cardHeight - change < mediaSize.height * 0.3)
                              setState(() {
                                _cardHeight -= change;
                              });
                            _dragPos = details.globalPosition.dy;
                          },
                          child: CardRoundedBorder(
                            cardHeight: _cardHeight,
                            child: FriendsTab(
                              friendsBloc: _friendsBloc,
                              friendsList: friendsList,
                              tickedFriends: ticked,
                              cardHeight: _cardHeight,
                              onSelect: () {
                                setState(() {
                                  _displayFriends = false;
                                  _cardHeight = 0;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
              ]),
            );
          }),
    );
  }
}
