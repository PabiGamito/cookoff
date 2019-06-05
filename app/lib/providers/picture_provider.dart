import 'package:cookoff/models/challenge.dart';

abstract class PictureProvider {
  Stream<Iterable<String>> picturesOfIngredient(String ingredient);
  Future uploadPicture(String path, Challenge challenge);
}
