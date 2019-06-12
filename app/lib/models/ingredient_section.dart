import 'package:equatable/equatable.dart';

import 'ingredient.dart';

abstract class IngredientSection extends Equatable {
  final String title;
  final Iterable<Ingredient> ingredients;

  IngredientSection(this.title, this.ingredients);
}
