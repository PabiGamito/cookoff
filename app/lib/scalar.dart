import 'package:flutter/widgets.dart';

class Scaler {
  static const _smallHeight = 450;
  static const _largeHeight = 890;

  static const _smallScalar = 0.7;
  static const _largeScalar = 1;

  static const _gradient =
      (_largeScalar - _smallScalar) / (_largeHeight - _smallHeight);
  static const _intercept = _smallScalar - _gradient * _smallHeight;

  final double _scalar;

  Scaler(BuildContext context)
      : _scalar = _gradient * MediaQuery.of(context).size.height + _intercept;

  double scale(double value) => value * _scalar;
}
