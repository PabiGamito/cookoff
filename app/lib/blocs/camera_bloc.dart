import 'package:camera/camera.dart';
import 'package:cookoff/providers/camera_provider.dart';

class CameraAdapter implements CameraControllerProvider {
  List<CameraDescription> _cameraList;
  static const resolution = ResolutionPreset.medium;

  @override
  Future<List<CameraDescription>> cameras() async {
    _cameraList = await availableCameras();
    return _cameraList;
  }

  @override
  Future<CameraDescription> firstCamera() async {
    if (_cameraList == null) {
      await cameras();
    }
    return _cameraList.first;
  }

  @override
  Future<CameraController> getCameraController() async {
    var cameras = await availableCameras();
    var controller = CameraController(
      cameras[0],
      resolution,
    );
    return controller;
  }
}
