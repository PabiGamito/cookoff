import 'package:cookoff/models/user.dart';
import 'package:cookoff/scalar.dart';
import 'package:cookoff/widgets/add_friends.dart';
import 'package:cookoff/widgets/challanges_section.dart';
import 'package:cookoff/widgets/game/game_widgets.dart';
import 'package:cookoff/widgets/home_header.dart';
import 'package:cookoff/widgets/injector_widget.dart';
import 'package:cookoff/widgets/profile/diet_ui.dart';
import 'package:cookoff/widgets/profile_icon.dart';
import 'package:cookoff/widgets/rounded_card.dart';
import 'package:cookoff/widgets/scroll_bru.dart';
import 'package:cookoff/widgets/sliver_card_delegate.dart';
import 'package:cookoff/widgets/user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    var user = UserWidget.of(context).user;
    var challenges = InjectorWidget.of(context)
        .injector
        .challengeProvider
        .archivedChallengesStream(user.id);

    var addFriendsOverlay = FriendsAdderOverlay(visible: false);

    var headerCard = Stack(children: <Widget>[
      Container(
        color: Colors.amber,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HomeHeader(user: UserWidget.of(context).user, notificationCount: 0),
            Container(
              margin: EdgeInsets.only(
                top: Scaler(context).scale(20),
                bottom: Scaler(context).scale(40),
              ),
              child: ProfileFriendsCarousel(
                users: UserWidget.of(context)
                    .user
                    .friends
                    .map((String id) => InjectorWidget.of(context)
                        .injector
                        .userProvider
                        .userStream(id))
                    .toList(),
                onAddMore: () {
                  addFriendsOverlay.toggleVisibility();
                },
              ),
            ),
            DietChoiceCarousel(),
          ],
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: Scaler(context).scale(25)),
        child: GameBackButton(
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    ]);

    var historyCard = RoundedCard(
      padding: EdgeInsets.zero,
      backgroundColor: Color(0xFFF5F5F5),
      child: ChallengesSection(
        challenges,
        title: "History",
        noChallengesFill: "NO CHALLENGES\nCOMPLETED",
      ),
    );

    return Container(
      color: Colors.amber,
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          ScrollBru(
            controller: _controller,
            bru: (height) => Container(
                  color: Color(0xFFF5F5F5),
                  height: height,
                ),
          ),
          CustomScrollView(
            controller: _controller,
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverPersistentHeader(
                delegate: SliverCardDelegate(
                  maxExtent: Scaler(context).scale(610),
                  minExtent: 0,
                  child: headerCard,
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([historyCard]),
              ),
            ],
          ),
          addFriendsOverlay,
        ],
      ),
    );
  }
}

class ProfileFriendsCarousel extends StatelessWidget {
  final List<Stream<User>> _users;
  final Function _onAddMore;

  const ProfileFriendsCarousel(
      {@required List<Stream<User>> users, Function onAddMore})
      : _users = users,
        _onAddMore = onAddMore;

  @override
  Widget build(BuildContext context) {
    var widgets = [
      Container(width: 15),
      GestureDetector(
        onTap: _onAddMore,
        child: Align(
          alignment: Alignment.topCenter,
          child: AddProfileIcon(
            size: Scaler(context).scale(95),
            color: Colors.pink,
          ),
        ),
      ),
      for (var user in _users)
        StreamBuilder<User>(
          stream: user,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }

            return Stack(children: [
              ProfileIcon(
                user: snapshot.data,
                size: Scaler(context).scale(95),
              ),
              Positioned(
                bottom: -Scaler(context).scale(0),
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    snapshot.data.firstName.toUpperCase(),
                    style: TextStyle(
                        fontSize: Scaler(context).scale(14),
                        fontFamily: "Montserrat",
                        color: Colors.white),
                  ),
                ),
              ),
            ]);
          },
        ),
      Container(width: 10),
    ];

    return Container(
      width: MediaQuery.of(context).size.width,
      height: Scaler(context).scale(125),
      child: ListView(
        padding: EdgeInsets.zero,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        children: [
          for (var widget in widgets)
            Container(
              padding: EdgeInsets.only(right: Scaler(context).scale(15)),
              child: widget,
            )
        ],
      ),
    );
  }
}
