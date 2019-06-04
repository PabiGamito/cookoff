import 'package:cookoff/models/ingredient.dart';
import 'package:cookoff/models/ingredientSection.dart';

abstract class IngredientProvider {
  Stream<Iterable<IngredientSection>> ingredientSections();

  Stream<Iterable<Ingredient>> getAllIngredients();
}
