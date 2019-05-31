import 'package:cookoff/models/ingredient.dart';
import 'package:cookoff/widgets/fragment.dart';
import 'package:cookoff/widgets/ingredients_section.dart';
import 'package:cookoff/widgets/pill_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class IngredientsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 40),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(38), topRight: Radius.circular(38)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          padding: EdgeInsets.only(top: 0, bottom: 30, left: 20, right: 20),
          child: PillButton(
            "BACK TO CHALLENGES",
            onTap: () {
              FragmentNavigator.pop(context);
            },
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 15),
          child: IngredientsSection(
            title: 'Featured',
            ingredients: <Ingredient>[
              Ingredient(
                  "cheese", "assets/ingredients/cheese.png", Color(0xFF7C54EA)),
              Ingredient(
                  "orange", "assets/ingredients/orange.png", Color(0xFFD0EB5C)),
              Ingredient("cauliflower", "assets/ingredients/cauliflower.png",
                  Color(0xFF65D2EB)),
            ],
          ),
        ),
      ]),
    );
  }
}
