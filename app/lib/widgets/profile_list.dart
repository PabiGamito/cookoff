import 'package:cookoff/models/user.dart';
import 'package:cookoff/widgets/profile_icon.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

// Builds profile icons from a list of user streams
class ProfileList extends StatelessWidget {
  static const double _offsetScale = 0.2;

  final List<Stream<User>> _users;
  final double _size;
  final Color _color;
  final int _maxIcons;
  final Function _onAddMore;

  const ProfileList(
      {@required List<Stream<User>> users,
      @required double size,
      @required Color color,
      @required int maxIcons,
      Function onAddMore})
      : _users = users,
        _size = size,
        _color = color,
        _maxIcons = maxIcons,
        _onAddMore = onAddMore;

  @override
  Widget build(BuildContext context) {
    var offset = _size * _offsetScale;

    var users = _users.take(_maxIcons);
    var hiddenUsers = _users.length - users.length;

    var widgets = [
      for (var user in users)
        StreamBuilder<User>(
            stream: user,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ProfileIcon(user: snapshot.data, size: _size);
              } else {
                return Container();
              }
            }),
      if (hiddenUsers > 0)
        MoreProfileIcon(count: hiddenUsers, size: _size, color: _color),
      if (_onAddMore != null) AddProfileIcon(size: _size, color: _color)
    ];

    return GestureDetector(
      onTap: _onAddMore ?? () {},
      child: Container(
        width: (_size - offset) * (widgets.length - 1) + _size,
        height: _size,
        child: Stack(children: [
          for (var i = 0; i < widgets.length; i++)
            Positioned(
                left: (_size - offset) * i, width: _size, child: widgets[i])
        ]),
      ),
    );
  }
}
