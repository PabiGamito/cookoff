import 'package:cookoff/widgets/profile_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfileList extends StatelessWidget {
  final List<ProfileIcon> _profiles;
  final bool _hasMoreIcon;
  final double _iconOffset;
  final double overallOffset;

  ProfileList(List<ProfileIcon> profiles,
      {bool hasMoreIcon = true, double iconOffset = 0})
      : _profiles = profiles,
        _iconOffset = iconOffset + profiles[0].size,
        _hasMoreIcon = hasMoreIcon,
        overallOffset = profiles.length * profiles[0].size / 2;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      for (int i = 0; i < _profiles.length; i++)
        Container(
            transform: Matrix4.translationValues(_iconOffset * i, 0, 0),
            child: _profiles[i]),
      if (_hasMoreIcon)
        Container(
          transform:
              Matrix4.translationValues(_iconOffset * _profiles.length, 0, 0),
          child: AddProfileIcon(_profiles[0].size),
        ),
    ]);
  }
}
