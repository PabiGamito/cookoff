import 'package:cookoff/blocs/auth_bloc.dart';
import 'package:cookoff/models/user.dart';
import 'package:cookoff/providers/auth_provider.dart';
import 'package:cookoff/providers/user_provider.dart';
import 'package:flutter/material.dart';

// Widget to control sign in process
class AuthWidget extends StatelessWidget {
  const AuthWidget(
      {this.authProvider,
      this.userProvider,
      this.authorizedScreen,
      this.unauthorizedScreen,
      this.authBloc,
      this.loadingBloc});

  // data providers
  final AuthProvider authProvider;
  final UserProvider userProvider;

  // render screens conditionally depending on sign-in status
  final Widget authorizedScreen;
  final Widget unauthorizedScreen;

  // bloc to hold user model
  final AuthBloc authBloc;

  // bloc to hold loading status
  final LoadingAuthBloc loadingBloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: authProvider.profile,
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (!snapshot.hasData) {
            authBloc.dispatch(NullUser());
            return unauthorizedScreen;
          }
          if (snapshot.data == null) {
            authBloc.dispatch(NullUser());
            return unauthorizedScreen;
          } else {
            // User is signed in
            User user = snapshot.data;
            // Notify auth bloc
            authBloc.dispatch(user);
            loadingBloc.dispatch(false);
            // Retrieve friends
            return StreamBuilder<Iterable<User>>(
                stream: userProvider.friendsStream(user.userId),
                builder: (BuildContext context,
                    AsyncSnapshot<Iterable<User>> snapshot) {
                  // Set friends list and notify auth bloc
                  authBloc.dispatch(user.copyWithFriendsList(snapshot.data));
                  return authorizedScreen;
                });
          }
        });
  }
}
