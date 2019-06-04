import 'package:cookoff/injector.dart';
import 'package:flutter/widgets.dart';

class InjectorWidget extends InheritedWidget {
  final Injector injector;

  InjectorWidget({Key key, @required Widget child, @required Injector injector})
      : assert(child != null),
        assert(injector != null),
        this.injector = injector,
        super(key: key, child: child);

  static InjectorWidget of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(InjectorWidget)
        as InjectorWidget;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
