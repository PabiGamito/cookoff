import 'package:cookoff/models/diet.dart';
import 'package:equatable/equatable.dart';

import 'ingredient.dart';

abstract class IngredientSection extends Equatable {
  final String title;
  final Iterable<Ingredient> ingredients;
  final Diet diet;

  IngredientSection(this.title, this.ingredients, this.diet);
}
