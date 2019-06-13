import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class ScrollBru extends StatefulWidget {
  final Color _color;
  final ScrollController _controller;

  ScrollBru({@required Color color, @required ScrollController controller})
      : _color = color,
        _controller = controller;

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
  Widget build(BuildContext context) =>
      Container(height: _height, color: widget._color);
}
