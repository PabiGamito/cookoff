import 'package:cookoff/models/ingredient.dart';
import 'package:cookoff/models/ingredient_section.dart';

abstract class IngredientProvider {
  Stream<Iterable<IngredientSection>> ingredientSections();

  Stream<Iterable<Ingredient>> getAllIngredients();

  Stream<Ingredient> getIngredientById(String id);
}
