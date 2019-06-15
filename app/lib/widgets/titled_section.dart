import 'package:cookoff/scalar.dart';
import 'package:flutter/material.dart';

class TitledSection extends StatelessWidget {
  final String _title;
  final Color _titleColor;
  final Color _underlineColor;
  final Widget _child;

  const TitledSection(
      {String title,
      Color titleColor = Colors.black,
      Color underlineColor,
      Widget child})
      : _title = title,
        _titleColor = titleColor,
        _underlineColor = underlineColor,
        _child = child;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: Scaler(context).scale(35)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_title,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: Scaler(context).scale(25),
                        color: _titleColor),
                    textAlign: TextAlign.left),
                Container(
                  margin: EdgeInsets.only(
                      top: Scaler(context).scale(10),
                      bottom: Scaler(context).scale(35)),
                  width: Scaler(context).scale(35),
                  height: Scaler(context).scale(6),
                  decoration: new BoxDecoration(
                    color: _underlineColor,
                    borderRadius: BorderRadius.circular(1000),
                  ),
                ),
              ],
            ),
          ),
          _child
        ],
      );
}
