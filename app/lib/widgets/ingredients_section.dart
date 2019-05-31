import 'package:cookoff/models/ingredient.dart';
import 'package:cookoff/widgets/fragment.dart';
import 'package:cookoff/widgets/section_title.dart';
import 'package:cookoff/widgets/tile_carousel.dart';
import 'package:flutter/widgets.dart';

class IngredientsSection extends StatelessWidget {
  final String _title;
  final Color _titleUnderlineColor;
  final List<Ingredient> _ingredients;
  final bool _more;

  IngredientsSection(
      {@required String title,
      Color titleUnderlineColor = const Color(0xFF8057E2),
      @required List<Ingredient> ingredients,
      bool more = false})
      : _title = title,
        _titleUnderlineColor = titleUnderlineColor,
        _ingredients = ingredients,
        _more = more;

  @override
  Widget build(BuildContext context) {
    List<Tile> tiles = _ingredients
        .map((ingredient) => IngredientTile(ingredient) as Tile)
        .toList();

    if (_more) {
      tiles.add(Tile(
        bgColor: Color(0xFFF5F5F5),
        child: Container(
          child: Text(
            '+',
            style: TextStyle(
                color: Color(0xFF5F5F5F),
                fontFamily: 'Montserrat',
                fontSize: 56),
          ),
        ),
        onTap: (BuildContext context) =>
            FragmentNavigator.navigateTo(context, 'ingredients'),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: SectionTitle(
            _title,
            _titleUnderlineColor,
          ),
        ),
        TileCarousel(
          tiles: tiles,
        ),
      ],
    );
  }
}
