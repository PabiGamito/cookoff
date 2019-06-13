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
import 'package:cookoff/widgets/scrollable_layout.dart';
import 'package:cookoff/widgets/user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileScreenState();
  }
}

class ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var historyCardController = CardController();
    var historyCardTitleHeight = Scaler(context).scale(180);
    var historyCardContentHeight = Scaler(context).scale(360);
    var addFriendsOverlay = FriendsAdderOverlay(
      visible: false,
    );

    var challenges = InjectorWidget.of(context)
        .injector
        .challengeProvider
        .archivedChallengesStream(UserWidget.of(context).user.id);

    var diet = UserWidget.of(context).user.dietName;

    var headerCard = ScrollableCard(
      bounce: false,
      scrollable: false,
      minOffset: 0,
      maxOffset: 0,
      startingOffset: 0,
      cardBuilder: (context, scrolledAmount, fullyExpanded) {
        // TODO: Add slide down animation
        return Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.amber,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.only(
                    top: Scaler(context).scale(30),
                    bottom: Scaler(context).scale(25)),
                child: HomeHeader(
                    user: UserWidget.of(context).user, notificationCount: 0),
              ),
              ProfileFriendsCarousel(
                users: UserWidget.of(context)
                    .user
                    .friends
                    .map((String id) => InjectorWidget.of(context)
                        .injector
                        .userProvider
                        .userStream(id))
                    .toList(),
                size: Scaler(context).scale(100),
                color: Colors.pink,
                maxIcons: 10,
                onAddMore: () {
                  addFriendsOverlay.toggleVisibility();
                },
              ),
              DietChoiceCarousel(),
            ],
          ),
        );
      },
    );

    var historyCard = ScrollableCard(
      controler: historyCardController,
      minOffset: historyCardTitleHeight,
      maxOffset: Scaler(context)
          .scale(historyCardTitleHeight + historyCardContentHeight),
      startingOffset: Scaler(context)
          .scale(historyCardTitleHeight + historyCardContentHeight),
      cardBuilder: (context, scrolledAmount, fullyExpanded) {
        return RoundedCard(
          padding: false,
          backgroundColor: Color(0xFFF5F5F5),
          child: ChallengesSection(
            challenges,
            scrollable: fullyExpanded,
            title: "History",
            noChallengesFill: "NO CHALLENGES\nCOMPLETED",
          ),
        );
      },
    );

    return Container(
      // Status bar height
      color: Colors.amber,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Stack(
        children: <Widget>[
          ScrollableLayout(
            minScroll: 0,
            maxScroll: 0,
            scrollableCards: [headerCard, historyCard],
          ),
          Container(
            margin: EdgeInsets.only(top: Scaler(context).scale(5)),
            child: GameBackButton(
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          addFriendsOverlay,
        ],
      ),
    );
  }
}

class ProfileFriendsCarousel extends StatelessWidget {
  static const double _offsetScale = 0.18;

  final List<Stream<User>> _users;
  final double _size;
  final Color _color;
  final int _maxIcons;
  final Function _onAddMore;

  const ProfileFriendsCarousel(
      {@required List<Stream<User>> users,
      @required double size,
      @required Color color,
      @required int maxIcons,
      Function onAddMore})
      : _users = users,
        _size = size,
        _color = color,
        _maxIcons = maxIcons,
        _onAddMore = onAddMore;

  @override
  Widget build(BuildContext context) {
    var offset = _size * _offsetScale;
    var textSize = Scaler(context).scale(16);

    var users = _users.take(_maxIcons);
    var hiddenUsers = _users.length - users.length;

    var widgets = [
      Container(
        width: 30,
      ),
      Stack(
        children: [
          GestureDetector(
              onTap: _onAddMore,
              child: AddProfileIcon(size: _size, color: _color))
        ],
      ),
      for (var user in users)
        StreamBuilder<User>(
            stream: user,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Stack(children: [
                  ProfileIcon(user: snapshot.data, size: _size),
                  Positioned(
                      top: _size + offset * 0.5,
                      child: Container(
                        width: _size,
                        child: Center(
                          child: Text(
                            snapshot.data.firstName,
                            style: TextStyle(
                                fontSize: textSize,
                                fontFamily: "Montserrat",
                                color: Colors.white),
                          ),
                        ),
                      )),
                ]);
              } else {
                return Container();
              }
            }),
      if (hiddenUsers > 0)
        MoreProfileIcon(count: hiddenUsers, size: _size, color: _color),
    ];

    return Container(
      width: MediaQuery.of(context).size.width,
      height: _size + offset * 2.5,
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: widgets.length,
        itemBuilder: (BuildContext context, int index) {
          return widgets[index];
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            width: offset,
          );
        },
      ),
    );
  }
}
