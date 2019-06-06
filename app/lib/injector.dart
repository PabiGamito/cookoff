import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookoff/firebase/auth_firebase_adapter.dart';
import 'package:cookoff/firebase/challenge_firebase_adapter.dart';
import 'package:cookoff/firebase/user_firebase_adapter.dart';
import 'package:cookoff/providers/auth_provider.dart';
import 'package:cookoff/providers/challenge_provider.dart';
import 'package:cookoff/providers/ingredient_provider.dart';
import 'package:cookoff/providers/local_ingredient_provider.dart';
import 'package:cookoff/providers/user_provider.dart';

import 'firebase/auth_firebase_adapter.dart';
import 'firebase/challenge_firebase_adapter.dart';
import 'firebase/user_firebase_adapter.dart';

class Injector {
  final AuthProvider authProvider = AuthFirebaseAdapter();

  final ChallengeProvider challengeProvider =
      ChallengeFirebaseAdapter(Firestore.instance);

  final Firestore firestore = Firestore.instance;

  final IngredientProvider ingredientProvider = LocalIngredientProvider();

  final UserProvider userProvider = UserFirebaseAdapter();
}
