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
            padding: EdgeInsets.only(
                top: 40,
                left: MediaQuery.of(context).size.width * 0.05 + 10,
                right: MediaQuery.of(context).size.width * 0.05),
            child: SectionTitle(_title, _titleUnderlineColor),
          ),
          TileCarousel(),
        ],
      );
}
