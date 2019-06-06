import 'package:cookoff/scalar.dart';
import 'package:flutter/widgets.dart';

class SectionTitle extends StatelessWidget {
  final String _title;
  final Color _color;
  final double _fontSize;

  const SectionTitle({String title, Color color, double fontSize})
      : _title = title,
        _color = color,
        _fontSize = fontSize;

  @override
  Widget build(BuildContext context) => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _title,
              style: TextStyle(fontSize: _fontSize, fontFamily: 'Montserrat'),
              textAlign: TextAlign.left,
            ),
            Container(
                margin: EdgeInsets.only(top: Scaler(context).scale(10)),
                width: Scaler(context).scale(35),
                height: Scaler(context).scale(6),
                decoration: new BoxDecoration(
                  color: _color,
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.03),
                ))
          ],
        ),
      );
}
