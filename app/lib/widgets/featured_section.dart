import 'package:cookoff/widgets/section_title.dart';
import 'package:cookoff/widgets/tile_carousel.dart';
import 'package:flutter/widgets.dart';

class FeaturedSection extends StatelessWidget {
  final String _title;
  final Color _titleUnderlineColor;

  FeaturedSection(String title, Color titleUnderlineColor)
      : _title = title,
        _titleUnderlineColor = titleUnderlineColor;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: SectionTitle(_title, _titleUnderlineColor),
          ),
          TileCarousel(tiles: <Tile>[
            Tile("cheese", "assets/ingredients/cheese.png", Color(0xFF7C54EA)),
            Tile("orange", "assets/ingredients/orange.png", Color(0xFFD0EB5C)),
            Tile("cauliflower", "assets/ingredients/cauliflower.png",
                Color(0xFF65D2EB)),
            Tile("cheese", "assets/ingredients/cheese.png", Color(0xFF7C54EA)),
            Tile("orange", "assets/ingredients/orange.png", Color(0xFFD0EB5C)),
            Tile("cauliflower", "assets/ingredients/cauliflower.png",
                Color(0xFF65D2EB)),
          ]),
        ],
      );
}
