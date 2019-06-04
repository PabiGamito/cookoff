import 'package:camera/camera.dart';

abstract class CameraControllerProvider {
  // Get camera controller
  Future<CameraController> getCameraController();

  // Get all cameras
  Future<List<CameraDescription>> cameras();

  // Get the first camera
  Future<CameraDescription> firstCamera();
}
