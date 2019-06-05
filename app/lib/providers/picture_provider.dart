import 'package:cookoff/models/challenge.dart';

abstract class PictureProvider {
  Future uploadPicture(String path, Challenge challenge);
}
