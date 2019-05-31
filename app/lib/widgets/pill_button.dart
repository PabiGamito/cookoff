import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PillButton extends StatelessWidget {
  final String _text;
  final void Function() _onTap;

  PillButton(String text, {@required void Function() onTap})
      : _text = text,
        _onTap = onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: _onTap,
        child: Container(
          child: Container(
            padding: EdgeInsets.only(
              top: 15,
              bottom: 15,
              left: 50,
              right: 50,
            ),
            decoration: new BoxDecoration(
              color: Color(0xFF8057E2),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                _text,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: "Montserrat",
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
        ),
      );
}
