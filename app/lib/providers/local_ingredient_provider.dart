import 'dart:async';
import 'dart:ui';

import 'package:cookoff/models/diet.dart';
import 'package:cookoff/models/ingredient.dart';
import 'package:cookoff/models/ingredient_section.dart';
import 'package:cookoff/models/user.dart';
import 'package:cookoff/providers/ingredient_provider.dart';
import 'package:flutter/material.dart';

class LocalIngredientProvider extends IngredientProvider {
  List<IngredientSection> sections;
  static final Map<String, Diet> diets = {
    'all': NoDiet(),
    'vegetarian': Diet('Vegetarian',
        ['ham', 'meat', 'saussage', 'shrimp', 'fish', 'bacon'], 'broccoli'),
    'gluten_free': Diet('Gluten Free', ['wheat'], 'pear'),
    'vegan': Diet(
        'Vegan',
        [
          'ham',
          'meat',
          'saussage',
          'shrimp',
          'fish',
          'eggs',
          'cheese',
          'bacon'
        ],
        'tomato'),
    'pescetarian':
        Diet('Pescetarian', ['ham', 'meat', 'saussage', 'bacon'], 'fish')
  };

  @override
  Stream<Iterable<Ingredient>> ingredientsStream() {
    throw UnimplementedError();
  }

  Future<Iterable<IngredientSection>> getIngredientSections(User user) async {
    var diet = diets[user.dietName] ?? NoDiet();
    return sections = [
      FeaturedSection(diet),
      BasicSection(diet),
      VegetableSection(diet),
      FruitSection(diet),
      TreatSection(diet),
      VeganSection(diet)
    ];
  }

  @override
  Stream<Iterable<IngredientSection>> ingredientSectionsStream(User user) =>
      Stream.fromFuture(getIngredientSections(user));

  @override
  Stream<Ingredient> ingredientStream(String ingredient) =>
      Stream.fromFuture(Future.value(Ingredient(
          ingredient,
          'assets/ingredients/$ingredient.png',
          ingredientColor[ingredient] ?? Colors.blueGrey)));

  @override
  Stream<Iterable<Diet>> dietsStream() => Future.value(diets.values).asStream();

  @override
  Future<Diet> dietStream(String name) => Future.value(diets[name] ?? NoDiet());
}

const Map<String, Color> ingredientColor = {
  'cheese': Colors.redAccent,
  'orange': Color(0xFFD0EB5C),
  'cauliflower': Color(0xFF65D2EB),
  'bacon': Color(0xFF65D2EB),
  'fish': Color(0xFFEF8EBD),
  'onion': Color(0xFFE3BF73),
  'eggs': Colors.indigoAccent,
  'flour': Colors.green,
  'ham': Colors.amber,
  'meat': Colors.blue,
  'sausage': Colors.orange,
  'baguette': Colors.blueGrey,
  'toast': Colors.cyan,
  'shrimp': Colors.indigo,
  'pickles': Colors.redAccent,
  'aubergine': Colors.amber,
  'beans': Colors.pinkAccent,
  'broccoli': Colors.deepOrangeAccent,
  'cabbage': Colors.deepPurpleAccent,
  'carrot': Colors.blueAccent,
  'chives': Colors.lime,
  'salad': Colors.orangeAccent,
  'corn': Colors.cyan,
  'cucumber': Colors.redAccent,
  'garlic': Colors.blueGrey,
  'pumpkin': Colors.purple,
  'radish': Colors.deepPurple,
  'tomato': Colors.greenAccent,
  'pepper': Colors.redAccent,
  'apple': Colors.greenAccent,
  'banana': Colors.purple,
  'blueberries': Colors.deepOrangeAccent,
  'cherries': Colors.green,
  'grapes': Colors.limeAccent,
  'lemon': Colors.deepPurpleAccent,
  'lime': Colors.redAccent,
  'peach': Colors.blueAccent,
  'pear': Colors.pinkAccent,
  'pomegranate': Colors.limeAccent,
  'raspberry': Colors.greenAccent,
  'strawberry': Colors.amber,
  'watermelon': Colors.limeAccent,
  'chocolate': Colors.deepOrangeAccent,
  'honey': Colors.lightBlueAccent,
  'jam': Colors.lightGreenAccent,
  'jelly': Colors.greenAccent,
};

class LocalIngredientSection extends IngredientSection {
  LocalIngredientSection(
      {String title, Iterable<String> ingredients, Diet diet})
      : super(
            title,
            ingredients
                .where((name) => !diet.filteredIngredients.contains(name))
                .map((name) => Ingredient(
                      name,
                      'assets/ingredients/$name.png',
                      ingredientColor[name] ?? Color(0xFF7C54EA),
                    )));
}

class FeaturedSection extends LocalIngredientSection {
  FeaturedSection(Diet diet)
      : super(
            title: 'Featured',
            ingredients: [
              'cheese',
              'shrimp',
              'jelly',
              'strawberry',
              'garlic',
            ],
            diet: diet);
}

class BasicSection extends LocalIngredientSection {
  BasicSection(Diet diet)
      : super(
            title: 'Basics',
            ingredients: [
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
              'fish',
              'cheese',
            ],
            diet: diet);
}

class VegetableSection extends LocalIngredientSection {
  VegetableSection(Diet diet)
      : super(
            title: 'Veggies',
            ingredients: [
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
            ],
            diet: diet);
}

class FruitSection extends LocalIngredientSection {
  FruitSection(Diet diet)
      : super(
            title: 'Fruits',
            ingredients: [
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
            ],
            diet: diet);
}

class TreatSection extends LocalIngredientSection {
  TreatSection(Diet diet)
      : super(
            title: 'Treats',
            ingredients: [
              'chocolate',
              'honey',
              'jam',
              'jelly',
            ],
            diet: diet);
}

class VeganSection extends LocalIngredientSection {
  VeganSection(Diet diet)
      : super(
            title: 'Vegan',
            ingredients: [
              'flour',
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
            ],
            diet: diet);
}
