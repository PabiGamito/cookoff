import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class FragmentContainer extends StatefulWidget {
  final String _startingFragment;
  final Map<String, Widget> _fragments;

  FragmentContainer(
      {@required String startingFragment,
      @required Map<String, Widget> fragments})
      : _startingFragment = startingFragment,
        _fragments = fragments;

  @override
  State<StatefulWidget> createState() {
    return FragmentContainerState(
      startingFragment: _startingFragment,
      fragments: _fragments,
    );
  }
}

class FragmentContainerState extends State<FragmentContainer> {
  final Map<String, Widget> _fragments;
  String _currentFragmentId;
  final List<String> _backstack;

  FragmentContainerState(
      {@required String startingFragment,
      @required Map<String, Widget> fragments})
      : _fragments = fragments,
        _currentFragmentId = startingFragment,
        _backstack = [startingFragment];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        customPop(context);
      },
      child: Fragment(
        child: _fragments[_currentFragmentId],
        navigateTo: navigateTo,
        pop: customPop,
      ),
    );
  }

  void navigateTo(String id) {
    _backstack.add(id);
    setState(() {
      _currentFragmentId = id;
    });
  }

  void navigateBack(String id) {
    setState(() {
      _currentFragmentId = id;
    });
  }

  void customPop(BuildContext context) {
    if (_backstack.length - 1 > 0) {
      _backstack.removeLast();
      navigateBack(_backstack.last);
    } else {
      _backstack.removeAt(_backstack.length - 1);
      if (!Navigator.pop(context)) {
        SystemNavigator.pop();
      }
    }
  }
}

class Fragment extends StatelessWidget {
  final Widget _child;
  final void Function(String) _navigateTo;
  final void Function(BuildContext) _pop;

  Fragment(
      {@required Widget child,
      @required void Function(String) navigateTo,
      @required void Function(BuildContext) pop})
      : _child = child,
        _navigateTo = navigateTo,
        _pop = pop;

  void navigateTo(String fragmentId) {
    _navigateTo(fragmentId);
  }

  @override
  Widget build(BuildContext context) {
    return _child;
  }

  void pop(BuildContext context) {
    _pop(context);
  }
}

class FragmentNavigator {
  static void navigateTo(BuildContext context, String fragmentId) {
    Fragment ancestorFragment = context.ancestorWidgetOfExactType(Fragment);
    ancestorFragment.navigateTo(fragmentId);
  }

  static void pop(BuildContext context) {
    Fragment ancestorFragment = context.ancestorWidgetOfExactType(Fragment);
    ancestorFragment.pop(context);
  }
}
