import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookoff/providers/auth_provider.dart';
import 'package:cookoff/providers/challenge_provider.dart';

import 'firebase/auth_firebase_adapter.dart';
import 'firebase/challenge_firebase_adapter.dart';

class Injector {
  final Firestore firestore = Firestore.instance;
  final ChallengeProvider challengeProvider =
      ChallengeFirebaseAdapter(Firestore.instance);
  final AuthProvider authProvider = AuthFirebaseAdapter();
}
