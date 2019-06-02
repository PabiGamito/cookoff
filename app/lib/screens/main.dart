import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_bloc.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../scalar.dart';
import '../widgets/fragment.dart';
import '../widgets/home_header.dart';
import '../widgets/injector_widget.dart';
import '../widgets/scrollable_card.dart';
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
                  return NewAuthorizedMainScreen();
                });
          }
        });
  }
}

class NewAuthorizedMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScrollableCard(
      maxHeight: MediaQuery.of(context).size.height,
      // TODO: Figure out a better way to get these values
      minHeight: MediaQuery.of(context).size.height -
          (Scalar(context).scale(65) + Scalar(context).scale(25)),
      // Container padding top, Container padding bottom, HomeHeader height,
      background: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color(0xFFFFC544),
        child: Container(
          padding: EdgeInsets.only(
              top: Scalar(context).scale(65),
              bottom: Scalar(context).scale(25)),
          child: BlocBuilder(
            bloc: AuthBloc.instance,
            builder: (BuildContext context, User user) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [HomeHeader(user: user, notificationCount: 3)],
              );
            },
          ),
        ),
      ),
      card: FragmentContainer(
        startingFragment: 'home',
        fragments: {
          'home': NewHomeScreen(),
          'ingredients': IngredientsScreen(),
        },
      ),
    );
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
