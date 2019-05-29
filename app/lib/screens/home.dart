import 'package:cookoff/widgets/featured_section.dart';
import 'package:cookoff/widgets/home_header.dart';
import 'package:cookoff/widgets/section_title.dart';
import 'package:cookoff/widgets/tile_carousel.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    const double sectionOverlayHeight = 100;
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Container(
          color: Color(0xFFFFC544),
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Container(
              padding: EdgeInsets.only(top: 25, bottom: 25),
              child: HomeHeader('Veronica', 3, 'assets/veronica.png'),
            ),
            Container(
              padding: EdgeInsets.only(bottom: sectionOverlayHeight),
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(50, 30),
                    topRight: Radius.elliptical(50, 30)),
              ),
              child: FeaturedSection('Start cooking...', Color(0xFF8EE5B6)),
            ),
//            Expanded(
            Container(
              transform: Matrix4.translationValues(0, -sectionOverlayHeight, 0),
              padding: EdgeInsets.all(20),
              decoration: new BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.elliptical(50, 30),
                    topRight: Radius.elliptical(50, 30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SectionTitle('My challanges', Color(0xFF8057E2)),
                  TileCarousel(),
                ],
              ),
            ),
//            ),
          ])),
    );
  }
}
