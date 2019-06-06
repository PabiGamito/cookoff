import 'ingredient.dart';

abstract class IngredientSection {
  final String title;
  final Iterable<Ingredient> ingredients;

  IngredientSection(this.title, this.ingredients);
}
