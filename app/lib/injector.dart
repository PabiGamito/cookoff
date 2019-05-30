import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookoff/providers/challenge_provider.dart';

import 'firebase/challenge_firebase_adapter.dart';

class Injector {
  final Firestore firestore = Firestore.instance;
  final ChallengeProvider challengeProvider =
      ChallengeFirebaseAdapter(Firestore.instance);
}
