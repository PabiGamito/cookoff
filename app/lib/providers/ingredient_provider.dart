import 'package:cookoff/models/diet.dart';
import 'package:cookoff/models/ingredient.dart';
import 'package:cookoff/models/ingredient_section.dart';
import 'package:cookoff/models/user.dart';

abstract class IngredientProvider {
  Stream<Iterable<IngredientSection>> ingredientSectionsStream(User user);

  Stream<Iterable<Ingredient>> ingredientsStream();

  Stream<Ingredient> ingredientStream(String ingredient);

  Stream<Iterable<Diet>> dietsStream();

  Future<Diet> dietStream(String diet);
}
