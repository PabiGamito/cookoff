import 'dart:math';

import 'package:cookoff/models/user.dart';
import 'package:cookoff/widgets/profile_icon.dart';
import 'package:flutter/material.dart';

// class builds profile icons from a list of a stream of users
class ProfileList extends StatelessWidget {
  final List<Stream<User>> _users;
  final int _maxUsersShown;
  final bool _addMoreIcon;
  final double _iconOffset;
  final double overallOffset;
  final Function _onTap;
  final double _iconSize;
  final Color _color;
  final double _borderWidth;

  ProfileList(
      {@required List<Stream<User>> users,
      int maxUsersShown,
      Function onTap,
      bool addMoreIcon = true,
      double iconOffset = 0,
      double iconSize,
      Color color,
      double borderWidth})
      : _onTap = onTap,
        _users = users,
        _maxUsersShown = maxUsersShown ?? users.length,
        _iconOffset = iconOffset + iconSize,
        _addMoreIcon = addMoreIcon,
        _iconSize = iconSize,
        overallOffset = users.length * iconSize / 2,
        _color = color,
        _borderWidth = borderWidth;

  @override
  Widget build(BuildContext context) {
    var _usersToShow = min(_maxUsersShown, _users.length);

    // convert list of stream of users into streamBuilders
    List<StreamBuilder<User>> iconBuilders = [];
    for (int i = 0; i < _usersToShow; i++) {
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
      width: _iconSize +
          _iconOffset *
              (_usersToShow -
                  1 +
                  (_addMoreIcon || _usersToShow < _users.length ? 1 : 0)),
      child: Stack(children: [
        ...iconBuilders,
        if (_addMoreIcon)
          Positioned(
            left: _iconOffset * _usersToShow,
            child: GestureDetector(
              onTap: _onTap,
              child: AddProfileIcon(_iconSize, textColor: _color),
            ),
          ),
        if (_usersToShow < _users.length)
          Positioned(
            left: _iconOffset * _usersToShow,
            child: MoreUsersCount(
                size: _iconSize, count: _users.length - _usersToShow),
          )
      ]),
    );
  }
}
