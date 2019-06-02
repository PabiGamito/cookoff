import 'package:cookoff/blocs/auth_bloc.dart';
import 'package:cookoff/blocs/friends_selection_bloc.dart';
import 'package:cookoff/models/user.dart';
import 'package:cookoff/scalar.dart';
import 'package:cookoff/widgets/profile_icon.dart';
import 'package:cookoff/widgets/titled_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FriendsTab extends StatelessWidget {
  final Function _onClose;
  final Function _onScroll;
  final FriendsSelectionBloc _bloc;
  final bool _scrollable;

  FriendsTab({
    FriendsSelectionBloc bloc,
    Function onClose,
    Function onScroll,
    bool scrollable = false,
  })  : _bloc = bloc,
        _onClose = onClose,
        _onScroll = onScroll,
        _scrollable = scrollable;

  @override
  Widget build(BuildContext context) => TitledSection(
      title: 'Add friends...',
      underlineColor: Colors.lightBlue,
      child: Column(
        children: <Widget>[
          FriendsList(
              bloc: _bloc, scrollable: _scrollable, onScroll: _onScroll),
          Center(
            child: GestureDetector(
              onTap: _onClose,
              child: FriendsSelectButton(),
            ),
          ),
        ],
      ));
}

class FriendsList extends StatelessWidget {
  final FriendsSelectionBloc _bloc;
  final Function _onScroll;
  final bool _scrollable;

  FriendsList({FriendsSelectionBloc bloc, bool scrollable, Function onScroll})
      : _bloc = bloc,
        _scrollable = scrollable,
        _onScroll = onScroll;

  @override
  Widget build(BuildContext context) {
    var scrollController = ScrollController();
    scrollController?.addListener(() {
      double offset = scrollController.offset;

      if (offset < 0.0) scrollController.jumpTo(0.0);
      _onScroll(offset);
    });

    return Container(
      height: 220,
      child: BlocBuilder(
          bloc: AuthBloc.instance,
          builder: (BuildContext context, User user) => ListView(
                  padding: EdgeInsets.zero,
                  addRepaintBoundaries: false,
                  physics: _scrollable
                      ? BouncingScrollPhysics()
                      : NeverScrollableScrollPhysics(),
                  controller: scrollController,
                  children: [
                    for (var friend in user.friendsList)
                      new FriendCard(bloc: _bloc, friend: friend),
                  ])),
    );
  }
}

class FriendCard extends StatelessWidget {
  final FriendsSelectionBloc _bloc;
  final User _friend;

  const FriendCard({
    FriendsSelectionBloc bloc,
    User friend,
  })  : _bloc = bloc,
        _friend = friend;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _bloc.dispatch(_friend.userId),
      child: Container(
        margin: EdgeInsets.only(bottom: Scalar(context).scale(20)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(children: [
              Container(
                  padding: EdgeInsets.only(right: Scalar(context).scale(20)),
                  child: ProfileIcon(
                      user: _friend,
                      size: Scalar(context).scale(55),
                      borderWidth: 0)),
              Text(
                _friend.name,
                style: TextStyle(
                  fontSize: Scalar(context).scale(20),
                  fontFamily: "Montserrat",
                ),
              ),
            ]),
            BlocBuilder(
                bloc: _bloc,
                builder: (BuildContext context, Set<String> ticked) =>
                    Container(
                      width: Scalar(context).scale(45),
                      height: Scalar(context).scale(45),
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: ticked.contains(_friend.userId)
                            ? Colors.lightBlueAccent
                            : Color(0xFFC6C6C6),
                      ),
                      child: Center(
                        child: Icon(Icons.check,
                            color: Colors.white,
                            size: Scalar(context).scale(20)),
                      ),
                    )),
          ],
        ),
      ),
    );
  }
}

class FriendsSelectButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(vertical: Scalar(context).scale(15)),
        decoration: new BoxDecoration(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Center(
          child: Text(
            "SELECT",
            style: TextStyle(
              fontSize: Scalar(context).scale(22),
              fontFamily: "Montserrat",
              letterSpacing: 3,
              color: Colors.white,
            ),
          ),
        ),
      );
}
