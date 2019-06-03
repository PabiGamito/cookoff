import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ScrollableCard {
  double _offset;
  double _lastOffset;

  final double minOffset;
  final double maxOffset;

  final double Function(BuildContext context, double scrolledAmount) cardOffset;
  final Widget Function(BuildContext context, double scrolledAmount)
      cardBuilder;

  final ScrollController controller = ScrollController();

  ScrollableCard({
    @required this.cardOffset,
    @required this.cardBuilder,
    @required this.minOffset,
    @required this.maxOffset,
    double startingOffset,
  }) : _offset = startingOffset ?? maxOffset {
    _lastOffset = _offset;
  }

  void liveScroll(double amount) {
    _offset = _lastOffset + amount;

    if (_offset < minOffset) {
      _offset = minOffset;
    } else if (_offset > maxOffset) {
      _offset = maxOffset;
    }
  }

  void scrollComplete() {
    _lastOffset = _offset;
  }
}

class ScrollableLayout extends StatefulWidget {
  final double maxScroll;
  final double minScroll;
  final List<ScrollableCard> scrollableCards;

  const ScrollableLayout({
    Key key,
    @required this.scrollableCards,
    this.maxScroll,
    this.minScroll,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ScrollableLayoutState(scrollableCards, maxScroll, minScroll);
  }
}

class ScrollableLayoutState extends State<ScrollableLayout> {
  final double maxScroll;
  final double minScroll;
  final List<ScrollableCard> scrollableCards;

  double _scrollStartPos;

  ScrollableLayoutState(this.scrollableCards, this.maxScroll, this.minScroll);

  int indexOfCardAtScrollStartAt(double pos) {
    double offset = scrollableCards[0]._lastOffset;

    for (int i = 1; i < scrollableCards.length; i++) {
      var card = scrollableCards[i];

      if (offset <= pos && pos < offset + card._lastOffset) {
        return i - 1;
      }

      offset += card._lastOffset;
    }

    return scrollableCards.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> cards = [];

    double offset = 0;

    for (var scrollableCard in scrollableCards) {
      offset += scrollableCard._offset;

      var card = Positioned(
        top: offset,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - offset,
          child: ListView(
            padding: EdgeInsets.zero,
//            physics: maxScroll != null && maxScroll < _lastScrolled + _scrolled
//                ? const BouncingScrollPhysics()
//                : const NeverScrollableScrollPhysics(),
            controller: scrollableCard.controller,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - offset,
                child:
                    scrollableCard.cardBuilder(context, scrollableCard._offset),
              ),
            ],
          ),
        ),
      );

      cards.add(card);
    }

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragStart: (DragStartDetails details) {
        // Store starting scrolling position to calculate scrolled amount
        _scrollStartPos = details.globalPosition.dy;
      },
      onVerticalDragUpdate: (DragUpdateDetails details) {
        var _scrolledAmount = details.globalPosition.dy - _scrollStartPos;

        // Card being dragged
        var _cardIndex = indexOfCardAtScrollStartAt(_scrollStartPos);

        setState(() {
          liveScrollCard(_cardIndex, _scrolledAmount);
        });
      },
      onVerticalDragEnd: (DragEndDetails details) {
        scrollComplete();
      },
      child: Stack(
        fit: StackFit.expand,
        children: cards,
      ),
    );
  }

  void liveScrollCard(int cardIndex, double scrollAmount) {
    var _card = scrollableCards[cardIndex];

    var scrollUpAmountAvailable = _card._lastOffset - _card.minOffset;
    var scrollDownAmountAvailable = _card.maxOffset - _card._lastOffset;

    print("Card $cardIndex");
    print("Scrolled $scrollAmount");
    print("_offset ${_card._lastOffset}");
    print("scrollUpAmountAvailable $scrollUpAmountAvailable");

    if (scrollAmount < 0 && scrollUpAmountAvailable + scrollAmount < 0) {
      // Can't scroll this card up anymore

      // Start scrolling card above it
      if (cardIndex > 0)
        liveScrollCard(cardIndex - 1, scrollUpAmountAvailable + scrollAmount);

      scrollAmount = -scrollUpAmountAvailable;
    }

    if (scrollAmount > 0 && scrollDownAmountAvailable - scrollAmount < 0) {
      // Can't scroll this card down anymore

      // Start scrolling card above it
      if (cardIndex > 0)
        liveScrollCard(cardIndex - 1, scrollAmount - scrollDownAmountAvailable);

      scrollAmount = scrollDownAmountAvailable;
    }

    _card.liveScroll(scrollAmount);
  }

  void scrollComplete() {
    for (var card in scrollableCards) {
      card.scrollComplete();
    }
  }
}

class InfiniteListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
    );

    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: index % 2 == 0 ? Colors.orange : Colors.red,
        );
      }),
    );
  }
}

//
//// TODO: Convert this into or wrap in a card deck widget for better code design
//class ScrollableLayout extends StatefulWidget {
//  final Widget main;
//  final Widget card;
//
//  final double maxOffset;
//  final double minOffset;
//
//  final bool Function() scrollable;
//
//  final void Function(double scrolledAmount) onTopOverScroll;
//  final void Function(double scrolledAmount) onBottomOverScroll;
//
//  ScrollableLayout(
//      {@required this.main,
//      @required this.card,
//      @required this.maxOffset,
//      this.minOffset = 0,
//      this.scrollable,
//      this.onTopOverScroll,
//      this.onBottomOverScroll});
//
//  @override
//  State<StatefulWidget> createState() => _ScrollableLayoutState(
//      main: main,
//      card: card,
//      maxOffset: maxOffset,
//      minOffset: minOffset,
//      scrollable: scrollable,
//      onTopOverScroll: onTopOverScroll,
//      onBottomOverScroll: onBottomOverScroll);
//}
//
//class _ScrollableLayoutState extends State<ScrollableLayout> {
//  final Widget main;
//  final Widget card;
//
//  final double maxOffset;
//  final double minOffset;
//
//  final bool Function() _scrollable;
//
//  final void Function(double scrolledAmount) _onTopOverScroll;
//  final void Function(double scrolledAmount) _onBottomOverScroll;
//
//  double currentOffset;
//
//  double _dragPos;
//
//  _ScrollableLayoutState(
//      {this.main,
//      this.card,
//      this.maxOffset,
//      this.minOffset = 0,
//      bool Function() scrollable,
//      void Function(double scrolledAmount) onTopOverScroll,
//      void Function(double scrolledAmount) onBottomOverScroll})
//      : currentOffset = maxOffset,
//        _scrollable = scrollable ?? (() => true),
//        _onTopOverScroll = onTopOverScroll ?? ((d) => {}),
//        _onBottomOverScroll = onBottomOverScroll ?? ((d) => {});
//
//  @override
//  Widget build(BuildContext context) {
//    return Stack(
//      children: <Widget>[
//        main,
//        Positioned(
//          top: currentOffset,
//          child: Container(
//            height: MediaQuery.of(context).size.height - currentOffset,
//            width: MediaQuery.of(context).size.width,
//            child: ListView(
//              padding: EdgeInsets.all(0.000000001),
//              physics: BouncingScrollPhysics(),
//              children: [
//                Container(
//                  height: MediaQuery.of(context).size.height - currentOffset,
//                  width: MediaQuery.of(context).size.width,
//                  child: card,
//                ),
//              ],
//            ),
//          ),
//        ),
//      ],
//    );
//
//    return Stack(
//      children: <Widget>[
//        main,
//        Positioned(
//          top: currentOffset,
//          child: GestureDetector(
//            onPanStart: (DragStartDetails details) {
//              _dragPos = details.globalPosition.dy;
//            },
//            onPanUpdate: (DragUpdateDetails details) {
//              if (!_scrollable()) return;
//
//              var _change = details.globalPosition.dy - _dragPos;
//              var _newOffset = currentOffset + _change;
//
//              if (_newOffset > maxOffset) {
//                _onBottomOverScroll(_newOffset - (maxOffset - currentOffset));
//                setState(() {
//                  currentOffset = maxOffset;
//                });
//              } else if (_newOffset < minOffset) {
//                _onTopOverScroll(_newOffset - (currentOffset - minOffset));
//                setState(() {
//                  currentOffset = minOffset;
//                });
//              } else {
//                setState(() {
//                  currentOffset = _newOffset;
//                });
//              }
//
//              _dragPos = details.globalPosition.dy;
//            },
//            child: Container(
//              height: MediaQuery.of(context).size.height - currentOffset,
//              width: MediaQuery.of(context).size.width,
//              child: Scrollable(
//                physics: BouncingScrollPhysics(),
//                viewportBuilder:
//                    (BuildContext context, ViewportOffset position) {
//                  return Container(
//                    height: MediaQuery.of(context).size.height - currentOffset,
//                    width: MediaQuery.of(context).size.width,
//                    child: card,
//                  );
//                },
//              ),
//            ),
//          ),
//        ),
//      ],
//    );
//  }
//}
