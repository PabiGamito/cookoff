import 'package:cookoff/models/ingredientSection.dart';
import 'package:cookoff/providers/ingredients_provider.dart';
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
            physics: BouncingScrollPhysics(),
            child: StreamBuilder<Iterable<IngredientSection>>(
              stream: _ingredientProvider.ingredientSections(),
              builder: (BuildContext context,
                  AsyncSnapshot<Iterable<IngredientSection>> snapshots) {
                if (!snapshots.hasData) {
                  return Container(
                    child: Text('LOADING...'),
                  );
                }

                return Column(
                  children: snapshots.data
                      .map(
                        (ingredientSection) => IngredientsSection(
                              ingredientSection: ingredientSection,
                            ),
                      )
                      .toList(),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
