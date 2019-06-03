import 'package:flutter/material.dart';

class TitledSection extends StatelessWidget {
  final String _title;
  final double _titleSize;
  final Color _titleColor;
  final Color _underlineColor;
  final Widget _child;

  const TitledSection(
      {String title,
      double titleSize = 25,
      Color titleColor = Colors.black,
      Color underlineColor,
      Widget child})
      : _title = title,
        _titleSize = titleSize,
        _titleColor = titleColor,
        _underlineColor = underlineColor,
        _child = child;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            _title,
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: _titleSize,
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
