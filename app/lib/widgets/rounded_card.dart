import 'package:cookoff/scalar.dart';
import 'package:flutter/material.dart';

class RoundedCard extends StatelessWidget {
  final Color _backgroundColor;
  final Widget _child;

  const RoundedCard({Color backgroundColor = Colors.white, Widget child})
      : _backgroundColor = backgroundColor,
        _child = child;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(
            vertical: Scalar(context).scale(45),
            horizontal: Scalar(context).scale(35)),
        decoration: new BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Scalar(context).scale(38)),
              topRight: Radius.circular(Scalar(context).scale(38)),
            )),
        child: _child);
  }
}
