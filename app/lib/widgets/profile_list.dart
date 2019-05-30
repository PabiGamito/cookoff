import 'package:cookoff/widgets/profile_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfileList extends StatelessWidget {
  final List<ProfileIcon> _profiles;
  final bool _hasMoreIcon;
  final double _iconOffset;
  final double overallOffset;
  final Function _onTap;
  final double _iconSize;

  ProfileList(List<ProfileIcon> profiles,
      {Function onTap,
      bool hasMoreIcon = true,
      double iconOffset = 0,
      double iconSize = 50})
      : _onTap = onTap,
        _profiles = profiles,
        _iconOffset = iconOffset + iconSize,
        _hasMoreIcon = hasMoreIcon,
        _iconSize = profiles.length != 0 ? profiles[0].size : iconSize,
        overallOffset = profiles.length * iconSize / 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _iconSize,
      child: Stack(children: [
        for (int i = 0; i < _profiles.length; i++)
          Positioned(left: _iconOffset * i, child: _profiles[i]),
        if (_hasMoreIcon)
          Positioned(
            left: _iconOffset * _profiles.length,
            child: Center(
              child: GestureDetector(
                onTap: _onTap,
                child: AddProfileIcon(_iconSize),
              ),
            ),
          ),
      ]),
    );
  }
}
