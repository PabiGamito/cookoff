import 'package:cookoff/scalar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:image_picker/image_picker.dart';

class CameraBackButton extends StatelessWidget {
  final Function _popScreen;

  CameraBackButton({Function popScreen}) : _popScreen = popScreen;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Scaler(context).scale(135),
      padding: EdgeInsets.only(
        top: Scaler(context).scale(35),
        bottom: Scaler(context).scale(18),
      ),
      margin: EdgeInsets.only(left: Scaler(context).scale(20)),
      child: Wrap(children: [
        GestureDetector(
          onTap: _popScreen,
          child: Icon(
            Icons.clear,
            size: Scaler(context).scale(40),
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
          height: Scaler(context).scale(70),
          width: Scaler(context).scale(250),
          padding: EdgeInsets.symmetric(vertical: Scaler(context).scale(5)),
          decoration: BoxDecoration(
              color: Color(0x60000000),
              borderRadius:
                  BorderRadius.all(Radius.circular(Scaler(context).scale(30)))),
          child: Center(
            child: Text(
              "Add Picture",
              style: TextStyle(
                fontSize: Scaler(context).scale(24),
                fontFamily: "Montserrat",
                color: Colors.white,
                letterSpacing: 3,
              ),
            ),
          ),
        ),
      );
}

Future getImageFromSource() async {
  var image = await ImagePicker.pickImage(source: ImageSource.camera);
  if (image != null) {
    var compressedImage = await FlutterNativeImage.compressImage(image.path,
        quality: 50, percentage: 50);
    image.delete();
    return compressedImage;
  }
  return null;
}
