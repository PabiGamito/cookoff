import 'package:cookoff/blocs/auth_bloc.dart';
import 'package:cookoff/models/user.dart';
import 'package:cookoff/providers/auth_provider.dart';
import 'package:cookoff/providers/user_provider.dart';
import 'package:cookoff/widgets/fragment.dart';
import 'package:cookoff/widgets/home_header.dart';
import 'package:cookoff/widgets/injector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'home.dart';
import 'ingredients.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider =
        InjectorWidget.of(context).injector.authProvider;
    UserProvider userProvider =
        InjectorWidget.of(context).injector.userProvider;
    return StreamBuilder<User>(
        stream: authProvider.profile,
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (!snapshot.hasData) {
            AuthBloc.instance.dispatch(NullUser());
            return UnauthorizedMainScreen();
          }
          if (snapshot.data == null) {
            AuthBloc.instance.dispatch(NullUser());
            return UnauthorizedMainScreen();
          } else {
            // User is signed in
            User user = snapshot.data;
            // Notify auth bloc
            AuthBloc.instance.dispatch(user);
            LoadingAuthBloc.instance.dispatch(false);
            // Retrieve friends
            return StreamBuilder<Iterable<User>>(
                stream: userProvider.friends(user.userId),
                builder: (BuildContext context,
                    AsyncSnapshot<Iterable<User>> snapshot) {
                  // Set friends list and notify auth bloc
                  AuthBloc.instance
                      .dispatch(User.copyWithFriendsList(user, snapshot.data));
                  return AuthorizedMainScreen();
                });
          }
        });
  }
}

class AuthorizedMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthProvider provider = InjectorWidget.of(context).injector.authProvider;

    return Container(
      color: Color(0xFFFFC544),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
            padding: EdgeInsets.only(top: 65, bottom: 25),
            child: BlocBuilder(
              bloc: AuthBloc.instance,
              builder: (BuildContext context, User user) {
                // Tapping the header signs out the user for now
                return GestureDetector(
                  child: HomeHeader(user: user, notificationCount: 3),
                  onTap: () {
                    AuthBloc.instance.dispatch(NullUser());
                    provider.signOut();
                  },
                );
              },
            )),
        Expanded(
          child: FragmentContainer(
            startingFragment: 'home',
            fragments: {
              'home': HomeScreen(),
              'ingredients': IngredientsScreen(),
            },
          ),
        ),
      ]),
    );
  }
}

// Home screen to be rendered if the user is not signed on
class UnauthorizedMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider =
        InjectorWidget.of(context).injector.authProvider;
    return Container(
        color: Color(0xFFFFC544),
        child: Center(
          child: BlocBuilder(
              bloc: LoadingAuthBloc.instance,
              builder: (BuildContext context, bool loading) => GestureDetector(
                  onTap: () {
                    LoadingAuthBloc.instance.dispatch(true);
                    // disable button while loading
                    if (!loading) {
                      authProvider.signIn();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFF52C7F2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      loading ? 'Loading...' : 'Sign In with Google',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Montserrat",
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ))),
        ));
  }
}
