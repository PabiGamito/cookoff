import 'package:cookoff/models/ingredient.dart';
import 'package:cookoff/blocs/auth_bloc.dart';
import 'package:cookoff/models/user.dart';
import 'package:cookoff/providers/auth_provider.dart';
import 'package:cookoff/providers/challenge_provider.dart';
import 'package:cookoff/scalar.dart';
import 'package:cookoff/widgets/challanges_section.dart';
import 'package:cookoff/widgets/ingredients_section.dart';
import 'package:cookoff/widgets/injector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


// Home screen to be rendered if the user is signed in
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Challenge provider for challenge section
    ChallengeProvider challengeProvider =
        InjectorWidget.of(context).injector.challengeProvider;
    return Container(
      padding: EdgeInsets.only(top: Scalar(context).scale(40)),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(Scalar(context).scale(38)),
            topRight: Radius.circular(Scalar(context).scale(38))),
      ),
      child: Column(children: [
        Container(
          padding: EdgeInsets.only(bottom: Scalar(context).scale(15)),
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
            padding: EdgeInsets.only(top: Scalar(context).scale(40)),
            decoration: new BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Scalar(context).scale(38)),
                topRight: Radius.circular(Scalar(context).scale(38)),
              ),
            ),
            child: ChallengesSection(challengeProvider),
          ),
        ),
      ]),
    );
  }
}
