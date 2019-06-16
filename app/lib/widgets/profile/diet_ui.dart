import 'package:cookoff/models/diet.dart';
import 'package:cookoff/models/ingredient.dart';
import 'package:cookoff/scalar.dart';
import 'package:cookoff/widgets/injector_widget.dart';
import 'package:cookoff/widgets/user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DietChoiceCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Iterable<Diet>>(
        stream: InjectorWidget.of(context)
            .injector
            .ingredientProvider
            .dietsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          var widgets = [
            Container(width: 15),
            for (var diet in snapshot.data) DietItem(diet: diet),
            Container(width: 5),
          ];

          return Container(
              width: MediaQuery.of(context).size.width,
              height: Scaler(context).scale(130),
              child: ListView(
                padding: EdgeInsets.zero,
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                children: [
                  for (var widget in widgets)
                    Container(
                      margin: EdgeInsets.only(right: Scaler(context).scale(20)),
                      child: widget,
                    )
                ],
              ));
        });
  }
}

class DietItem extends StatelessWidget {
  final Diet diet;

  const DietItem({Key key, this.diet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (UserWidget.of(context).user.dietName.toLowerCase() !=
            diet.name.toLowerCase())
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Switch diet?'),
                  content: Text(
                    'Would you like to switch your diet to ${diet.name.toLowerCase()}?',
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text('Yes'),
                      onPressed: () {
                        InjectorWidget.of(context)
                            .injector
                            .userProvider
                            .changeDiet(UserWidget.of(context).user, diet.name);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
          );
      },
      child: StreamBuilder<Ingredient>(
          stream: InjectorWidget.of(context)
              .injector
              .ingredientProvider
              .ingredientStream(diet.iconicIngredient),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }

            var ingredient = snapshot.data;
            var selected = UserWidget.of(context).user.dietName.toLowerCase() ==
                diet.name.toLowerCase();

            return Container(
              width: Scaler(context).scale(180),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Scaler(context).scale(10)),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Opacity(
                      opacity: selected ? 0.5 : 1,
                      child: Container(
                        alignment: Alignment.center,
                        color: ingredient.color,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: Scaler(context).scale(50),
                              height: Scaler(context).scale(50),
                              margin: EdgeInsets.only(
                                bottom: Scaler(context).scale(20),
                              ),
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(ingredient.imgPath))),
                            ),
                            Text(
                              diet.name.toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontSize: Scaler(context).scale(16),
                                  letterSpacing: 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (selected)
                      Positioned(
                        top: Scaler(context).scale(10),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: Scaler(context).scale(80),
                        ),
                      )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
