import 'package:cookoff/models/ingredient.dart';
import 'package:cookoff/scalar.dart';
import 'package:cookoff/widgets/challanges_section.dart';
import 'package:cookoff/widgets/ingredients_section.dart';
import 'package:cookoff/widgets/injector_widget.dart';
import 'package:flutter/material.dart';

import '../models/ingredient.dart';
import '../scalar.dart';
import '../widgets/challanges_section.dart';
import '../widgets/ingredients_section.dart';
import '../widgets/injector_widget.dart';
import '../widgets/rounded_card.dart';
import '../widgets/scrollable_card.dart';

// Home screen to be rendered if the user is signed in
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Challenge provider for challenge section
    var challengeProvider =
        InjectorWidget.of(context).injector.challengeProvider;

    return Column(children: [
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
        child: RoundedCard(
          backgroundColor: Color(0xFFF5F5F5),
          child: ChallengesSection(challengeProvider),
        ),
      ),
    ]);
  }
}

class NewHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Challenge provider for challenge section
    ChallengeProvider challengeProvider =
        InjectorWidget.of(context).injector.challengeProvider;

    return ScrollableCard(
      cardColor: Color(0xFFF5F5F5),
      background: Container(
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
      card: ChallengesSection(challengeProvider),
    );
  }
}
