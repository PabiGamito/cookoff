import 'package:cookoff/widgets/profile_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfileList extends StatelessWidget {
  final List<ProfileIcon> _profiles;
  final bool _hasMoreIcon;
  final double _iconOffset;
  final double overallOffset;
  final Function _onTap;

  ProfileList(List<ProfileIcon> profiles, {Function onTap, bool hasMoreIcon = true, double iconOffset = 0})
      : _onTap = onTap,
        _profiles = profiles,
        _iconOffset = iconOffset + profiles[0].size,
        _hasMoreIcon = hasMoreIcon,
        overallOffset = profiles.length * profiles[0].size / 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _profiles[0].size ,
      child: Stack(children: [
      for (int i = 0; i < _profiles.length; i++)
        Positioned(left: _iconOffset * i, child: _profiles[i]),
      if (_hasMoreIcon)
        Positioned(
          left: _iconOffset * _profiles.length,
          child: GestureDetector(
            onTap: _onTap,
            child: AddProfileIcon(_profiles[0].size),
          ),
        ),
    ]),);
  }
}
