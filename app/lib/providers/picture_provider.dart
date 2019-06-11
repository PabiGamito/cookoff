import 'package:cookoff/models/challenge.dart';

abstract class PictureProvider {
  Stream<Iterable<String>> picturesStream(String ingredient);

  Stream<Iterable<String>> challengePictureStream(Challenge challenge);

  Future<Challenge> uploadPicture(String path, Challenge challenge);
}
