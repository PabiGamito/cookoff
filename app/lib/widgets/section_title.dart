import 'package:flutter/widgets.dart';

class SectionTitle extends StatelessWidget {
  final String _title;
  final Color _color;

  const SectionTitle(String title, Color color)
      : _title = title,
        _color = color;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _title,
            style: TextStyle(fontSize: 25, fontFamily: 'Montserrat'),
            textAlign: TextAlign.left,
          ),
          Container(
              margin: EdgeInsets.only(top: 10),
              width: 45,
              height: 6,
              decoration: new BoxDecoration(
                color: _color,
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.03),
              ))
        ],
      ),
    );
  }
}