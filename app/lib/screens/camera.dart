import 'dart:io';

import 'package:cookoff/blocs/game_bloc.dart';
import 'package:cookoff/blocs/game_event.dart';
import 'package:cookoff/scalar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class CameraScreen extends StatefulWidget {
  final Color _bgColor;
  final GameBloc _bloc;

  CameraScreen(
      {Color backgroundColor = Colors.deepPurple, @required GameBloc bloc})
      : _bgColor = backgroundColor,
        _bloc = bloc;

  @override
  State<StatefulWidget> createState() {
    return CameraScreenState(_bgColor, _bloc);
  }
}

class CameraScreenState extends State<CameraScreen> {
  final Color bgColor;
  final GameBloc _bloc;
  File _image;

  CameraScreenState(this.bgColor, this._bloc);

  @override
  void dispose() {
    // Make sure to dispose of the controller when the Widget is disposed
    super.dispose();
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          CameraBackButton(popScreen: () {
            Navigator.pop(context);
          }),
          Center(
            child: _image == null
                ? GestureDetector(onTap: () async {
                    getImage();
                  }, child: AddNewPictureButton(
                    onTap: () {
                      getImage();
                    },
                  ))
                : Image.file(_image),
          ),
        ],
      ),
      floatingActionButton: _image == null
          ? Container()
          : FloatingActionButton(
              onPressed: () {
                _bloc.dispatch(UploadPictureButton(_image));
                Navigator.pop(context);
              },
              tooltip: 'Upload your image',
              child: Icon(Icons.save_alt),
            ),
    );
  }
}

class CameraBackButton extends StatelessWidget {
  final Function _popScreen;

  CameraBackButton({Function popScreen}) : _popScreen = popScreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Scalar(context).scale(135),
      padding: EdgeInsets.only(
        top: Scalar(context).scale(35),
        bottom: Scalar(context).scale(18),
      ),
      margin: EdgeInsets.only(left: Scalar(context).scale(20)),
      child: Wrap(children: [
        GestureDetector(
          onTap: _popScreen,
          child: Icon(
            Icons.clear,
            size: Scalar(context).scale(40),
            color: Colors.white,
          ),
        ),
      ]),
    );
  }
}

class AddNewPictureButton extends StatelessWidget {
  final Function _onTap;

  AddNewPictureButton({Function onTap}) : _onTap = onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: _onTap,
      child: Container(
          height: Scalar(context).scale(70),
          width: Scalar(context).scale(250),
          padding: EdgeInsets.symmetric(vertical: Scalar(context).scale(5)),
          decoration: BoxDecoration(
              color: Color(0x60000000),
              borderRadius:
                  BorderRadius.all(Radius.circular(Scalar(context).scale(30)))),
          child: Center(
              child: Text("Add Picture",
                  style: TextStyle(
                    fontSize: Scalar(context).scale(24),
                    fontFamily: "Montserrat",
                    color: Colors.white,
                    letterSpacing: 3,
                  )))));
}
