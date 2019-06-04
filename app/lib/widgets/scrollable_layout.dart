import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CardController {
  ScrollableCard _card;

  CardController({ScrollableCard card}) : _card = card;

  void attachTo(ScrollableCard card) {
    _card = card;
  }
}

class ScrollableCard {
  double _offset;
  double _lastOffset;

  double minOffset;
  double maxOffset;

  bool bounce;
  bool scrollable;

  // Set when card is added to ScrollableLayout
  int _cardIndex;
  ScrollableLayoutState _state;

  final double Function(BuildContext context, double scrolledAmount) cardOffset;
  final Widget Function(
          BuildContext context, double scrolledAmount, bool fullyExpanded)
      cardBuilder;

  final ScrollController controller = ScrollController();

  ScrollableCard({
    @required this.cardOffset,
    @required this.cardBuilder,
    @required this.minOffset,
    @required this.maxOffset,
    double startingOffset,
    this.bounce = true,
    this.scrollable = true,
    CardController controler,
  }) : _offset = startingOffset ?? maxOffset {
    _lastOffset = _offset;
    controler?.attachTo(this);
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

  bool fullyExpanded() {
    return _offset <= minOffset;
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

  ScrollableLayoutState(this.scrollableCards, this.maxScroll, this.minScroll) {
    for (int i = 0; i < scrollableCards.length; i++) {
      var _card = scrollableCards[i];
      _card._state = this;
      _card._cardIndex = i;
    }
  }

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

  void maximize(BuildContext context, int cardIndex) {
    setState(() {
      scrollableCards[cardIndex]._offset = 0;
    });
  }

  void minimize(BuildContext context, int cardIndex) {
    setState(() {
      scrollableCards[cardIndex]._offset = MediaQuery.of(context).size.height;
    });
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
            physics: const NeverScrollableScrollPhysics(),
            controller: scrollableCard.controller,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - offset,
                child: scrollableCard.cardBuilder(context,
                    scrollableCard._offset, scrollableCard.fullyExpanded()),
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

        double extraScrollAmount;

        setState(() {
          extraScrollAmount = liveScrollCard(_cardIndex, _scrolledAmount);
        });

        var _card = scrollableCards[_cardIndex];

        // Over limit scrolling, hack to get bounce effect (div by 3 to scale bounce amount)
        if (_card.bounce) _card.controller.jumpTo(-extraScrollAmount / 10);
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

  double liveScrollCard(int cardIndex, double scrollAmount) {
    double extraScrollAmount = 0;

    var _card = scrollableCards[cardIndex];

    var scrollUpAmountAvailable = _card._lastOffset - _card.minOffset;
    var scrollDownAmountAvailable = _card.maxOffset - _card._lastOffset;

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
      if (cardIndex > 0) {
        extraScrollAmount = liveScrollCard(
            cardIndex - 1, scrollAmount - scrollDownAmountAvailable);
      } else {
        extraScrollAmount = scrollAmount - scrollDownAmountAvailable;
      }

      scrollAmount = scrollDownAmountAvailable;
    }

    _card.liveScroll(scrollAmount);

    return extraScrollAmount;
  }

  void scrollComplete() {
    for (var card in scrollableCards) {
      card.scrollComplete();
    }
  }
}
