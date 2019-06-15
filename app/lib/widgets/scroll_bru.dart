import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class ScrollBru extends StatefulWidget {
  final ScrollController _controller;
  final Widget Function(double) _bru;

  ScrollBru(
      {@required ScrollController controller, Widget Function(double) bru})
      : _controller = controller,
        _bru = bru;

  @override
  _ScrollBruState createState() => _ScrollBruState(_controller);
}

class _ScrollBruState extends State<ScrollBru> {
  double _height = 0;

  _ScrollBruState(ScrollController controller) {
    controller.addListener(() {
      setState(() {
        if (controller.hasClients && controller.offset > 0) {
          _height = controller.offset;
        } else {
          _height = 0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) => widget._bru(_height);
}
