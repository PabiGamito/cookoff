import 'package:cookoff/blocs/game_bloc.dart';
import 'package:cookoff/injector.dart';
import 'package:cookoff/models/challenge.dart';
import 'package:cookoff/models/ingredient.dart';
import 'package:cookoff/scalar.dart';
import 'package:cookoff/widgets/game/friends_tab.dart';
import 'package:cookoff/widgets/game/game_widgets.dart';
import 'package:cookoff/widgets/game/inspiration_card.dart';
import 'package:cookoff/widgets/injector_widget.dart';
import 'package:cookoff/widgets/sliver_card_delegate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GameScreen extends StatefulWidget {
  final Challenge _challenge;

  GameScreen({Challenge challenge}) : _challenge = challenge;

  @override
  State<StatefulWidget> createState() => _GameScreenState(_challenge);
}

class _GameScreenState extends State<GameScreen> {
  final GameBloc _bloc;
  bool _friendsTabOpen = false;

  _GameScreenState(Challenge challenge) : _bloc = GameBloc(challenge);

  _popScreen() {
    // Close the friends tab on back press
    if (_friendsTabOpen) {
      _friendsTabOpen = false;
      return;
    }

    // Set status bar color on Android to match header
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.amber,
    ));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<Ingredient>(
        stream: InjectorWidget.of(context)
            .injector
            .ingredientProvider
            .ingredientStream(widget._challenge.ingredient),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          var ingredient = snapshot.data;

          // Set status bar color on Android to match header
          SystemChrome.setSystemUIOverlayStyle(
              SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: ingredient.color,
          ));

          return WillPopScope(
            onWillPop: () {
              _popScreen();
            },
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: <Widget>[
                Container(color: ingredient.color),
                CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: [
                    SliverPersistentHeader(
                      delegate: SliverCardDelegate(
                        maxExtent: MediaQuery.of(context).size.height -
                            Scaler(context).scale(200),
                        minExtent: 0,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: Scaler(context).scale(60),
                              horizontal: Scaler(context).scale(35)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GameHeader(onExit: _popScreen, bloc: _bloc),
                              IngredientName(ingredient: ingredient),
                              IngredientIcon(ingredient: ingredient),
                              GameScreenButton(
                                  color: ingredient.color, bloc: _bloc),
                              FriendProfiles(
                                  color: ingredient.color,
                                  onTap: () {
                                    setState(
                                      () {
                                        _friendsTabOpen = true;
                                      },
                                    );
                                  },
                                  bloc: _bloc),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        GameScreenCard(
                          pictureProvider: Injector().pictureProvider,
                          bloc: _bloc,
                        ),
                      ]),
                    ),
                  ],
                ),
                Visibility(
                  visible: _friendsTabOpen,
                  child: FriendsTab(
                      onClose: () {
                        setState(
                          () {
                            _friendsTabOpen = false;
                          },
                        );
                      },
                      bloc: _bloc),
                ),
              ],
            ),
          );
        },
      );
}
