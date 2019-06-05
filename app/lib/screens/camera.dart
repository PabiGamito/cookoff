import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cookoff/blocs/camera_bloc.dart';
import 'package:cookoff/scalar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  final Color _bgColor;

  CameraScreen({Color backgroundColor = Colors.deepPurple})
      : _bgColor = backgroundColor;

  @override
  State<StatefulWidget> createState() {
    return CameraScreenState(_bgColor);
  }
}

class CameraScreenState extends State<CameraScreen> {
  final Color bgColor;
  CameraController _controller;

  CameraScreenState(this.bgColor);

  // Initialises the camera
  @override
  void initState() {
    super.initState();
    CameraAdapter().getCameraController().then((controller) {
      _controller = controller;
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Make sure to dispose of the controller when the Widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until
      // the controller has finished initializing
      body: FutureBuilder<void>(
        future: _controller?.initialize(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview
            return Center(
                child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: CameraPreview(_controller)));
          } else {
            // Otherwise, display a loading indicator
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.camera_alt,
        ),
        // Provide an onPressed callback
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure the camera is initialized
            await _controller.initialize();

            // Construct the path where the image should be saved using the path
            // package.
            final path = join(
              // In this example, store the picture in the temp directory. Find
              // the temp directory using the `path_provider` plugin.
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            // Attempt to take a picture and log where it's been saved
            await _controller.takePicture(path);

            // If the picture was taken, display it on a new screen
            // TODO: Send event to screenshot bloc
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DisplayPictureScreen(bgColor: bgColor, imagePath: path),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }
}

// A Widget that displays the picture taken by the user
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final Color bgColor;

  const DisplayPictureScreen({Key key, this.bgColor, this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image
      backgroundColor: bgColor,
      body: Stack(
        children: [
          Center(child: Image.file(File(imagePath))),
          IconBackButton(
            () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.clear,
              color: Colors.white,
              size: Scalar(context).scale(30),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.file_upload,
            size: Scalar(context).scale(30),
          ),
          onPressed: () async {
            // TODO: Call Hannes dispatch
            // Returns to the challenge screen (maybe update some bloc?)
            Navigator.pop(context);
            Navigator.pop(context);
          }),
    );
  }
}

// Back button
class IconBackButton extends StatelessWidget {
  final Function _popScreen;
  final Widget _icon;

  IconBackButton(Function popScreen, {Widget icon})
      : _popScreen = popScreen,
        _icon = icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Scalar(context).scale(135),
      padding: EdgeInsets.only(
        top: Scalar(context).scale(35),
        bottom: Scalar(context).scale(18),
      ),
      margin: EdgeInsets.only(
          left: Scalar(context).scale(20), top: Scalar(context).scale(25)),
      child: Wrap(children: [
        GestureDetector(
          onTap: _popScreen,
          child: _icon,
        ),
      ]),
    );
  }
}
