import 'package:cookoff/scalar.dart';
import 'package:flutter/material.dart';

class RoundedCard extends StatelessWidget {
  final Color _backgroundColor;
  final Widget _child;

  const RoundedCard(
      {Color backgroundColor = Colors.white, EdgeInsets padding, Widget child})
      : _backgroundColor = backgroundColor,
        _child = child;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: Scaler(context).scale(45)),
        decoration: new BoxDecoration(
            color: _backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(Scaler(context).scale(38)),
              topRight: Radius.circular(Scaler(context).scale(38)),
            )),
        child: _child);
  }
}
