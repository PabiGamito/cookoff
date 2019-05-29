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
    const iconScale = 0.45;
    var iconDistanceScale = 0.05;
    var initial;
    var distance;
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
                          top: MediaQuery.of(context).size.height * 0.04),
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.05),
                      child: Text(
                        "\u{2190}",
                        style: TextStyle(
                            fontSize: 60,
                            fontFamily: "Montserrat",
                            color: Colors.white),
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
                          fontSize: 45,
                          fontFamily: "Montserrat",
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Ingredient Icon
                  Container(
                    width: MediaQuery.of(context).size.width * iconScale,
                    height: MediaQuery.of(context).size.width * iconScale,
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height *
                            iconDistanceScale),
                    child: Image.asset(_iconPath),
                  ),
                  // Start button
                  GestureDetector(
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height *
                                iconDistanceScale),
                        decoration: BoxDecoration(
                          color: Color(_bgColor.value - 0x00141414  ),
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
                                height: 50,
                                width: 50,
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
                                      color: Colors.white),
                                ),
                              ),
                            ]),
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
                          topLeft: Radius.elliptical(50, 30),
                          topRight: Radius.elliptical(50, 30)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SectionTitle(
                          'Some inspiration...',
                          Color(_bgColor.value + 0x00112211),
                          fontSize: 22,
                        ),
                      ],
                    ),
                  )
                ])));
  }
}
