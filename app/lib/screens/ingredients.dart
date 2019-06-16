import 'package:cookoff/models/ingredient_section.dart';
import 'package:cookoff/providers/ingredient_provider.dart';
import 'package:cookoff/scalar.dart';
import 'package:cookoff/screens/profile_screen.dart';
import 'package:cookoff/widgets/home_header.dart';
import 'package:cookoff/widgets/ingredients_section.dart';
import 'package:cookoff/widgets/pill_button.dart';
import 'package:cookoff/widgets/rounded_card.dart';
import 'package:cookoff/widgets/scroll_bru.dart';
import 'package:cookoff/widgets/sliver_card_delegate.dart';
import 'package:cookoff/widgets/user_widget.dart';
import 'package:flutter/material.dart';

class IngredientsScreen extends StatefulWidget {
  final IngredientProvider _ingredientProvider;

  final void Function(BuildContext) _onBackPress;

  IngredientsScreen(
      {void Function(BuildContext) onBackPress,
      @required IngredientProvider ingredientProvider})
      : _onBackPress = onBackPress ??
            ((context) {
              Navigator.of(context).pop();
            }),
        _ingredientProvider = ingredientProvider;

  @override
  _IngredientsScreenState createState() => _IngredientsScreenState();
}

class _IngredientsScreenState extends State<IngredientsScreen> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    var headerCard = GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
                  body: ProfileScreen(),
                ),
          ),
        );
      },
      child: HomeHeader(
        user: UserWidget.of(context).user,
        notificationCount: 0,
      ),
    );

    var ingredientsCard = RoundedCard(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: Scaler(context).scale(35),
            ),
            margin: EdgeInsets.only(bottom: Scaler(context).scale(5)),
            child: PillButton(
              "BACK TO CHALLENGES",
              onTap: () {
                widget._onBackPress(context);
              },
            ),
          ),
          StreamBuilder<Iterable<IngredientSection>>(
            stream: widget._ingredientProvider
                .ingredientSectionsStream(UserWidget.of(context).user),
            builder: (context, snapshots) {
              if (!snapshots.hasData) {
                return Container();
              }

              var ingredientSections = snapshots.data.toList();

              return Container(
                color: ingredientSections.length.isOdd
                    ? Colors.white
                    : Color(0xFFF5F5F5),
                padding: EdgeInsets.only(bottom: Scaler(context).scale(15)),
                child: Column(children: [
                  for (var i = 0; i < ingredientSections.length; i++)
                    Container(
                      color: i.isEven ? Colors.white : Color(0xFFF5F5F5),
                      padding: EdgeInsets.symmetric(
                        vertical: Scaler(context).scale(30),
                      ),
                      child: IngredientsSection(
                        ingredientSection: ingredientSections[i],
                      ),
                    ),
                ]),
              );
            },
          ),
        ],
      ),
    );

    return Container(
      color: Colors.amber,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          ScrollBru(
            controller: _controller,
            bru: (height) => Container(
                  color: Colors.white,
                  height: height,
                ),
          ),
          CustomScrollView(
            controller: _controller,
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverPersistentHeader(
                delegate: SliverCardDelegate(
                  maxExtent: Scaler(context).scale(230),
                  minExtent: 0,
                  child: headerCard,
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([ingredientsCard]),
              ),
            ],
          )
        ],
      ),
    );
  }
}
