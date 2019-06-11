import 'dart:io';

import 'package:cookoff/blocs/game_bloc.dart';
import 'package:cookoff/blocs/game_event.dart';
import 'package:cookoff/widgets/camera.dart';
import 'package:cookoff/widgets/injector_widget.dart';
import 'package:cookoff/widgets/user_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class CameraScreen extends StatefulWidget {
  final Color _bgColor;
  final GameBloc _bloc;
  final File _image;

  CameraScreen(
      {Color backgroundColor = Colors.deepPurple,
      @required GameBloc bloc,
      @required File image})
      : _bgColor = backgroundColor,
        _bloc = bloc,
        _image = image;

  @override
  State<StatefulWidget> createState() {
    return CameraScreenState(_bgColor, _bloc, _image);
  }
}

class CameraScreenState extends State<CameraScreen> {
  final Color bgColor;
  final GameBloc _bloc;
  final File _image;

  _popScreen() {
    // Delete image on back press
    if (_image != null) {
      _image.deleteSync();
    }

    // Set status bar color on Android to match header
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: bgColor,
    ));

    Navigator.pop(context);
  }

  CameraScreenState(this.bgColor, this._bloc, this._image);

  @override
  Widget build(BuildContext context) {
    // Set status bar color on Android to match header
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: bgColor,
    ));
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          // Display image if it exists (should exist atm)
          Center(
            child: _image == null
                ? GestureDetector(
                    onTap: () async {
                      getImageFromSource();
                    },
                    child: AddNewPictureButton(
                      onTap: () {
                        getImageFromSource();
                      },
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(_image),
                      ),
                    ),
                    child: Image.file(_image),
                  ),
          ),

          // Cancel upload button
          CameraBackButton(popScreen: _popScreen),
        ],
      ),

      // Upload image button
      floatingActionButton: _image == null
          ? Container()
          : FloatingActionButton(
              onPressed: () {
                _bloc.dispatch(FinishChallengeButton(UserWidget
                    .of(context)
                    .user,
                    InjectorWidget
                        .of(context)
                        .injector
                        .challengeProvider));
                Navigator.pop(context);
                _popScreen();
              },
              child: Icon(Icons.cloud_upload),
            ),
    );
  }
}
