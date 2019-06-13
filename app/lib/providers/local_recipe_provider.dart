import 'recipes_provider.dart';

class LocalRecipeProvider implements RecipeProvider {
  @override
  Stream<Iterable<String>> recipeUrlStream(String ingredient) {
    return null; // Stream.fromFuture(future);
  }
}
