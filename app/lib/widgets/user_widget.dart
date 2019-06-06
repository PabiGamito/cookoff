import 'package:cookoff/models/user.dart';
import 'package:flutter/widgets.dart';

class UserWidget extends InheritedWidget {
  final User user;

  UserWidget({Key key, @required this.user, @required Widget child})
      : super(key: key, child: child);

  factory UserWidget.of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(UserWidget) as UserWidget;

  @override
  bool updateShouldNotify(UserWidget old) => user != old.user;
}
