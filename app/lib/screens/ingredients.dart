import 'package:cookoff/models/ingredient.dart';
import 'package:cookoff/scalar.dart';
import 'package:cookoff/widgets/ingredients_section.dart';
import 'package:cookoff/widgets/pill_button.dart';
import 'package:flutter/material.dart';

class IngredientsScreen extends StatelessWidget {
  final void Function(BuildContext) _onBackPress;

  IngredientsScreen({void Function(BuildContext) onBackPress})
      : _onBackPress = onBackPress ??
            ((context) {
              Navigator.of(context).pop();
            });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.only(
              top: Scalar(context).scale(30),
              bottom: Scalar(context).scale(30),
              left: Scalar(context).scale(20),
              right: Scalar(context).scale(20)),
          child: PillButton(
            "BACK TO CHALLENGES",
            onTap: () {
              _onBackPress(context);
            },
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: Scalar(context).scale(15)),
                  child: IngredientsSection(
                    title: 'Featured',
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
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: Scalar(context).scale(15)),
                  child: IngredientsSection(
                    title: 'Keep it simple',
                    ingredients: <Ingredient>[
                      Ingredient("bacon", "assets/ingredients/bacon.png",
                          Color(0xFF65D2EB)),
                      Ingredient("fish", "assets/ingredients/fish.png",
                          Color(0xFFEF8EBD)),
                      Ingredient("onion", "assets/ingredients/onion.png",
                          Color(0xFFE3BF73)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: Scalar(context).scale(15)),
                  child: IngredientsSection(
                    title: 'Healthy eating',
                    ingredients: <Ingredient>[
                      Ingredient("cheese", "assets/ingredients/bacon.png",
                          Color(0xFF65D2EB)),
                      Ingredient("orange", "assets/ingredients/fish.png",
                          Color(0xFFEF8EBD)),
                      Ingredient("cauliflower", "assets/ingredients/onion.png",
                          Color(0xFFE3BF73)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: Scalar(context).scale(15)),
                  child: IngredientsSection(
                    title: 'Healthiest eating',
                    ingredients: <Ingredient>[
                      Ingredient("cheese", "assets/ingredients/bacon.png",
                          Color(0xFF65D2EB)),
                      Ingredient("orange", "assets/ingredients/fish.png",
                          Color(0xFFEF8EBD)),
                      Ingredient("cauliflower", "assets/ingredients/onion.png",
                          Color(0xFFE3BF73)),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: Scalar(context).scale(15)),
                  child: IngredientsSection(
                    title: 'Most Healthy eating',
                    ingredients: <Ingredient>[
                      Ingredient("cheese", "assets/ingredients/bacon.png",
                          Color(0xFF65D2EB)),
                      Ingredient("orange", "assets/ingredients/fish.png",
                          Color(0xFFEF8EBD)),
                      Ingredient("cauliflower", "assets/ingredients/onion.png",
                          Color(0xFFE3BF73)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
