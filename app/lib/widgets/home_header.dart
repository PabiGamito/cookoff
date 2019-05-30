import 'package:cookoff/widgets/profile_icon.dart';
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: [
                Positioned(
                    child: ProfileIcon(
                  _profileImagePath,
                  size: 108,
                  borderWidth: 5,
                )),
                if (_notificationCount > 0)
                  Positioned(
                      top: 3,
                      right: 8,
                      child: NotificationBadge(_notificationCount))
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: 20),
              child: HelloMessage(_name),
            ),
          ],
        ),
      );
}

class HelloMessage extends StatelessWidget {
  final String _name;

  HelloMessage(String name) : _name = name;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'HELLO',
            style: TextStyle(
              fontSize: 22,
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
      );
}

class NotificationBadge extends StatelessWidget {
  final int _notificationCount;

  NotificationBadge(int notificationCount)
      : _notificationCount = notificationCount;

  @override
  Widget build(BuildContext context) => Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Color(0xFFE5505E),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: Text(
            _notificationCount.toString(),
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontFamily: 'Montserrat'),
          ),
        ),
      );
}
