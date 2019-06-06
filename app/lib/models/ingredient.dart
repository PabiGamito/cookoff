import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Ingredient extends Equatable {
  final String name;
  final String imgPath;
  final Color color;

  Ingredient(this.name, this.imgPath, this.color);
}

class NullIngredient extends Ingredient {
  NullIngredient() : super('', '', Colors.white);
}
