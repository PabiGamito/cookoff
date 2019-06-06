import 'package:cookoff/models/ingredient_section.dart';
import 'package:cookoff/providers/ingredient_provider.dart';
import 'package:cookoff/scalar.dart';
import 'package:cookoff/widgets/ingredients_section.dart';
import 'package:cookoff/widgets/pill_button.dart';
import 'package:flutter/material.dart';

class IngredientsScreen extends StatelessWidget {
  final IngredientProvider _ingredientProvider;

  final void Function(BuildContext) _onBackPress;

  IngredientsScreen(
      {void Function(BuildContext) onBackPress,
      @required IngredientProvider ingredientProvider})
      : _onBackPress = onBackPress ??
            ((context) {
              Navigator.of(context).pop();
            }),
        _ingredientProvider = ingredientProvider;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
        padding: EdgeInsets.only(
            top: Scaler(context).scale(30),
            bottom: Scaler(context).scale(30),
            left: Scaler(context).scale(20),
            right: Scaler(context).scale(20)),
        child: PillButton(
          "BACK TO CHALLENGES",
          onTap: () {
            _onBackPress(context);
          },
        ),
      ),
      Expanded(
          child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: StreamBuilder<Iterable<IngredientSection>>(
                  stream: _ingredientProvider.ingredientSectionsStream(),
                  builder: (context, snapshots) {
                    if (!snapshots.hasData) {
                      return Container();
                    }

                    return Column(
                        children: snapshots.data
                            .map((ingredientSection) => IngredientsSection(
                                  ingredientSection: ingredientSection,
                                ))
                            .toList());
                  })))
    ]);
  }
}
