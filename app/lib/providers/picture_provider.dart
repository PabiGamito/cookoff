import 'package:cookoff/models/challenge.dart';

abstract class PictureProvider {
  Stream<Iterable<String>> picturesOfIngredient(String ingredient);

  Future<Challenge> uploadPicture(String path, Challenge challenge);
}
