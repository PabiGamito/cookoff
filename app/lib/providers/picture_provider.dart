import 'package:cookoff/models/challenge.dart';

abstract class PictureProvider {
  Stream<Iterable<String>> picturesStream(String ingredient);

  Future<Challenge> uploadPicture(String path, Challenge challenge);
}
