import 'package:cookoff/models/ingredient.dart';
import 'package:cookoff/blocs/auth_bloc.dart';
import 'package:cookoff/models/user.dart';
import 'package:cookoff/providers/auth_provider.dart';
import 'package:cookoff/providers/challenge_provider.dart';
import 'package:cookoff/widgets/challanges_section.dart';
import 'package:cookoff/widgets/ingredients_section.dart';
import 'package:cookoff/widgets/injector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
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
            return UnauthorizedHomeScreen();
          }
          if (snapshot.data == null) {
            AuthBloc.instance.dispatch(NullUser());
            return UnauthorizedHomeScreen();
          } else {
            // User is signed in
            AuthBloc.instance.dispatch(snapshot.data);
            return AuthorizedHomeScreen();
          }
        });
  }
}

// Home screen to be rendered if the user is not signed on
class UnauthorizedHomeScreen extends StatelessWidget {
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

// Home screen to be rendered if the user is signed in
class AuthorizedHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Challenge provider for challenge section
    ChallengeProvider challengeProvider =
        InjectorWidget.of(context).injector.challengeProvider;
    return Container(
      padding: EdgeInsets.only(top: 40),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(38), topRight: Radius.circular(38)),
      ),
      child: Column(children: [
        Container(
          padding: EdgeInsets.only(bottom: 15),
          child: IngredientsSection(
            title: 'Start cooking...',
            titleUnderlineColor: Color(0xFF8EE5B6),
            ingredients: <Ingredient>[
              Ingredient(
                  "cheese", "assets/ingredients/cheese.png", Color(0xFF7C54EA)),
              Ingredient(
                  "orange", "assets/ingredients/orange.png", Color(0xFFD0EB5C)),
              Ingredient("cauliflower", "assets/ingredients/cauliflower.png",
                  Color(0xFF65D2EB)),
            ],
            more: true,
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(top: 40),
            decoration: new BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(38),
                topRight: Radius.circular(38),
              ),
            ),
            child: ChallengesSection(challengeProvider),
          ),
        ),
      ]),
    );
  }
}
