import 'dart:math';

import 'package:cookoff/models/user.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class ProfileIcon extends StatelessWidget {
  // Placeholder for null profile
  static const String _placeholderUrl =
      'https://firebasestorage.googleapis.com/v0/b/pomegranate-catfish.appspot.'
      'com/o/240_F_64672736_U5kpdGs9keUll8CRQ3p3YaEv2M6qkVY5.jpg?alt=media&token'
      '=3c1cb58c-f054-4fc1-a684-734b4ee0e3d3';
  static const double _borderWidthScale = 0.6;

  final User _user;
  final double _size;
  final bool _border;

  ProfileIcon({@required User user, @required double size, bool border = true})
      : _user = user,
        _size = size,
        _border = border;

  @override
  Widget build(BuildContext context) => Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
          border: Border.all(
              color: Colors.white,
              width: _border ? sqrt(_size) * _borderWidthScale : 0),
          shape: BoxShape.circle,
          image: DecorationImage(
              fit: BoxFit.cover,
              image:
                  NetworkImage(_user?.profilePictureUrl ?? _placeholderUrl))));
}

class AddProfileIcon extends StatelessWidget {
  static const double _textScale = 0.6;

  final double _size;
  final Color _color;

  AddProfileIcon({@required double size, Color color})
      : _size = size,
        _color = color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 5),
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Center(
        child: Text(
          "+",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: _size * _textScale,
            color: _color,
          ),
        ),
      ),
    );
  }
}

class MoreProfileIcon extends StatelessWidget {
  static const double _textScale = 0.4;

  final int _count;
  final double _size;
  final Color _color;

  MoreProfileIcon(
      {@required int count, @required double size, @required Color color})
      : _count = count,
        _size = size,
        _color = color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 5),
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Center(
        child: Text(
          "+$_count",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: _size * _textScale,
            color: _color,
          ),
        ),
      ),
    );
  }
}
