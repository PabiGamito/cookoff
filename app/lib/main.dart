import 'package:cookoff/screens/home.dart';
import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      MaterialApp(home: Scaffold(body: HomeScreen()));
}
