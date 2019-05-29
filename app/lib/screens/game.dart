import 'package:cookoff/widgets/profile_icon.dart';
import 'package:cookoff/widgets/profile_list.dart';
import 'package:cookoff/widgets/section_title.dart';
import 'package:flutter/material.dart';

class Game extends StatelessWidget {
  final String ingredientName;
  final String _iconPath;
  final Color _bgColor;

  Game(this.ingredientName, String iconPath, Color bgColor)
      : _iconPath = iconPath,
        _bgColor = bgColor;

  @override
  Widget build(BuildContext context) {
    const iconScale = 0.2;
    var iconDistanceScale = 0.05;
    var initial;
    var iconList = [
      ProfileIcon(50, "assets/faces/betty.jpg"),
      ProfileIcon(50, "assets/faces/jughead.png"),
    ];
    var distance;
    print(MediaQuery.of(context).size.width * 0.135);
    return GestureDetector(
        onPanStart: (DragStartDetails details) {
          initial = details.globalPosition.dx;
        },
        onPanUpdate: (DragUpdateDetails details) {
          distance = details.globalPosition.dx - initial;
        },
        onPanEnd: (DragEndDetails details) {
          print(initial);
          initial = 0.0;
          // Right swipe
          if (distance < -200.0) {
            // change page
            Navigator.pop(context);
          }
        },
        child: Container(
            color: _bgColor,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.04,
                        bottom: MediaQuery.of(context).size.height * 0.02,
                      ),
                      margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.05),
                      child: Text(
                        "\u{2190}",
                        style: TextStyle(
                          fontSize: 60,
                          fontFamily: "Montserrat",
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Ingredient Name
                  Center(
                    child: Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.0,
                          bottom: MediaQuery.of(context).size.height * 0.0),
                      child: Text(
                        "${ingredientName[0].toUpperCase()}${ingredientName.substring(1)}",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.06,
                          fontFamily: "Montserrat",
                          color: Colors.white,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                  // Ingredient Icon
                  Container(
                    width: MediaQuery.of(context).size.height * iconScale,
                    height: MediaQuery.of(context).size.height * iconScale,
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * iconDistanceScale),
                    child: Image.asset(_iconPath),
                  ),
                  // Start button
                  GestureDetector(
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.005,
                          bottom: MediaQuery.of(context).size.height * 0.005,
                          left: MediaQuery.of(context).size.height * 0.01,
                          right: MediaQuery.of(context).size.height * 0.01,
                        ),
                        margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * iconDistanceScale),
                        decoration: BoxDecoration(
                          color: Color(_bgColor.value - 0x15404040),
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
                                height: MediaQuery.of(context).size.width * 0.135,
                                width: MediaQuery.of(context).size.width * 0.135,
                                child: Transform.rotate(
                                  angle: 1.2,
                                  child: Image.asset("assets/icons/rocket.png"),
                                ),
                              ),
                              // Text
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
                    child: Container(
                      transform: Matrix4.translationValues(
                          (iconList.length / 2).roundToDouble() * -50.0, 0, 0),
                      child: ProfileList(
                        iconList,
                        iconOffset: -10,
                      ),
                    ),
                  ),
                  // Inspiration tab
                  Container(
                    padding: EdgeInsets.only(
                      top: 30,
                      left: 20,
                    ),
                    decoration: new BoxDecoration(
                      color: Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.elliptical(50, 30), topRight: Radius.elliptical(50, 30)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SectionTitle(
                          'Some inspiration...',
                          Color(_bgColor.value + 0x00112211),
                          fontSize: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02),
                        )
                      ],
                    ),
                  )
                ])));
  }
}
