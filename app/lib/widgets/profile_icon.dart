import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfileIcon extends StatelessWidget {
  final double size;
  final String _imgPath;

  ProfileIcon(this.size, String imgPath) : _imgPath = imgPath;

  @override
  Widget build(BuildContext context) => Container(
        child: new Container(
          width: size,
          height: size,
          margin: const EdgeInsets.all(10.0),
          decoration: new BoxDecoration(
              border: Border.all(color: Colors.white, width: 5),
              shape: BoxShape.circle,
              image: new DecorationImage(
                  fit: BoxFit.cover, image: AssetImage(_imgPath))),
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
      margin: const EdgeInsets.all(10.0),
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
