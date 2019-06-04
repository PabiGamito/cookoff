import 'package:cookoff/scalar.dart';
import 'package:cookoff/widgets/rounded_card.dart';
import 'package:cookoff/widgets/titled_section.dart';
import 'package:flutter/material.dart';

class InspirationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ListView(
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Container(
                height: MediaQuery.of(context).size.height -
                    Scalar(context).scale(140)),
            RoundedCard(
              child: TitledSection(
                  title: 'Some inspiration',
                  underlineColor: Color(0xFFEB8EC0),
                  child: Container()),
            )
          ]),
    );
  }
}
