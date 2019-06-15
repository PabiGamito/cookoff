import 'dart:math';

import 'package:cookoff/blocs/game_bloc.dart';
import 'package:cookoff/blocs/game_event.dart';
import 'package:cookoff/models/challenge.dart';
import 'package:cookoff/models/user.dart';
import 'package:cookoff/scalar.dart';
import 'package:cookoff/widgets/injector_widget.dart';
import 'package:cookoff/widgets/profile_icon.dart';
import 'package:cookoff/widgets/rounded_card.dart';
import 'package:cookoff/widgets/titled_section.dart';
import 'package:cookoff/widgets/user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FriendsTab extends StatefulWidget {
  final Function _onClose;
  final GameBloc _bloc;

  const FriendsTab({Function onClose, GameBloc bloc})
      : _onClose = onClose,
        _bloc = bloc;

  @override
  _FriendsTabState createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  final ScrollController _controller = ScrollController();

  double _height = 0;
  List<User> _friends;

  _FriendsTabState() {
    _controller.addListener(() {
      setState(() {
        if (_controller.hasClients && _controller.offset > 0) {
          _height = _controller.offset;
        } else {
          _height = 0;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var friends = UserWidget.of(context).user.friends.toList();
    var length = friends?.length ?? 0;

    if (_friends == null || _friends.length != length) {
      setState(() {
        _friends = List(length);
      });
    }

    for (var i = 0; i < length; i++) {
      InjectorWidget.of(context)
          .injector
          .userProvider
          .userStream(friends[i])
          .listen((friend) {
        setState(() {
          _friends[i] = friend;
        });
      });
    }

    if (_friends.any((friend) => friend == null)) {
      return Container();
    }

    return Stack(alignment: AlignmentDirectional.bottomEnd, children: <Widget>[
      Container(
        height: MediaQuery.of(context).size.height,
        color: Color(0x80000000),
      ),
      Container(height: _height, color: Colors.white),
      ListView(
          controller: _controller,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          children: [
            GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: widget._onClose,
                child: Container(
                    height: MediaQuery.of(context).size.height -
                        Scaler(context)
                            .scale(min(500, 80 * length.toDouble() + 232)))),
            FriendsCard(friends: _friends, bloc: widget._bloc)
          ]),
      FriendsSelectButton(onTap: widget._onClose)
    ]);
  }
}

class FriendsCard extends StatelessWidget {
  final List<User> _friends;
  final GameBloc _bloc;

  FriendsCard({List<User> friends, GameBloc bloc})
      : _friends = friends,
        _bloc = bloc;

  @override
  Widget build(BuildContext context) => RoundedCard(
      child: Container(
          padding: EdgeInsets.only(bottom: Scaler(context).scale(60)),
          child: TitledSection(
              title: 'Add friends...',
              underlineColor: Color(0xFF65D2EB),
              child: FriendsList(friends: _friends, bloc: _bloc))));
}

class FriendsList extends StatelessWidget {
  final List<User> _friends;
  final GameBloc _bloc;

  FriendsList({List<User> friends, GameBloc bloc})
      : _friends = friends,
        _bloc = bloc;

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: Scaler(context).scale(35)),
        child: Column(children: [
          for (var friend in _friends) FriendCard(bloc: _bloc, friend: friend)
        ]),
      );
}

class FriendCard extends StatelessWidget {
  final GameBloc _bloc;
  final User _friend;

  const FriendCard({
    GameBloc bloc,
    User friend,
  })  : _bloc = bloc,
        _friend = friend;

  @override
  Widget build(BuildContext context) => BlocBuilder<GameEvent, Challenge>(
      bloc: _bloc,
      builder: (context, challenge) => Container(
          margin: EdgeInsets.only(bottom: Scaler(context).scale(25)),
          child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async {
                // Check that user can eat ingredient according to diet
                var diet = await InjectorWidget.of(context)
                    .injector
                    .ingredientProvider
                    .dietStream(_friend.dietName);

                if (diet.filteredIngredients.contains(challenge.ingredient)) {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: new Text('Can\'t add friend'),
                            content: new Text(
                                '${_friend.firstName}\'s diet is ${diet.name}, so he can\'t be added to this challenge.'),
                          ));
                  return;
                }
                _bloc.dispatch(FriendButton(_friend.id));
              },
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(children: [
                      Container(
                          padding:
                              EdgeInsets.only(right: Scaler(context).scale(20)),
                          child: ProfileIcon(
                              user: _friend,
                              size: Scaler(context).scale(55),
                              border: false)),
                      Text(_friend.name,
                          style: TextStyle(
                            fontSize: Scaler(context).scale(20),
                            fontFamily: "Montserrat",
                          ))
                    ]),
                    Container(
                        width: Scaler(context).scale(45),
                        height: Scaler(context).scale(45),
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          color: challenge.participants.contains(_friend.id)
                              ? Color(0xFF65D2EB)
                              : Color(0xFFC6C6C6),
                        ),
                        child: Center(
                          child: Icon(Icons.check,
                              color: Colors.white,
                              size: Scaler(context).scale(20)),
                        ))
                  ]))));
}

class FriendsSelectButton extends StatelessWidget {
  final Function _onTap;

  const FriendsSelectButton({Function onTap}) : _onTap = onTap;

  @override
  Widget build(BuildContext context) =>
      Column(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
        IgnorePointer(
          child: Container(
            height: Scaler(context).scale(35),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0.4, 1],
                colors: [
                  Color(0x00FFFFFF),
                  Color(0x80FFFFFF),
                  Color(0xFFFFFFFF),
                ],
              ),
            ),
          ),
        ),
        Container(
          color: Colors.white,
          padding: EdgeInsets.only(bottom: Scaler(context).scale(35)),
          child: GestureDetector(
            onTap: _onTap,
            child: Container(
              height: 60,
              margin:
                  EdgeInsets.symmetric(horizontal: Scaler(context).scale(35)),
              decoration: new BoxDecoration(
                  color: Color(0xFF65D2EB),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: Center(
                child: Text(
                  "SELECT",
                  style: TextStyle(
                      fontSize: Scaler(context).scale(22),
                      fontFamily: "Montserrat",
                      letterSpacing: 3,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ]);
}
