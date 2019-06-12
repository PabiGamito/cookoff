import 'package:cookoff/models/diet.dart';
import 'package:cookoff/providers/local_ingredient_provider.dart';
import 'package:cookoff/widgets/auth_builder.dart';
import 'package:cookoff/widgets/challanges_section.dart';
import 'package:cookoff/widgets/home_header.dart';
import 'package:cookoff/widgets/ingredients_section.dart';
import 'package:cookoff/widgets/rounded_card.dart';
import 'package:cookoff/widgets/scrollable_layout.dart';
import 'package:cookoff/widgets/user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_bloc.dart';
import '../providers/auth_provider.dart';
import '../scalar.dart';
import '../widgets/injector_widget.dart';
import 'ingredients.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => new AuthBuilder(
      authorizedScreen: AuthorizedMainScreen(),
      unauthorizedScreen: UnauthorizedMainScreen(),
      loadingBloc: LoadingAuthBloc.instance);
}

class AuthorizedMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var injector = InjectorWidget.of(context).injector;
    var challengeProvider = injector.challengeProvider;
    var ingredientProvider = injector.ingredientProvider;

    var user = UserWidget.of(context).user;
    var diet = InjectorWidget.of(context)
        .injector
        .ingredientProvider
        .dietFromName(user.dietName);

    const double firstCardMaxOffset = 188;
    const double firstCardTitleHeight = 112;
    const double firstCardContentHeight = 148;

    const double secondCardMaxOffset =
        firstCardMaxOffset + firstCardTitleHeight + firstCardContentHeight;

    const double minScrollAmount =
        -(secondCardMaxOffset - firstCardTitleHeight);

    var challengesCardController = CardController();

    var _showAllIngredients = (context) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Scaffold(
                  body: Container(
                      // Status bar height
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top),
                      color: Colors.amber,
                      child: RoundedCard(
                          padding: false,
                          child: IngredientsScreen(
                              ingredientProvider: ingredientProvider))))));
    };

    var headerCard = ScrollableCard(
      bounce: false,
      scrollable: false,
      minOffset: 0,
      maxOffset: 0,
      startingOffset: 0,
      cardBuilder: (context, scrolledAmount, fullyExpanded) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.amber,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.only(
                    top: Scaler(context).scale(30),
                    bottom: Scaler(context).scale(25)),
                child: HomeHeader(
                    user: UserWidget.of(context).user, notificationCount: 0),
              ),
              Expanded(
                child: Container(),
              ),
            ],
          ),
        );
      },
    );

    var featuredIngredientsCard = ScrollableCard(
        minOffset: 0,
        maxOffset: Scaler(context).scale(firstCardMaxOffset),
        startingOffset: Scaler(context).scale(firstCardMaxOffset),
        cardBuilder: (context, scrolledAmount, fullyExpanded) {
          return FutureBuilder<Diet>(
            future: diet,
            builder: (context, snapshot) {
              // Return empty widget while diet loads
              if (!snapshot.hasData) {
                return Container();
              }
              return RoundedCard(
                padding: false,
                child: Container(
                  padding: EdgeInsets.only(
                    top: Scaler(context).scale(35),
                    bottom: Scaler(context).scale(15),
                  ),
                  child: IngredientsSection(
                    ingredientSection: FeaturedSection(snapshot.data),
                    title: 'Start cooking...',
                    titleUnderlineColor: Color(0xFF8EE5B6),
                    more: true,
                    onMoreTap: _showAllIngredients,
                  ),
                ),
              );
            }
          );
        });

    var challengesCard = ScrollableCard(
      controler: challengesCardController,
      minOffset: firstCardTitleHeight,
      maxOffset:
          Scaler(context).scale(firstCardTitleHeight + firstCardContentHeight),
      startingOffset:
          Scaler(context).scale(firstCardTitleHeight + firstCardContentHeight),
      cardBuilder: (context, scrolledAmount, fullyExpanded) {
        return RoundedCard(
          padding: false,
          backgroundColor: Color(0xFFF5F5F5),
          child: ChallengesSection(
            challengeProvider,
            scrollable: fullyExpanded,
            onAddChallenge: _showAllIngredients,
          ),
        );
      },
    );

    return Container(
      // Status bar height
      color: Colors.amber,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: ScrollableLayout(
        minScroll: Scaler(context).scale(minScrollAmount),
        maxScroll: 0,
        scrollableCards: [
          headerCard,
          featuredIngredientsCard,
          challengesCard,
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
        ));
  }
}
