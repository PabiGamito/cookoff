import 'package:cookoff/screens/home.dart';
import 'package:cookoff/widgets/injector_widget.dart';
import 'package:flutter/material.dart';

import 'injector.dart';

void main() {
  final injector = InjectorWidget(child: App(), injector: Injector());
  runApp(injector);
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      MaterialApp(home: Scaffold(body: HomeScreen()));
}
