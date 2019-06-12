import 'package:cookoff/injector.dart';
import 'package:cookoff/models/user.dart';
import 'package:cookoff/screens/main.dart';
import 'package:cookoff/widgets/injector_widget.dart';
import 'package:cookoff/widgets/user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future main() async {
  var injector = Injector();
  var widget = InjectorWidget(
      injector: injector,
      child: StreamBuilder<User>(
          stream: injector.authProvider.userStream(),
          builder: (context, snapshot) {
            return UserWidget(user: snapshot.data, child: App());
          }));

  // Set status bar color on android to match header
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.amber,
  ));

  runApp(widget);
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
