import 'package:cookoff/blocs/auth_bloc.dart';
import 'package:cookoff/models/user.dart';
import 'package:cookoff/widgets/fragment.dart';
import 'package:cookoff/widgets/home_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
              child: BlocBuilder(
                bloc: AuthBloc.instance,
                builder: (BuildContext context, User user) {
                  return HomeHeader(user.name, 3, user.profilePictureUrl);
                },
              )),
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
