import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'injector.dart';
import 'screens/main.dart';
import 'widgets/injector_widget.dart';

void main() {
  var injector = InjectorWidget(child: App(), injector: Injector());

  // Set status bar color on android to match header
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.amber,
  ));

  runApp(injector);
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: MainScreen(),
      ),
    );
  }
}
