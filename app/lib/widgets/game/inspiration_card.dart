import 'package:cookoff/scalar.dart';
import 'package:cookoff/widgets/rounded_card.dart';
import 'package:cookoff/widgets/titled_section.dart';
import 'package:flutter/material.dart';

class InspirationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: RoundedCard(
        child: Container(
          padding: EdgeInsets.only(bottom: Scalar(context).scale(60)),
          child: TitledSection(
            title: 'Some inspiration',
            underlineColor: Color(0xFF65D2EB),
            child: Column(
              children: [
                Container(
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.red,
                ),
                Container(
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Card extends StatefulWidget {
  final Function _onClose;
  final Widget _child;

  const Card({Function onClose, Widget child})
      : _onClose = onClose,
        _child = child;

  @override
  _CardState createState() => _CardState();
}

class _CardState extends State<Card> {
  final ScrollController _controller = ScrollController();
  double _height = 0;

  _CardState() {
    _controller.addListener(() {
      setState(() {
        if (_controller.hasClients && _controller.offset > 0) {
          _height = _controller.offset;
        } else {
          _height = 0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) =>
      Stack(alignment: AlignmentDirectional.bottomEnd, children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          color: Color(0x80000000),
        ),
        Container(height: _height, color: Colors.white),
        ListView(
            controller: _controller,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: widget._onClose,
                  child: Container(
                      height: MediaQuery.of(context).size.height -
                          Scalar(context).scale(500))),
              widget._child,
            ]),
        FadedBottom(),
      ]);
}

class FadedBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        IgnorePointer(
          child: Container(
            height: Scalar(context).scale(35),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0.4, 1],
                colors: [
                  Color(0x00FFFFFF),
                  Color(0x80FFFFFF),
                  Color(0xFFFFFFFF),
                ],
              ),
            ),
          ),
        ),
      ]);
}
