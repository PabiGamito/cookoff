import 'package:cookoff/blocs/auth_bloc.dart';
import 'package:cookoff/blocs/friends_selection_bloc.dart';
import 'package:cookoff/models/user.dart';
import 'package:cookoff/scalar.dart';
import 'package:cookoff/widgets/profile_icon.dart';
import 'package:cookoff/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FriendsTab extends StatelessWidget {
  final Function _onSelect;
  final Function _onScroll;
  final double _cardHeight;
  final FriendsSelectionBloc _friendsBloc;
  final Set<String> _tickedFriends;
  final bool _scrollable;

  FriendsTab({
    FriendsSelectionBloc friendsBloc,
    Set<String> tickedFriends,
    double cardHeight,
    Function onSelect,
    Function onScroll,
    bool scrollable = false,
  })  : _friendsBloc = friendsBloc,
        _tickedFriends = tickedFriends,
        _cardHeight = cardHeight,
        _onSelect = onSelect,
        _onScroll = onScroll,
        _scrollable = scrollable;

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SectionTitle(
          title: 'Friends',
          color: Colors.lightBlue,
          fontSize: mediaSize.height * 0.03,
        ),
        Container(
          padding: EdgeInsets.only(bottom: mediaSize.height * 0.02),
        ),
        FriendsList(
            inspirationCardHeight: _cardHeight,
            friendsBloc: _friendsBloc,
            scrollable: _scrollable,
            onScroll: _onScroll),
        Center(
          child: GestureDetector(
            onTap: _onSelect,
            child: FriendSelectButton(),
          ),
        ),
      ],
    );
  }
}

class FriendsList extends StatelessWidget {
  final FriendsSelectionBloc _friendsBloc;
  final Function _onScroll;
  final double _inspirationCardHeight;
  final bool _scrollable;

  FriendsList(
      {double inspirationCardHeight,
      FriendsSelectionBloc friendsBloc,
      bool scrollable,
      Function onScroll})
      : _inspirationCardHeight = inspirationCardHeight,
        _friendsBloc = friendsBloc,
        _scrollable = scrollable,
        _onScroll = onScroll;

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    var scrollController = ScrollController();
    scrollController?.addListener(() {
      double offset = scrollController.offset;

      if (offset < 0.0) scrollController.jumpTo(0.0);
      _onScroll(offset);
    });
    return Container(
      height: 250,
      child: BlocBuilder(
          bloc: AuthBloc.instance,
          builder: (BuildContext context, User user) => ListView(
                  padding: EdgeInsets.only(top: 0),
                  addRepaintBoundaries: false,
                  physics: _scrollable
                      ? BouncingScrollPhysics()
                      : NeverScrollableScrollPhysics(),
                  controller: scrollController,
                  children: [
                    for (var friend in user.friendsList)
                      new FriendCard(
                          bloc: _friendsBloc,
                          friend: friend,
                          mediaSize: mediaSize),
                  ])),
    );
  }
}

class FriendCard extends StatelessWidget {
  final FriendsSelectionBloc _bloc;
  final User _friend;
  final Size mediaSize;

  const FriendCard({
    FriendsSelectionBloc bloc,
    User friend,
    this.mediaSize,
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
                      size: Scalar(context).scale(60),
                      borderWidth: 0)),
              Text(
                _friend.name,
                style: TextStyle(
                  fontSize: mediaSize.width * 0.05,
                  fontFamily: "Montserrat",
                ),
              ),
            ]),
            BlocBuilder(
                bloc: _bloc,
                builder: (BuildContext context, Set<String> tickedFriends) =>
                    Container(
                      width: Scalar(context).scale(45),
                      height: Scalar(context).scale(45),
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        color: tickedFriends.contains(_friend.userId)
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

class FriendSelectButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: mediaSize.height * 0.03),
      width: mediaSize.width * 0.8,
      height: mediaSize.height * 0.08,
      decoration: new BoxDecoration(
          color: Colors.lightBlueAccent,
          borderRadius:
              BorderRadius.all(Radius.circular(mediaSize.width * 0.03))),
      child: Center(
        child: Text(
          "\u{2713} Select",
          style: TextStyle(
            fontSize: mediaSize.width * 0.07,
            fontFamily: "Montserrat",
            letterSpacing: 2,
            wordSpacing: 2,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
