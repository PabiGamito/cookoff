import 'ingredient.dart';

abstract class IngredientSection {
  final String title;

  IngredientSection(this.title);

  Stream<Iterable<Ingredient>> getIngredients();
}
