import 'package:cookoff/providers/challenge_provider.dart';
import 'package:cookoff/providers/ingredients_provider.dart';
import 'package:cookoff/providers/local_ingredient_provider.dart';
import 'package:cookoff/widgets/auth.dart';
import 'package:cookoff/widgets/challanges_section.dart';
import 'package:cookoff/widgets/home_header.dart';
import 'package:cookoff/widgets/ingredients_section.dart';
import 'package:cookoff/widgets/rounded_card.dart';
import 'package:cookoff/widgets/scrollable_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/auth_bloc.dart';
import '../models/user.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../scalar.dart';
import '../widgets/injector_widget.dart';
import 'ingredients.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider =
        InjectorWidget.of(context).injector.authProvider;
    UserProvider userProvider =
        InjectorWidget.of(context).injector.userProvider;
    Widget unauthorized = UnauthorizedMainScreen();
    Widget authorized = AuthorizedMainScreen();
    return new AuthWidget(
      authProvider: authProvider,
      userProvider: userProvider,
      authorizedScreen: authorized,
      unauthorizedScreen: unauthorized,
      authBloc: AuthBloc.instance,
      loadingBloc: LoadingAuthBloc.instance,
    );
  }
}

class AuthorizedMainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Challenge provider for challenge section
    ChallengeProvider challengeProvider =
        InjectorWidget.of(context).injector.challengeProvider;

    IngredientProvider ingredientProvider = LocalIngredientProvider();

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
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  color: Color(0xFFFFC544),
                  child: RoundedCard(
                    padding: false,
                    child: IngredientsScreen(
                      ingredientProvider: ingredientProvider,
                    ),
                  ),
                ),
              ),
        ),
      );
    };

    var headerCard = ScrollableCard(
      bounce: false,
      scrollable: false,
      minOffset: 0,
      maxOffset: 0,
      startingOffset: 0,
      cardOffset: (context, scrolledAmount) => 0,
      cardBuilder: (context, scrolledAmount, fullyExpanded) {
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Color(0xFFFFC544),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.only(
                    top: Scalar(context).scale(30),
                    bottom: Scalar(context).scale(25)),
                child: BlocBuilder(
                  bloc: AuthBloc.instance,
                  builder: (BuildContext context, User user) {
                    return HomeHeader(user: user, notificationCount: 0);
                  },
                ),
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
        maxOffset: Scalar(context).scale(firstCardMaxOffset),
        startingOffset: Scalar(context).scale(firstCardMaxOffset),
        cardOffset: (context, scrolledAmount) {
          if (scrolledAmount > -Scalar(context).scale(firstCardContentHeight)) {
            return Scalar(context).scale(firstCardMaxOffset);
          }
          return Scalar(context)
                  .scale(firstCardMaxOffset + firstCardContentHeight) +
              scrolledAmount;
        },
        cardBuilder: (context, scrolledAmount, fullyExpanded) {
          return RoundedCard(
            padding: false,
            child: Container(
              padding: EdgeInsets.only(
                top: Scalar(context).scale(35),
                bottom: Scalar(context).scale(15),
              ),
              child: IngredientsSection(
                ingredientSection: FeaturedSection(),
                title: 'Start cooking...',
                titleUnderlineColor: Color(0xFF8EE5B6),
                more: true,
                onMoreTap: _showAllIngredients,
              ),
            ),
          );
        });

    var challengesCard = ScrollableCard(
      controler: challengesCardController,
      minOffset: firstCardTitleHeight,
      maxOffset:
          Scalar(context).scale(firstCardTitleHeight + firstCardContentHeight),
      startingOffset:
          Scalar(context).scale(firstCardTitleHeight + firstCardContentHeight),
      cardOffset: (context, scrolledAmount) {
        return Scalar(context).scale(secondCardMaxOffset) + scrolledAmount;
      },
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
      color: Color(0xFFFFC544),
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: ScrollableLayout(
        minScroll: Scalar(context).scale(minScrollAmount),
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
                  ),
                ),
          ),
        ));
  }
}
