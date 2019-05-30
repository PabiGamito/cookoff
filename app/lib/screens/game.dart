import 'package:cookoff/widgets/profile_icon.dart';
import 'package:cookoff/widgets/profile_list.dart';
import 'package:cookoff/widgets/section_title.dart';
import 'package:flutter/material.dart';

class Game extends StatefulWidget {
  final String ingredientName;
  final String _iconPath;
  final Color _bgColor;

  Game(this.ingredientName, String iconPath, Color bgColor)
      : _iconPath = iconPath,
        _bgColor = bgColor;

  @override
  State<StatefulWidget> createState() =>
      _GameState(ingredientName, _iconPath, _bgColor);
}

class _GameState extends State<Game> {
  final String _ingredientName;
  final String _iconPath;
  final Color _bgColor;
  double _inspirationCardHeight = 0.0;
  double _dragPos = 0.0;
  bool _displayPlayers = true;

  _GameState(String ingredientName, String iconPath, Color bgColor)
      : _ingredientName = ingredientName,
        _iconPath = iconPath,
        _bgColor = bgColor;

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    const iconScale = 0.2;
    var iconDistanceScale = 0.05;
    // TODO: List of Profile Icons should be fetched
    var iconList = [
      ProfileIcon("assets/faces/betty.jpg", size: mediaSize.width * 0.13),
      ProfileIcon("assets/faces/jughead.png", size: mediaSize.width * 0.13),
    ];
    return Container(
        color: _bgColor,
        child: Column(
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
                  padding: EdgeInsets.only(
                      top: mediaSize.height * 0.0,
                      bottom: mediaSize.height * 0.0),
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
                      color: Color(_bgColor.value - 0x15505050),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
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
                              child: Image.asset("assets/icons/rocket.png"),
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
                ),
              ),
              // Friends list display
              Center(
                child: Visibility(
                  visible: _displayPlayers,
                  child: Container(
                    transform: Matrix4.translationValues(
                        (iconList.length / 2).roundToDouble() * -50.0, 0, 0),
                    child: ProfileList(
                      iconList,
                      iconOffset: -10,
                    ),
                  ),
                ),
              ),
              // Inspiration tab
              GestureDetector(
                onPanStart: (DragStartDetails details) {
                  _dragPos = details.globalPosition.dy;
                },
                onPanUpdate: (DragUpdateDetails details) {
                  var change = details.globalPosition.dy - _dragPos;
                  if (_inspirationCardHeight - change >= 0 &&
                      _inspirationCardHeight - change < 210)
                    setState(() {
                      _inspirationCardHeight -= change;
                      _displayPlayers = _inspirationCardHeight < 140;
                    });
                  _dragPos = details.globalPosition.dy;
                },
                child: Container(
                  height: _inspirationCardHeight + mediaSize.height * 0.13,
                  padding: EdgeInsets.only(
                    top: 30,
                    left: 20,
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
                        padding:
                            EdgeInsets.only(bottom: mediaSize.height * 0.02),
                      )
                    ],
                  ),
                ),
              ),
            ]));
  }
}
