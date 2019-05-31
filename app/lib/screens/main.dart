import 'package:cookoff/blocs/auth_bloc.dart';
import 'package:cookoff/models/user.dart';
import 'package:cookoff/providers/auth_provider.dart';
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
        InjectorWidget
            .of(context)
            .injector
            .authProvider;
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
            AuthBloc.instance.dispatch(snapshot.data);
            return AuthorizedMainScreen();
          }
        });
  }
}

class AuthorizedMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        color: Color(0xFFFFC544),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
              padding: EdgeInsets.only(top: 65, bottom: 25),
              child: BlocBuilder(
                bloc: AuthBloc.instance,
                builder: (BuildContext context, User user) {
                  return HomeHeader(user.name, 3, user.profilePictureUrl);
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

// Home screen to be rendered if the user is not signed on
class UnauthorizedMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider =
        InjectorWidget
            .of(context)
            .injector
            .authProvider;
    return Container(
        color: Color(0xFFFFC544),
        child: Center(
          child: GestureDetector(
              onTap: () => authProvider.signIn(),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF52C7F2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Sign In with Google',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: "Montserrat",
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              )),
        ));
  }
}
