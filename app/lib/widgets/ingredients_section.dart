import 'package:cookoff/models/ingredient_section.dart';
import 'package:flutter/widgets.dart';

import '../scalar.dart';
import 'section_title.dart';
import 'tile_carousel.dart';

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
              fontSize: Scalar(context).scale(56)),
        ),
      ),
      onTap: _onMoreTap,
    );

    List<Tile> tiles = _ingredientSection.ingredients
        .map((ingredient) => IngredientTile(ingredient) as Tile)
        .toList();

    if (_more) {
      tiles.add(moreTile);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            left: Scalar(context).scale(30),
            right: Scalar(context).scale(30),
          ),
          child: SectionTitle(
            title: _title ?? _ingredientSection.title,
            color: _titleUnderlineColor,
            fontSize: Scalar(context).scale(25),
          ),
        ),
        TileCarousel(
          tiles: tiles,
        ),
      ],
    );
  }
}
