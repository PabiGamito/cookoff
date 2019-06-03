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
        children: <Widget>[
          Text(
            _title,
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: Scalar(context).scale(25),
                color: _titleColor),
            textAlign: TextAlign.left,
          ),
          Container(
              margin: EdgeInsets.only(top: 10, bottom: 35),
              width: 45,
              height: 6,
              decoration: new BoxDecoration(
                color: _underlineColor,
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.03),
              )),
          _child
        ],
      );
}
