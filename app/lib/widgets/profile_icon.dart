import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfileIcon extends StatelessWidget {
  final double _size;
  final String _imgPath;

  ProfileIcon(double size, String imgPath)
      : _size = size,
        _imgPath = imgPath;

  @override
  Widget build(BuildContext context) => Container(
        child: new Container(
          width: _size,
          height: _size,
          margin: const EdgeInsets.all(10.0),
          decoration: new BoxDecoration(
              border: Border.all(color: Colors.white, width: 5),
              shape: BoxShape.circle,
              image: new DecorationImage(
                  fit: BoxFit.cover, image: AssetImage(_imgPath))),
        ),
      );
}
