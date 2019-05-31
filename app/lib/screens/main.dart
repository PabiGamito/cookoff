import 'package:cookoff/widgets/fragment.dart';
import 'package:cookoff/widgets/home_header.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'ingredients.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        color: Color(0xFFFFC544),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Container(
            padding: EdgeInsets.only(top: 65, bottom: 25),
            child: HomeHeader('Elena', 3, 'assets/faces/Elena.jpg'),
          ),
          Expanded(
            child: FragmentContainer(
              startingFragment: 'home',
              fragments: {
                'home': HomeScreen(),
                'ingredients': IngredientsScreen(),
              },
            ),
          ),
        ]),
      );
}
