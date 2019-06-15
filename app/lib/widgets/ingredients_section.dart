import 'package:cookoff/models/ingredient_section.dart';
import 'package:cookoff/scalar.dart';
import 'package:cookoff/widgets/tile_carousel.dart';
import 'package:cookoff/widgets/titled_section.dart';
import 'package:flutter/widgets.dart';

class IngredientsSection extends StatelessWidget {
  final String _title;
  final Color _titleUnderlineColor;
  final bool _more;
  final void Function(BuildContext context) _onMoreTap;

  final IngredientSection _ingredientSection;

  IngredientsSection(
      {String title,
      Color titleUnderlineColor = const Color(0xFF8057E2),
      bool more = false,
      void Function(BuildContext context) onMoreTap,
      @required IngredientSection ingredientSection})
      : _title = title,
        _titleUnderlineColor = titleUnderlineColor,
        _more = more,
        _onMoreTap = onMoreTap ?? ((context) {}),
        _ingredientSection = ingredientSection;

  @override
  Widget build(BuildContext context) {
    var moreTile = Tile(
      bgColor: Color(0xFFF5F5F5),
      child: Container(
        child: Text(
          '+',
          style: TextStyle(
              color: Color(0xFF5F5F5F),
              fontFamily: 'Montserrat',
              fontSize: Scaler(context).scale(56)),
        ),
      ),
      onTap: _onMoreTap,
    );

    var tiles = [
      for (var ingredient in _ingredientSection.ingredients)
        IngredientTile(ingredient),
      if (_more) moreTile
    ];

    return TitledSection(
      title: _title ?? _ingredientSection.title,
      underlineColor: _titleUnderlineColor,
      child: TileCarousel(
        tiles: tiles,
      ),
    );
  }
}
