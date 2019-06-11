import 'package:cookoff/firebase/auth_firebase_adapter.dart';
import 'package:cookoff/firebase/challenge_firebase_adapter.dart';
import 'package:cookoff/firebase/picture_firebase_adapter.dart';
import 'package:cookoff/firebase/user_firebase_adapter.dart';
import 'package:cookoff/providers/auth_provider.dart';
import 'package:cookoff/providers/challenge_provider.dart';
import 'package:cookoff/providers/ingredient_provider.dart';
import 'package:cookoff/providers/local_ingredient_provider.dart';
import 'package:cookoff/providers/picture_provider.dart';
import 'package:cookoff/providers/user_provider.dart';

import 'firebase/picture_firebase_adapter.dart';
import 'providers/picture_provider.dart';

class Injector {
  final AuthProvider authProvider = AuthFirebaseAdapter();

  final ChallengeProvider challengeProvider = ChallengeFirebaseAdapter();

  final IngredientProvider ingredientProvider = LocalIngredientProvider();

  final UserProvider userProvider = UserFirebaseAdapter();

  final PictureProvider pictureProvider = PictureFirebaseAdapter();
}
