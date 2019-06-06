import 'package:cookoff/injector.dart';
import 'package:flutter/widgets.dart';

class InjectorWidget extends InheritedWidget {
  final Injector injector;

  InjectorWidget({Key key, @required this.injector, @required Widget child})
      : assert(child != null),
        assert(injector != null),
        super(key: key, child: child);

  static InjectorWidget of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(InjectorWidget) as InjectorWidget;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
