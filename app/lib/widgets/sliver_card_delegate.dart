import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class SliverCardDelegate extends SliverPersistentHeaderDelegate {
  @override
  final double maxExtent;

  @override
  final double minExtent;

  final Widget _child;

  SliverCardDelegate(
      {@required this.maxExtent,
      @required this.minExtent,
      @required Widget child})
      : _child = child;

  @override
  Widget build(
          BuildContext context, double shrinkOffset, bool overlapsContent) =>
      ClipRect(
        child: OverflowBox(
          alignment: Alignment.topCenter,
          maxHeight: maxExtent,
          minHeight: maxExtent,
          child: _child,
        ),
      );

  @override
  bool shouldRebuild(SliverCardDelegate old) =>
      maxExtent != old.maxExtent ||
      minExtent != old.minExtent ||
      _child != old._child;
}
