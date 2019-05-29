import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String _name;
  final int _notificationCount;
  final String _profileImagePath;

  HomeHeader(String name, int notificationCount, String profileImagePath)
      : _name = name,
        _notificationCount = notificationCount,
        _profileImagePath = profileImagePath;

  @override
  Widget build(BuildContext context) => Container(
        child: Row(
          children: <Widget>[
            Container(
              child: new Container(
                width: MediaQuery.of(context).size.width * 0.25,
                height: MediaQuery.of(context).size.width * 0.25,
                margin: const EdgeInsets.all(10.0),
                decoration: new BoxDecoration(
                    border: Border.all(color: Colors.white, width: 5),
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/Elena.jpg'))),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'HELLO',
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'Montserrat',
                    color: Color(0xFFFFFFFF),
                    letterSpacing: 2.0,
                  ),
                  textAlign: TextAlign.left,
                ),
                Text(
                  _name,
                  style: TextStyle(
                    fontSize: 42,
                    fontFamily: 'Montserrat',
                    color: Color(0xFF333333),
                    height: 0.8,
                  ),
                  textAlign: TextAlign.left,
                )
              ],
            ),
          ],
        ),
      );
}
