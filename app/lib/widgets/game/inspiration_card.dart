import 'package:cookoff/blocs/game_bloc.dart';
import 'package:cookoff/blocs/game_event.dart';
import 'package:cookoff/injector.dart';
import 'package:cookoff/models/challenge.dart';
import 'package:cookoff/providers/local_recipe_provider.dart';
import 'package:cookoff/providers/picture_provider.dart';
import 'package:cookoff/scalar.dart';
import 'package:cookoff/widgets/link_preview.dart';
import 'package:cookoff/widgets/rounded_card.dart';
import 'package:cookoff/widgets/titled_section.dart';
import 'package:cookoff/widgets/user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameScreenCard extends StatelessWidget {
  final PictureProvider _pictureProvider;
  final GameBloc _bloc;

  const GameScreenCard(
      {Key key, PictureProvider pictureProvider, GameBloc bloc})
      : _bloc = bloc,
        _pictureProvider = pictureProvider,
        super(key: key);

  @override
  Widget build(BuildContext context) => BlocBuilder<GameEvent, Challenge>(
        bloc: _bloc,
        builder: (context, challenge) =>
            challenge.userHasFinished(UserWidget.of(context).user) ||
                    challenge.complete
                ? BrowseCard(
                    pictureProvider: _pictureProvider,
                    challenge: challenge,
                  )
                : InspirationCard(
                    pictureProvider: _pictureProvider,
                    challenge: challenge,
                  ),
      );
}

class InspirationCard extends StatelessWidget {
  final PictureProvider _pictureProvider;
  final Challenge _challenge;

  const InspirationCard(
      {Key key, PictureProvider pictureProvider, Challenge challenge})
      : _challenge = challenge,
        _pictureProvider = pictureProvider,
        super(key: key);

  @override
  Widget build(BuildContext context) => _InspirationCard(
        ingredientId: _challenge.ingredient,
      );
}

class BrowseCard extends StatelessWidget {
  final PictureProvider _pictureProvider;
  final Challenge _challenge;

  const BrowseCard(
      {Key key, PictureProvider pictureProvider, Challenge challenge})
      : _challenge = challenge,
        _pictureProvider = pictureProvider,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return _GameScreenCard(
        stream: _pictureProvider.challengePictureStream(_challenge),
        title: "Browse Dishes...");
  }
}

// Game Screen Card
class _GameScreenCard extends StatelessWidget {
  final Stream<Iterable<String>> _stream;
  final PictureProvider _pictureProvider;
  final String _title;

  _GameScreenCard({@required Stream<Iterable<String>> stream, String title})
      : _pictureProvider = Injector().pictureProvider,
        _stream = stream,
        _title = title;

  @override
  Widget build(BuildContext context) => RoundedCard(
        child: Container(
          child: TitledSection(
            title: _title,
            underlineColor: Color(0xFF65D2EB),
            child: StreamBuilder<Iterable<String>>(
              stream: _stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data.isEmpty) {
                  return Container(height: Scaler(context).scale(27));
                }

                return Column(
                  children: [
                    for (var url in snapshot.data)
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: Scaler(context).scale(10)),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width,
                        decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                Scaler(context).scale(25)),
                            image: new DecorationImage(
                                fit: BoxFit.cover,
                                image: new NetworkImage(url))),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      );
}

class _InspirationCard extends StatelessWidget {
  final String ingredientId;

  const _InspirationCard({Key key, @required this.ingredientId})
      : super(key: key);

  Widget build(BuildContext context) => RoundedCard(
        child: Container(
          child: TitledSection(
            title: "Some Inspiration...",
            underlineColor: Color(0xFF65D2EB),
            // TODO: Use injector for RecipeProvider instead
            child: StreamBuilder<Iterable<String>>(
                stream: LocalRecipeProvider().recipeUrlStream(ingredientId),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  }

                  return Column(
                    children: [
                      for (String url in snapshot.data)
                        Container(
                          padding: EdgeInsets.only(
                              bottom: Scaler(context).scale(20)),
                          child: LinkPreviewer(url: url),
                        )
                    ],
                  );
                }),
          ),
        ),
      );
}
