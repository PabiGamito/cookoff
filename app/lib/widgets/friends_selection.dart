import 'package:cookoff/blocs/friends_selection_bloc.dart';
import 'package:cookoff/widgets/profile_icon.dart';
import 'package:cookoff/widgets/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FriendsTab extends StatelessWidget {
  final Function _onSelect;
  final double _cardHeight;
  final FriendsSelectionBloc _friendsBloc;
  final List<ProfileIcon> _friendsList;
  final Set<String> _tickedFriends;

  FriendsTab({
    FriendsSelectionBloc friendsBloc,
    List<ProfileIcon> friendsList,
    Set<String> tickedFriends,
    double cardHeight,
    Function onSelect,
  })  : _friendsBloc = friendsBloc,
        _friendsList = friendsList,
        _tickedFriends = tickedFriends,
        _cardHeight = cardHeight,
        _onSelect = onSelect;

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(
            left: mediaSize.width * 0.07,
          ),
          child: SectionTitle(
            'Friends',
            Color(0x00112211),
            fontSize: mediaSize.height * 0.03,
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: mediaSize.height * 0.02),
        ),
        FriendsList(_cardHeight, _friendsBloc, _friendsList, _tickedFriends),
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
  final List<ProfileIcon> _friendsList;
  final Set<String> _tickedFriends;
  final double _inspirationCardHeight;

  FriendsList(double inspirationCardHeight, FriendsSelectionBloc friendsBloc,
      List<ProfileIcon> friendsList, Set<String> tickedFriends)
      : _inspirationCardHeight = inspirationCardHeight,
        _friendsBloc = friendsBloc,
        _friendsList = friendsList,
        _tickedFriends = tickedFriends;

  @override
  Widget build(BuildContext context) {
    var mediaSize = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(
        left: mediaSize.width * 0.03,
      ),
      height: mediaSize.height * 0.27 + _inspirationCardHeight,
      child: ListView(
          padding: EdgeInsets.only(top: 0),
          physics: NeverScrollableScrollPhysics(),
          children: [
            for (var friend in _friendsList)
              new FriendCard(
                  friendsBloc: _friendsBloc,
                  friend: friend,
                  mediaSize: mediaSize,
                  tickedFriends: _tickedFriends),
          ]),
    );
  }
}

class FriendCard extends StatelessWidget {
  const FriendCard({
    FriendsSelectionBloc friendsBloc,
    this.friend,
    this.mediaSize,
    Set<String> tickedFriends,
  })  : _friendsBloc = friendsBloc,
        _tickedFriends = tickedFriends;

  final FriendsSelectionBloc _friendsBloc;
  final ProfileIcon friend;
  final Size mediaSize;
  final Set<String> _tickedFriends;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _friendsBloc.dispatch(friend.uid),
      child: Container(
        height: mediaSize.height * 0.1,
        margin: EdgeInsets.only(
          bottom: 10,
        ),
        child: Row(
          children: <Widget>[
            Container(
              child: friend,
            ),
            Container(
              width: mediaSize.width * 0.55,
              child: Text(
                friend.name,
                style: TextStyle(
                  fontSize: mediaSize.width * 0.05,
                  fontFamily: "Montserrat",
                ),
              ),
            ),
            Container(
              width: mediaSize.width * 0.15,
              height: mediaSize.width * 0.15,
              decoration: new BoxDecoration(
                shape: BoxShape.circle,
                color: _tickedFriends.contains(friend.uid)
                    ? Colors.lightBlueAccent
                    : Colors.grey,
              ),
              child: Center(
                child: Text(
                  "\u{2713}",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: mediaSize.width * 0.09,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
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
