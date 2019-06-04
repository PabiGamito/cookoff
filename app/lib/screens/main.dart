import 'package:cookoff/models/ingredient.dart';
import 'package:cookoff/providers/challenge_provider.dart';
import 'package:cookoff/widgets/challanges_section.dart';
import 'package:cookoff/widgets/fragment.dart';
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
    // Challenge provider for challenge section
    ChallengeProvider challengeProvider =
        InjectorWidget.of(context).injector.challengeProvider;

    const double firstCardMaxOffset = 188;
    const double firstCardTitleHeight = 100;
    const double firstCardContentHeight = 160;

    const double secondCardMaxOffset =
        firstCardMaxOffset + firstCardTitleHeight + firstCardContentHeight;

    const double minScrollAmount =
        -(secondCardMaxOffset - firstCardTitleHeight);

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
                    return HomeHeader(user: user, notificationCount: 3);
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

    var card1 = ScrollableCard(
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
                bottom: Scalar(context).scale(15),
              ),
              child: FragmentContainer(
                startingFragment: 'featured',
                fragments: {
                  'featured': IngredientsSection(
                    title: 'Start cooking...',
                    titleUnderlineColor: Color(0xFF8EE5B6),
                    ingredients: <Ingredient>[
                      Ingredient("cheese", "assets/ingredients/cheese.png",
                          Color(0xFF7C54EA)),
                      Ingredient("orange", "assets/ingredients/orange.png",
                          Color(0xFFD0EB5C)),
                      Ingredient(
                          "cauliflower",
                          "assets/ingredients/cauliflower.png",
                          Color(0xFF65D2EB)),
                    ],
                    more: true,
                  ),
                  'ingredients': IngredientsScreen(),
                },
              ),
            ),
          );
        });

    var card2 = ScrollableCard(
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
          child:
              ChallengesSection(challengeProvider, scrollable: fullyExpanded),
        );
      },
    );

    return Container(
      // Status bar height
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: ScrollableLayout(
        minScroll: Scalar(context).scale(minScrollAmount),
        maxScroll: 0,
        scrollableCards: [
          headerCard,
          card1,
          card2,
        ],
      ),
    );

//    return Container(
//      // Status bar height
//      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
//      child: ScrollableLayout(
//        maxOffset: Scalar(context).scale(185),
//        minOffset: Scalar(context).scale(0),
//        onTopOverScroll: (d) => {print("TOP OVERFLOW!!!")},
//        main: Container(
//          color: Color(0xFFFFC544),
//          child: Column(
//            mainAxisSize: MainAxisSize.min,
//            children: [
//              Container(
//                padding: EdgeInsets.only(
//                    top: Scalar(context).scale(30),
//                    bottom: Scalar(context).scale(25)),
//                child: BlocBuilder(
//                  bloc: AuthBloc.instance,
//                  builder: (BuildContext context, User user) {
//                    return HomeHeader(user: user, notificationCount: 3);
//                  },
//                ),
//              ),
//              Expanded(
//                child: Container(),
//              ),
//            ],
//          ),
//        ),
//        card: FragmentContainer(
//          startingFragment: 'home',
//          fragments: {
//            'home': NewHomeScreen(),
//            'ingredients': IngredientsScreen(),
//          },
//        ),
//      ),
//    );
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
