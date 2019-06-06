import 'package:cookoff/models/user.dart';
import 'package:cookoff/scalar.dart';
import 'package:cookoff/widgets/profile_icon.dart';
import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final User _user;
  final int _notificationCount;

  HomeHeader({User user, int notificationCount})
      : _user = user,
        _notificationCount = notificationCount;

  @override
  Widget build(BuildContext context) => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: [
                Positioned(
                  child: Container(
                    margin: EdgeInsets.all(Scaler(context).scale(10)),
                    child: ProfileIcon(
                      user: _user,
                      size: Scaler(context).scale(118),
                      borderWidth: Scaler(context).scale(7),
                    ),
                  ),
                ),
                if (_notificationCount > 0)
                  Positioned(
                      top: Scaler(context).scale(3),
                      right: Scaler(context).scale(8),
                      child: NotificationBadge(_notificationCount))
              ],
            ),
            Container(
              margin: EdgeInsets.only(left: Scaler(context).scale(20)),
              child: HelloMessage(_user.firstName),
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
                fontSize: Scaler(context).scale(22),
                fontFamily: 'Montserrat',
                color: Colors.white,
                letterSpacing: 4),
            textAlign: TextAlign.left,
          ),
          Text(
            _name,
            style: TextStyle(
                fontSize: Scaler(context).scale(42),
                fontFamily: 'Montserrat',
                color: Colors.black,
                height: 0.8),
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
        width: Scaler(context).scale(40),
        height: Scaler(context).scale(40),
        decoration: BoxDecoration(
          color: Color(0xFFE5505E),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Center(
          child: Text(
            _notificationCount.toString(),
            style: TextStyle(
                color: Colors.white,
                fontSize: Scaler(context).scale(18),
                fontFamily: 'Montserrat'),
          ),
        ),
      );
}
