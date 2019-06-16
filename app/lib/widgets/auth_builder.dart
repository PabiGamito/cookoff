import 'package:cookoff/blocs/auth_bloc.dart';
import 'package:cookoff/models/user.dart';
import 'package:cookoff/widgets/user_widget.dart';
import 'package:flutter/material.dart';

// Widget to control sign in process
class AuthBuilder extends StatelessWidget {
  // Render screens conditionally depending on sign-in status
  final Widget _authorizedScreen;
  final Widget _unauthorizedScreen;

  // Bloc to hold loading status
  final LoadingAuthBloc _loadingBloc;

  const AuthBuilder(
      {Widget authorizedScreen,
      Widget unauthorizedScreen,
      LoadingAuthBloc loadingBloc})
      : _authorizedScreen = authorizedScreen,
        _unauthorizedScreen = unauthorizedScreen,
        _loadingBloc = loadingBloc;

  @override
  Widget build(BuildContext context) {
    if (UserWidget.of(context).user == null ||
        UserWidget.of(context).user is NullUser) {
      return _unauthorizedScreen;
    }

    // Notify loading bloc
    _loadingBloc.dispatch(false);

    return _authorizedScreen;
  }
}
