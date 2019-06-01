import 'package:cookoff/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfileIcon extends StatelessWidget {
  final String imgPath;
  final double size;
  final double _borderWidth;
  final name;

  ProfileIcon(this.imgPath,
      {this.size = 50, double borderWidth = 5, String profileName})
      : name = profileName ?? imgPath,
        _borderWidth = borderWidth;

  @override
  Widget build(BuildContext context) => Container(
        child: new Container(
          width: size,
          height: size,
          decoration: new BoxDecoration(
              border: Border.all(color: Colors.white, width: _borderWidth),
              shape: BoxShape.circle,
              image: new DecorationImage(
                  fit: BoxFit.cover, image: NetworkImage(imgPath))),
        ),
      );

  factory ProfileIcon.fromUser(User user, {size = 50, borderWidth = 5}) =>
      ProfileIcon(user.profilePictureUrl,
          profileName: user.name, size: size, borderWidth: borderWidth);
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
