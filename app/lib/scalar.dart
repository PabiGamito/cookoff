import 'package:flutter/widgets.dart';

class Scalar {
  static const _smallHeight = 100;
  static const _largeHeight = 500;

  static const _smallScalar = 1;
  static const _largeScalar = 2;

  static const _gradient =
      (_largeScalar - _smallScalar) / (_largeHeight - _smallHeight);
  static const _intercept = _smallScalar - _gradient * _smallHeight;

  final double _scalar;

  Scalar(BuildContext context)
      : _scalar = _gradient * MediaQuery.of(context).size.height + _intercept;

  double scale(double value) => value * _scalar;
}
