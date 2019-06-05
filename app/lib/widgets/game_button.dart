import 'package:cookoff/blocs/bloc.dart';
import 'package:cookoff/models/challenge.dart';
import 'package:cookoff/scalar.dart';
import 'package:cookoff/screens/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CameraButton extends StatelessWidget {
  final Color _bgColor;
  final GameBloc _bloc;

  CameraButton({Color backgroundColor, GameBloc bloc})
      : _bgColor = backgroundColor,
        _bloc = bloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: _bloc,
      builder: (BuildContext context, Challenge challenge) => Visibility(
        visible: challenge.started,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Scaffold(
                  body: CameraScreen(
                    backgroundColor: _bgColor,
                    bloc: _bloc,
                  ),
                ),
              ),
            );
          },
          child: Container(
            height: 60,
            margin: EdgeInsets.symmetric(
                horizontal: Scalar(context).scale(170)),
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30))),
            child: Center(
              child: Icon(
                Icons.photo_camera,
                color: Colors.lightBlue,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
