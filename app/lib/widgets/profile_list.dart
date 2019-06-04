import 'package:cookoff/models/user.dart';
import 'package:cookoff/widgets/profile_icon.dart';
import 'package:flutter/material.dart';

// class builds profile icons from a list of a stream of users
class ProfileList extends StatelessWidget {
  final List<Stream<User>> _users;
  final bool _hasMoreIcon;
  final double _iconOffset;
  final double overallOffset;
  final Function _onTap;
  final double _iconSize;
  final Color _color;
  final double _borderWidth;

  ProfileList(
      {List<Stream<User>> users,
      Function onTap,
      bool hasMoreIcon = true,
      double iconOffset = 0,
      double iconSize,
      Color color,
      double borderWidth})
      : _onTap = onTap,
        _users = users,
        _iconOffset = iconOffset + iconSize,
        _hasMoreIcon = hasMoreIcon,
        _iconSize = iconSize,
        overallOffset = users.length * iconSize / 2,
        _color = color,
        _borderWidth = borderWidth;

  @override
  Widget build(BuildContext context) {
    // convert list of stream of users into streamBuilders
    List<StreamBuilder<User>> iconBuilders = [];
    for (var i = 0; i < _users.length; i++) {
      iconBuilders.add(StreamBuilder(
        stream: _users[i],
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) =>
            Positioned(
                left: _iconOffset * i,
                child: ProfileIcon(
                    user: snapshot.data,
                    size: _iconSize,
                    borderWidth: _borderWidth)),
      ));
    }

    // render streamBuilders
    return Container(
      height: _iconSize,
      width: _iconSize + _iconOffset * (_users.length - (_hasMoreIcon ? 0 : 1)),
      child: Stack(children: [
        ...iconBuilders,
        if (_hasMoreIcon)
          Positioned(
            left: _iconOffset * _users.length,
            child: GestureDetector(
              onTap: _onTap,
              child: AddProfileIcon(_iconSize, textColor: _color),
            ),
          ),
      ]),
    );
  }
}
