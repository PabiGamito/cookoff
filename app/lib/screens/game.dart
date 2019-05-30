import 'package:cookoff/blocs/friends_bloc.dart';
import 'package:cookoff/models/challenge.dart';
import 'package:cookoff/providers/challenge_provider.dart';
import 'package:cookoff/widgets/challanges_section.dart';
import 'package:cookoff/widgets/injector_widget.dart';
import 'package:cookoff/widgets/profile_icon.dart';
import 'package:cookoff/widgets/profile_list.dart';
import 'package:cookoff/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Game extends StatefulWidget {
  final String _ingredientName;
  final String _iconPath;
  final Color _bgColor;
  final Challenge _challenge;

  Game(String ingredientName, String iconPath, Color bgColor,
      {Challenge challenge})
      : _challenge = challenge,
        _ingredientName =
            challenge == null ? ingredientName : challenge.ingredient,
        _iconPath = challenge == null
            ? iconPath
            : "assets/ingredients/${challenge.ingredient}.png",
        _bgColor = bgColor;

  @override
  State<StatefulWidget> createState() =>
      _GameState(_ingredientName, _iconPath, _bgColor, _challenge);
}

class _GameState extends State<Game> {
  final FriendsBloc _friendsBloc = FriendsBloc();
  final String _ingredientName;
  final String _iconPath;
  final Color _bgColor;
  final double _smallProfileScale = 0.13;
  final double _largeProfileScale = 0.155;

  Challenge _challenge;
  double _inspirationCardHeight = 0.0;
  double _dragPos = 0.0;
  bool _displayPlayers = true;
  bool _displayFriends = false;
  bool _scrollableFriends = false;
  bool _gameStarted;
  Duration _duration = Duration(days: 1, hours: 1);
  String _owner = "elena";
  TimeLeftWidget _timeLeftWidget;

  _GameState(String ingredientName, String iconPath, Color bgColor,
      [Challenge challenge])
      : _challenge = challenge,
        _ingredientName = ingredientName,
        _iconPath = iconPath,
        _bgColor = bgColor {
    _gameStarted = _challenge != null;
    _timeLeftWidget =
        _challenge != null ? TimeLeftWidget(_challenge.end) : null;
  }

  @override
  Widget build(BuildContext context) {
    ChallengeProvider challengeProvider =
        InjectorWidget.of(context).injector.challengeProvider;
    var mediaSize = MediaQuery.of(context).size;
    const iconScale = 0.2;
    var iconDistanceScale = 0.05;
    // TODO: List of Profile Icons should be fetched
    var unjoinedFriends = <ProfileIcon>[
      ProfileIcon("assets/faces/archie.jpg",
          size: mediaSize.width * 0.155, profileName: "Archie Candoro"),
      ProfileIcon("assets/faces/cheryl.jpg",
          size: mediaSize.width * 0.155, profileName: "Cheryl Sinatra"),
      ProfileIcon(
        "assets/faces/betty.jpg",
        size: mediaSize.width * 0.155,
        profileName: "Betty White",
      ),
      ProfileIcon("assets/faces/jughead.png",
          size: mediaSize.width * 0.155, profileName: "Jughead Jones"),
    ];

    return BlocBuilder(
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
                    // Back Button
                    Container(
                      height: mediaSize.height * 0.15,
                      padding: EdgeInsets.only(
                        top: mediaSize.height * 0.04,
                        bottom: mediaSize.height * 0.02,
                      ),
                      margin: EdgeInsets.only(left: mediaSize.width * 0.05),
                      child: Wrap(children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "\u{2190}",
                            style: TextStyle(
                              fontSize: 60,
                              fontFamily: "Montserrat",
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ]),
                    ),
                    // Ingredient Name
                    Center(
                      child: Container(
                        child: Text(
                          "${_ingredientName[0].toUpperCase()}${_ingredientName.substring(1)}",
                          style: TextStyle(
                            fontSize: mediaSize.height * 0.06,
                            fontFamily: "Montserrat",
                            color: Colors.white,
                            letterSpacing: 2,
                          ),
                        ),
                      ),
                    ),
                    // Ingredient Icon
                    Container(
                      width: mediaSize.height * iconScale,
                      height: mediaSize.height * iconScale,
                      margin: EdgeInsets.only(
                          bottom: mediaSize.height * iconDistanceScale),
                      child: Image.asset(_iconPath),
                    ),
                    // Start button
                    GestureDetector(
                      onTap: () {
                        if (!_gameStarted) {
                          setState(() {
                            _challenge = Challenge(
                                owner: _owner,
                                participants: List.of(ticked)..add(_owner),
                                ingredient: _ingredientName,
                                complete: false,
                                end: DateTime.now().add(_duration));
                            challengeProvider.addChallenge(_challenge);
                            _gameStarted = true;
                            _timeLeftWidget = TimeLeftWidget(_challenge.end);
                          });
                        }
                      },
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.only(
                            top: mediaSize.height * 0.005,
                            bottom: mediaSize.height * 0.005,
                            left: mediaSize.width * 0.06,
                            right: mediaSize.width * 0.06,
                          ),
                          margin: EdgeInsets.only(
                              bottom: mediaSize.height * iconDistanceScale),
                          decoration: BoxDecoration(
                            color: Color(0x65000000),
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Visibility(
                              visible: !_gameStarted,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    // Rocket Icon
                                    Container(
                                      margin: EdgeInsets.only(
                                        left: 30,
                                      ),
                                      height: mediaSize.width * 0.135,
                                      width: mediaSize.width * 0.135,
                                      child: Transform.rotate(
                                        angle: 1.2,
                                        child: Image.asset(
                                            "assets/icons/rocket.png"),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        left: 10,
                                        right: 30,
                                      ),
                                      child: Text(
                                        "START",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: "Montserrat",
                                          color: Colors.white,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                            Visibility(
                              visible: _gameStarted,
                              child: Container(
                                margin: EdgeInsets.only(
                                  top: mediaSize.height * 0.01,
                                  bottom: mediaSize.height * 0.01,
                                  left: mediaSize.width * 0.03,
                                  right: mediaSize.width * 0.03,
                                ),
                                child: _timeLeftWidget,
                              ),
                            )
                          ]),
                        ),
                      ),
                    ),
                    // Friends list display
                    Center(
                      child: Visibility(
                        visible: _displayPlayers,
                        child: Center(
                          child: Container(
                            height: mediaSize.width * _smallProfileScale * 1.4,
                            child: ProfileList(
                              unjoinedFriends.where((f) {
                                var list = _gameStarted
                                    ? _challenge.participants
                                    : ticked;
                                return list.contains(f.name);
                              }).toList(),
                              iconOffset: -10,
                              hasMoreIcon: !_gameStarted,
                              onTap: () {
                                setState(() {
                                  _displayFriends = true;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Inspiration card offset
                    Container(
                      height: mediaSize.height * 0.1,
                    )
                  ]),
              // Inspiration tab
              Visibility(
                visible: !_displayFriends,
                child: Container(
                  transform: Matrix4.translationValues(
                      0, mediaSize.height * 0.89 - _inspirationCardHeight, 0),
                  child: GestureDetector(
                    onPanStart: (DragStartDetails details) {
                      _dragPos = details.globalPosition.dy;
                    },
                    onPanUpdate: (DragUpdateDetails details) {
                      var change = details.globalPosition.dy - _dragPos;
                      if (_inspirationCardHeight - change >= 0 &&
                          _inspirationCardHeight - change <
                              mediaSize.height * 0.76)
                        setState(() {
                          _inspirationCardHeight -= change;
                        });
                      _dragPos = details.globalPosition.dy;
                    },
                    child: Container(
                      height: _inspirationCardHeight + mediaSize.height * 0.13,
                      padding: EdgeInsets.only(
                        top: 30,
                        left: mediaSize.width * 0.07,
                      ),
                      decoration: new BoxDecoration(
                        color: Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.elliptical(50, 30),
                            topRight: Radius.elliptical(50, 30)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SectionTitle(
                            'Some inspiration...',
                            Color(_bgColor.value + 0x00112211),
                            fontSize: mediaSize.height * 0.03,
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                bottom: mediaSize.height * 0.02),
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
                      onTap: () {
                        setState(() {
                          _displayFriends = false;
                          _inspirationCardHeight = 0;
                        });
                      },
                      child: Container(
                        height: mediaSize.height,
                        width: mediaSize.width,
                        color: Color(0x66000000),
                      ),
                    ),
                    Container(
                      height: mediaSize.height,
                      width: mediaSize.width,
                      transform: Matrix4.translationValues(0,
                          mediaSize.height * 0.45 - _inspirationCardHeight, 0),
                      child: GestureDetector(
                        onPanStart: (DragStartDetails details) {
                          _dragPos = details.globalPosition.dy;
                        },
                        onPanUpdate: (DragUpdateDetails details) {
                          var change = details.globalPosition.dy - _dragPos;
                          if (_inspirationCardHeight - change >= 0 &&
                              _inspirationCardHeight - change <
                                  mediaSize.height * 0.185)
                            setState(() {
                              _inspirationCardHeight -= change;
                            });
                          _dragPos = details.globalPosition.dy;
                        },
                        child: Container(
                          height:
                              _inspirationCardHeight + mediaSize.height * 0.13,
                          padding: EdgeInsets.only(
                            top: 30,
                          ),
                          decoration: new BoxDecoration(
                            color: Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.elliptical(50, 30),
                                topRight: Radius.elliptical(50, 30)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                  left: mediaSize.width * 0.07,
                                ),
                                child: SectionTitle(
                                  'Friends',
                                  Color(0x00112211),
                                  fontSize: mediaSize.height * 0.03,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    bottom: mediaSize.height * 0.02),
                              ),
                              // Friends List
                              Container(
                                margin: EdgeInsets.only(
                                  left: mediaSize.width * 0.03,
                                ),
                                height: mediaSize.height * 0.27 +
                                    _inspirationCardHeight,
                                child: ListView(
                                    padding: EdgeInsets.only(top: 0),
                                    physics: NeverScrollableScrollPhysics(),
                                    children: [
                                      for (int i = 0;
                                          i < unjoinedFriends.length;
                                          i++)
                                        GestureDetector(
                                          onTap: () => _friendsBloc.dispatch(
                                              unjoinedFriends[i].name),
                                          child: Container(
                                            height: mediaSize.height * 0.1,
                                            margin: EdgeInsets.only(
                                              bottom: 10,
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                  child: unjoinedFriends[i],
                                                ),
                                                Container(
                                                  width: mediaSize.width * 0.55,
                                                  child: Text(
                                                    unjoinedFriends[i].name,
                                                    style: TextStyle(
                                                      fontSize:
                                                          mediaSize.width *
                                                              0.05,
                                                      fontFamily: "Montserrat",
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: mediaSize.width * 0.15,
                                                  height:
                                                      mediaSize.width * 0.15,
                                                  decoration: new BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: ticked.contains(
                                                            unjoinedFriends[i]
                                                                .name)
                                                        ? Colors.lightBlueAccent
                                                        : Colors.grey,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "\u{2713}",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            "Montserrat",
                                                        fontSize:
                                                            mediaSize.width *
                                                                0.09,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ]),
                              ),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _displayFriends = false;
                                      _inspirationCardHeight = 0;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: mediaSize.height * 0.03),
                                    width: mediaSize.width * 0.8,
                                    height: mediaSize.height * 0.08,
                                    decoration: new BoxDecoration(
                                        color: Colors.lightBlueAccent,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                mediaSize.width * 0.03))),
                                    child: Center(
                                      child: Text(
                                        "\u{2713} Select",
                                        style: TextStyle(
                                          fontSize: mediaSize.width * 0.07,
                                          fontFamily: "Montserrat",
                                          letterSpacing: 2,
                                          wordSpacing: 2,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            ]),
          );
        });
  }
}
