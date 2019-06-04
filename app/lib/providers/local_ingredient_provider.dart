import 'dart:async';
import 'dart:ui';

import 'package:cookoff/models/ingredient.dart';
import 'package:cookoff/models/ingredientSection.dart';

import 'ingredients_provider.dart';

class LocalIngredientProvider extends IngredientProvider {
  @override
  Stream<Iterable<Ingredient>> getAllIngredients() {
    // TODO: implement getAllIngredients
    return null;
  }

  Future<Iterable<IngredientSection>> getIngredientSections() async {
    return [
      FeaturedSection(),
      BasicSection(),
      VegetableSection(),
      FruitSection(),
      TreatSection()
    ];
  }

  @override
  Stream<Iterable<IngredientSection>> ingredientSections() {
    return Stream.fromFuture(getIngredientSections());
  }
}

const Map<String, Color> ingredientColor = {
  'cheese': Color(0xFF7C54EA),
  'orange': Color(0xFFD0EB5C),
  'cauliflower': Color(0xFF65D2EB),
};

class LocalIngredientSection extends IngredientSection {
  final Iterable<Ingredient> _ingredients;

  LocalIngredientSection({String title, Iterable<String> ingredients})
      : _ingredients = ingredients.map((name) => Ingredient(
            name,
            'assets/ingredients/$name.png',
            ingredientColor[name] ?? Color(0xFF7C54EA))),
        super(title);

  Future<Iterable<Ingredient>> futureIngredients() async {
    return _ingredients;
  }

  @override
  Stream<Iterable<Ingredient>> getIngredients() {
    return Stream.fromFuture(futureIngredients());
  }
}

class FeaturedSection extends LocalIngredientSection {
  FeaturedSection()
      : super(title: 'Featured', ingredients: [
          'cheese',
          'orange',
          'cauliflower',
        ]);
}

class BasicSection extends LocalIngredientSection {
  BasicSection()
      : super(title: 'Basics', ingredients: [
          'bacon',
          'eggs',
          'flour',
          'ham',
          'meat',
          'sausage',
          'baguette',
          'toast',
          'shrimp',
          'pickles',
          'fish'
        ]);
}

class VegetableSection extends LocalIngredientSection {
  VegetableSection()
      : super(title: 'Veggies', ingredients: [
          'aubergine',
          'beans',
          'broccoli',
          'cabbage',
          'carrot',
          'cauliflower',
          'chives',
          'salad',
          'corn',
          'cucumber',
          'garlic',
          'onion',
          'pumpkin',
          'radish',
          'tomato',
          'pepper',
        ]);
}

class FruitSection extends LocalIngredientSection {
  FruitSection()
      : super(title: 'Fruits', ingredients: [
          'apple',
          'banana',
          'blueberries',
          'cherries',
          'grapes',
          'lemon',
          'lime',
          'orange',
          'peach',
          'pear',
          'pomegranate',
          'raspberry',
          'strawberry',
          'watermelon',
        ]);
}

class TreatSection extends LocalIngredientSection {
  TreatSection()
      : super(title: 'Treats', ingredients: [
          'chocolate',
          'honey',
          'jam',
          'jelly',
        ]);
}
