import 'package:cookoff/models/diet.dart';
import 'package:cookoff/models/ingredient.dart';
import 'package:cookoff/scalar.dart';
import 'package:cookoff/widgets/injector_widget.dart';
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

          return Container(
              width: MediaQuery.of(context).size.width,
              height: Scaler(context).scale(120),
              margin: EdgeInsets.only(left: Scaler(context).scale(20)),
              child: _createList(snapshot.data));
        });
  }

  ListView _createList(final Iterable<Diet> diets) => ListView(
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      children: [for (var diet in diets) DietItem(diet: diet)]);
}

class DietItem extends StatelessWidget {
  final Diet diet;

  const DietItem({Key key, this.diet}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Ingredient>(
        stream: InjectorWidget.of(context)
            .injector
            .ingredientProvider
            .ingredientStream(diet.iconicIngredient),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          var ingredient = snapshot.data;
          return Container(
            width: Scaler(context).scale(160),
            decoration: BoxDecoration(
                color: Color.lerp(ingredient.color, Colors.black54, 0.1),
                borderRadius: BorderRadius.circular(Scaler(context).scale(10))),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: Scaler(context).scale(50),
                    height: Scaler(context).scale(50),
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(ingredient.imgPath))),
                  ),
                  Text(
                    diet.name.toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        letterSpacing: 2),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
