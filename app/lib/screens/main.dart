import 'dart:math';

import 'package:cookoff/blocs/auth_bloc.dart';
import 'package:cookoff/models/diet.dart';
import 'package:cookoff/providers/auth_provider.dart';
import 'package:cookoff/providers/local_ingredient_provider.dart';
import 'package:cookoff/scalar.dart';
import 'package:cookoff/screens/ingredients.dart';
import 'package:cookoff/screens/profile_screen.dart';
import 'package:cookoff/widgets/auth_builder.dart';
import 'package:cookoff/widgets/challanges_section.dart';
import 'package:cookoff/widgets/home_header.dart';
import 'package:cookoff/widgets/ingredients_section.dart';
import 'package:cookoff/widgets/injector_widget.dart';
import 'package:cookoff/widgets/rounded_card.dart';
import 'package:cookoff/widgets/scroll_bru.dart';
import 'package:cookoff/widgets/sliver_card_delegate.dart';
import 'package:cookoff/widgets/user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => new AuthBuilder(
      authorizedScreen: AuthorizedMainScreen(),
      unauthorizedScreen: UnauthorizedMainScreen(),
      loadingBloc: LoadingAuthBloc.instance);
}

class AuthorizedMainScreen extends StatefulWidget {
  @override
  _AuthorizedMainScreenState createState() => _AuthorizedMainScreenState();
}

class _AuthorizedMainScreenState extends State<AuthorizedMainScreen> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    var injector = InjectorWidget.of(context).injector;

    var challengeProvider = injector.challengeProvider;
    var ingredientProvider = injector.ingredientProvider;

    var showAllIngredients = (context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Scaffold(
                body: IngredientsScreen(ingredientProvider: ingredientProvider),
              ),
        ),
      );
    };

    var headerCard = GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
                  body: ProfileScreen(),
                ),
          ),
        );
      },
      child: HomeHeader(
        user: UserWidget.of(context).user,
        notificationCount: 0,
      ),
    );

    var featuredIngredientsCard = FutureBuilder<Diet>(
      future: InjectorWidget.of(context)
          .injector
          .ingredientProvider
          .dietStream(UserWidget.of(context).user.dietName),
      builder: (context, snapshot) {
        // Return empty widget while diet loads
        if (!snapshot.hasData) {
          return Container();
        }

        return RoundedCard(
          child: Container(
            padding: EdgeInsets.only(bottom: Scaler(context).scale(45)),
            child: IngredientsSection(
              ingredientSection: FeaturedSection(snapshot.data),
              title: 'Start cooking...',
              titleUnderlineColor: Color(0xFF8EE5B6),
              more: true,
              onMoreTap: showAllIngredients,
            ),
          ),
        );
      },
    );

    var challengesCard = RoundedCard(
      backgroundColor: Color(0xFFF5F5F5),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight:
              MediaQuery.of(context).size.height - Scaler(context).scale(545),
        ),
        child: ChallengesSection(
          challengeProvider.challengesStream(UserWidget.of(context).user.id),
          onAddChallenge: showAllIngredients,
        ),
      ),
    );

    return Container(
      color: Colors.white,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          ScrollBru(
            controller: _controller,
            bru: (height) => Container(
                  color: Color(0xFFF5F5F5),
                  height: height,
                ),
          ),
          CustomScrollView(
            controller: _controller,
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverPersistentHeader(
                delegate: SliverCardDelegate(
                  maxExtent: Scaler(context).scale(500),
                  minExtent: 0,
                  child: Stack(
                    children: [
                      Container(color: Colors.amber),
                      headerCard,
                      ScrollBru(
                        controller: _controller,
                        bru: (height) {
                          var offset = max(0.0, height - 130);
                          return Positioned(
                            top: Scaler(context).scale(230 - offset),
                            child: featuredIngredientsCard,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([challengesCard]),
              ),
            ],
          )
        ],
      ),
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
      color: Colors.amber,
      child: Center(
        child: BlocBuilder<bool, bool>(
          bloc: LoadingAuthBloc.instance,
          builder: (context, loading) => GestureDetector(
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
                ),
              ),
        ),
      ),
    );
  }
}
