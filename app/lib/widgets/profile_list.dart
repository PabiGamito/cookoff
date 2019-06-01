import 'package:cookoff/models/user.dart';
import 'package:cookoff/widgets/profile_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// class builds profile icons from a list of a stream of users
class ProfileList extends StatelessWidget {
  final List<Stream<User>> _users;
  final bool _hasMoreIcon;
  final double _iconOffset;
  final double overallOffset;
  final Function _onTap;
  final double _iconSize;

  // placeholder for null profile image
  static const String placeholderUrl =
      'https://firebasestorage.googleapis.com/v0/b/pomegranate-catfish.appspot.'
      'com/o/240_F_64672736_U5kpdGs9keUll8CRQ3p3YaEv2M6qkVY5.jpg?alt=media&token'
      '=3c1cb58c-f054-4fc1-a684-734b4ee0e3d3';

  ProfileList(List<Stream<User>> users,
      {Function onTap,
      bool hasMoreIcon = true,
      double iconOffset = 0,
      double iconSize})
      : _onTap = onTap,
        _users = users,
        _iconOffset = iconOffset + iconSize,
        _hasMoreIcon = hasMoreIcon,
        _iconSize = iconSize,
        overallOffset = users.length * iconSize / 2;

  @override
  Widget build(BuildContext context) {
    // convert list of stream of users into streamBuilders
    List<StreamBuilder<User>> iconBuilders = [];
    for (var i = 0; i < _users.length; i++) {
      iconBuilders.add(StreamBuilder(
        stream: _users[i],
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          String url = snapshot.data == null
              ? placeholderUrl
              : snapshot.data.profilePictureUrl;
          return Positioned(
              left: _iconOffset * i,
              child: ProfileIcon(
                url,
                size: _iconSize,
              ));
        },
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
              child: AddProfileIcon(_iconSize),
            ),
          ),
      ]),
    );
  }
}
