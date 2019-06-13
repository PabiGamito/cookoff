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
          var diets = snapshot.data == null
              ? []
              : snapshot.data.map((Diet d) {
                  return StreamBuilder<Ingredient>(
                      stream: InjectorWidget.of(context)
                          .injector
                          .ingredientProvider
                          .ingredientStream(d.iconicIngredient),
                      builder: (context, snapshot) {
                        var ingredient = snapshot.data;
                        print(ingredient?.name);
                        return ingredient != null
                            ? Container(
                                width: Scaler(context).scale(160),
                                decoration: BoxDecoration(
                                    color: Color.lerp(
                                        ingredient.color, Colors.black54, 0.1),
                                    borderRadius: BorderRadius.circular(
                                        Scaler(context).scale(10))),
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: Scaler(context).scale(50),
                                        height: Scaler(context).scale(50),
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    ingredient.imgPath))),
                                      ),
                                      Text(
                                        d.name.toUpperCase(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Montserrat',
                                            letterSpacing: 2),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(
                                width: 300,
                                height: 300,
                              );
                      });
                }).toList();

          return Container(
            width: MediaQuery.of(context).size.width,
            height: Scaler(context).scale(120),
            margin: EdgeInsets.only(left: Scaler(context).scale(20)),
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: diets.length,
              itemBuilder: (BuildContext context, int index) {
                return diets[index];
              },
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                  width: 30,
                );
              },
            ),
          );
        });
  }
}
