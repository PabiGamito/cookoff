import 'package:cookoff/screens/main.dart';
import 'package:cookoff/widgets/injector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'injector.dart';

void main() {
  var injector = InjectorWidget(child: App(), injector: Injector());

  // Set status bar color on android to match header
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Color(0xFFFFC544),
  ));

  runApp(injector);
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      MaterialApp(home: Scaffold(body: MainScreen()));
}
