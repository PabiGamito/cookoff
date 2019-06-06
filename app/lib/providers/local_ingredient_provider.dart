import 'dart:async';
import 'dart:ui';

import 'package:cookoff/models/ingredient.dart';
import 'package:cookoff/models/ingredient_section.dart';
import 'package:flutter/material.dart';

import 'ingredients_provider.dart';

class LocalIngredientProvider extends IngredientProvider {
  List<IngredientSection> sections = [
    FeaturedSection(),
    BasicSection(),
    VegetableSection(),
    FruitSection(),
    TreatSection()
  ];

  @override
  Stream<Iterable<Ingredient>> getAllIngredients() {
    throw UnimplementedError();
  }

  Future<Iterable<IngredientSection>> getIngredientSections() async {
    return sections;
  }

  @override
  Stream<Iterable<IngredientSection>> ingredientSections() {
    return Stream.fromFuture(getIngredientSections());
  }

  Future<Ingredient> futureIngredientById(String name) async {
    return Ingredient(name, 'assets/ingredients/$name.png',
        ingredientColor[name] ?? Color(0xFF7C54EA));
  }

  @override
  Stream<Ingredient> getIngredientById(String id) {
    return Stream.fromFuture(futureIngredientById(id));
  }
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
  LocalIngredientSection({String title, Iterable<String> ingredients})
      : super(
            title,
            ingredients.map((name) => Ingredient(
                  name,
                  'assets/ingredients/$name.png',
                  ingredientColor[name] ?? Color(0xFF7C54EA),
                )));
}

class FeaturedSection extends LocalIngredientSection {
  FeaturedSection()
      : super(title: 'Featured', ingredients: [
          'cheese',
          'shrimp',
          'jelly',
          'strawberry',
          'garlic',
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
          'fish',
          'cheese',
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

class VeganSection extends LocalIngredientSection {
  VeganSection()
      : super(title: 'Vegan', ingredients: [
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
        ]);
}
