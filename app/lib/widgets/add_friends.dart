import 'package:cookoff/widgets/injector_widget.dart';
import 'package:cookoff/widgets/titled_section.dart';
import 'package:cookoff/widgets/user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../scalar.dart';

// Friend adder overlay
class FriendsAdder extends StatefulWidget {
  final bool _toShow;
  final Function _onTap;

  FriendsAdder({bool visible = false, Function onTap})
      : _toShow = visible,
        _onTap = onTap;

  @override
  State<StatefulWidget> createState() {
    return _FriendsAdderState(_toShow, _onTap);
  }
}

class _FriendsAdderState extends State<FriendsAdder> {
  final Function _onTap;

  // TODO: Bloc it out
  String _currentText = "";
  bool _addFriendsScreen;
  bool _submittedRequest = false;
  bool _friendAdded = false;

  void submitAddRequest(String email) async {
    // TODO: Email check?
    if (email == null || email.length < 1) {
      return;
    }

    print("Email: $email, User id: ${UserWidget.of(context).user.email}");

    var friendAdded = await InjectorWidget.of(context)
        .injector
        .userProvider
        .addFriend(email, UserWidget.of(context).user);

    setState(() {
      _submittedRequest = true;
      _friendAdded = friendAdded;
    });
  }

  _FriendsAdderState(this._addFriendsScreen, this._onTap);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Visibility(
          visible: _addFriendsScreen,
          child: Stack(
            children: [
              OverlayBackground(
                onTap: () {
                  if (_onTap != null) _onTap();
                  setState(() {
                    _addFriendsScreen = false;
                  });
                },
              ),
              Center(
                child: AddFriendCard(
                  button: SubmitUIButton(
                    currentText: _currentText,
                    onTap: submitAddRequest,
                    requestSuccessful: _friendAdded,
                    submittedRequest: _submittedRequest,
                  ),
                  textField: AddFriendsTextField(
                    onChange: (String input) {
                      setState(() {
                        _currentText = input;
                        _submittedRequest = false;
                      });
                    },
                    onSubmit: submitAddRequest,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class OverlayBackground extends StatelessWidget {
  final Function _onTap;

  const OverlayBackground({Function onTap}) : _onTap = onTap;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color(0x22000000),
      ),
    );
  }
}

class AddFriendCard extends StatelessWidget {
  final Widget _textField;
  final Widget _button;

  const AddFriendCard({@required Widget textField, @required Widget button})
      : _textField = textField,
        _button = button;

  @override
  Widget build(BuildContext context) {
    var scaler = Scaler(context);
    return Container(
      height: scaler.scale(280),
      width: scaler.scale(340),
      padding: EdgeInsets.all(scaler.scale(30)),
      decoration: new BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(scaler.scale(50)),
      ),
      child: TitledSection(
        title: "Add Friends",
        titleColor: Color(0xFF000000),
        underlineColor: Color(0xFF000000),
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _textField,
              _button,
            ],
          ),
        ),
      ),
    );
  }
}

class AddFriendsTextField extends StatelessWidget {
  final Function _onChange;
  final Function _onSubmit;

  AddFriendsTextField({Key key, Function onChange, Function onSubmit})
      : _onChange = onChange,
        _onSubmit = onSubmit;

  @override
  Widget build(BuildContext context) {
    var field = TextField(
      onChanged: _onChange,
      onSubmitted: _onSubmit,
      autocorrect: false,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Enter an email',
      ),
    );
    var scaler = Scaler(context);
    return Stack(
      children: <Widget>[
        Container(
          height: scaler.scale(60),
          width: scaler.scale(325),
          decoration: BoxDecoration(
            color: Color(0x08000000),
            borderRadius: BorderRadius.circular(scaler.scale(20)),
          ),
        ),
        Positioned(
          left: scaler.scale(10),
          top: scaler.scale(5),
          child: Container(
            height: scaler.scale(60),
            width: scaler.scale(325),
            child: field,
          ),
        ),
      ],
    );
  }
}

class SubmitUIButton extends StatelessWidget {
  final Function _onTap;
  final String _currentText;
  final bool _submittedRequest;
  final bool _requestSuccessful;

  SubmitUIButton(
      {Function(String email) onTap,
      String currentText,
      bool submittedRequest,
      bool requestSuccessful})
      : _onTap = onTap,
        _currentText = currentText,
        _submittedRequest = submittedRequest,
        _requestSuccessful = requestSuccessful;

  @override
  Widget build(BuildContext context) {
    if (!_submittedRequest)
      return AddUIButton(
        onTap: _onTap,
        currentText: _currentText,
      );

    if (_requestSuccessful) {
      return SuccessfulAddUIButton();
    } else {
      return FailedAddUIButton(
        onTap: _onTap,
        currentText: _currentText,
      );
    }
  }
}

class FailedAddUIButton extends StatelessWidget {
  final Function _onTap;
  final String _currentText;

  FailedAddUIButton({Function(String email) onTap, String currentText})
      : _onTap = onTap,
        _currentText = currentText;

  @override
  Widget build(BuildContext context) => _SubmitUIButton(
        text: "Failed",
        icon: Icon(Icons.clear),
        color: Colors.red,
        onTap: () {
          _onTap(_currentText);
        },
      );
}

class AddUIButton extends StatelessWidget {
  final Function _onTap;
  final String _currentText;

  AddUIButton({Function(String email) onTap, String currentText})
      : _onTap = onTap,
        _currentText = currentText;

  @override
  Widget build(BuildContext context) => _SubmitUIButton(
        text: "Add",
        icon: Icon(Icons.add),
        color: Colors.amber,
        onTap: () {
          _onTap(_currentText);
        },
      );
}

class SuccessfulAddUIButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _SubmitUIButton(
      color: Colors.green, text: "Added", icon: Icon(Icons.check));
}

class _SubmitUIButton extends StatelessWidget {
  final Color _color;
  final Function _onTap;
  final String _text;
  final Widget _icon;

  _SubmitUIButton(
      {Color color, Function onTap, @required String text, Widget icon})
      : _color = color,
        _onTap = onTap,
        _text = text,
        _icon = icon;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: _onTap,
        child: Container(
          width: Scaler(context).scale(180),
          padding: EdgeInsets.symmetric(vertical: Scaler(context).scale(6)),
          decoration: BoxDecoration(
              color: _color,
              borderRadius:
                  BorderRadius.all(Radius.circular(Scaler(context).scale(20)))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _icon,
              Text(
                _text,
                style: TextStyle(
                  fontSize: Scaler(context).scale(23),
                  fontFamily: "Montserrat",
                  color: Colors.black54,
                  letterSpacing: 3,
                ),
              ),
            ],
          ),
        ),
      );
}
