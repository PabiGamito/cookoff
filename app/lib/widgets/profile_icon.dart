import 'package:cookoff/models/user.dart';
import 'package:flutter/material.dart';

class ProfileIcon extends StatelessWidget {
  // Placeholder for null profile
  static const String _placeholderUrl =
      'https://firebasestorage.googleapis.com/v0/b/pomegranate-catfish.appspot.'
      'com/o/240_F_64672736_U5kpdGs9keUll8CRQ3p3YaEv2M6qkVY5.jpg?alt=media&token'
      '=3c1cb58c-f054-4fc1-a684-734b4ee0e3d3';

  final User _user;
  final double _size;
  final double _borderWidth;

  ProfileIcon({User user, double size, double borderWidth})
      : _user = user,
        _size = size,
        _borderWidth = borderWidth;

  @override
  Widget build(BuildContext context) => Container(
        child: new Container(
          width: _size,
          height: _size,
          decoration: new BoxDecoration(
              border: Border.all(color: Colors.white, width: _borderWidth),
              shape: BoxShape.circle,
              image: new DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      _user?.profilePictureUrl ?? _placeholderUrl))),
        ),
      );
}

class AddProfileIcon extends StatelessWidget {
  final double size;
  final Color _textColor;
  final double _textScale;

  AddProfileIcon(this.size, {Color textColor, double textScale = 0.6})
      : _textColor = textColor ?? Color(0xAA000000),
        _textScale = textScale;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: new BoxDecoration(
        border: Border.all(color: Colors.white, width: 5),
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Center(
        child: Text(
          "+",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: size * _textScale,
            color: _textColor,
          ),
        ),
      ),
    );
  }
}

class MoreUsersCount extends StatelessWidget {
  final int _count;
  final double size;
  final Color _textColor;
  final double _textScale;

  MoreUsersCount(
      {Color textColor,
      double textScale = 0.5,
      @required count,
      @required this.size})
      : _textColor = textColor ?? Color(0xAA000000),
        _textScale = textScale,
        _count = count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: new BoxDecoration(
        border: Border.all(color: Colors.white, width: 5),
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Center(
        child: Text(
          "+$_count",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: size * _textScale,
            color: _textColor,
          ),
        ),
      ),
    );
  }
}
