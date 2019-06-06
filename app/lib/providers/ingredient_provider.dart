import 'package:cookoff/models/ingredient.dart';
import 'package:cookoff/models/ingredient_section.dart';

abstract class IngredientProvider {
  Stream<Iterable<IngredientSection>> ingredientSectionsStream();

  Stream<Iterable<Ingredient>> ingredientsStream();

  Stream<Ingredient> ingredientStream(String ingredient);
}
