import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookoff/models/challenge.dart';
import 'package:cookoff/providers/challenge_provider.dart';

class ChallengeFirebaseAdapter implements ChallengeProvider {
  Firestore _firestore;

  static final String collection = 'challenges';

  ChallengeFirebaseAdapter(Firestore firestore) : _firestore = firestore;

  @override
  Stream<Iterable<Challenge>> challengesStream(String user) {
    return _firestore
        .collection(collection)
        .where('owner', isEqualTo: user)
        .snapshots()
        .map((snapshot) =>
            snapshot.documents.map((json) => Challenge.fromJson(json.data)));
  }

  @override
  Future addChallenge(Challenge challenge) async {
    await _firestore.collection(collection).add(challenge.toJson());
  }

  @override
  Future deleteChallenge(Challenge challenge) async {
    await _firestore.collection(collection).document(challenge.id).delete();
  }

  @override
  Future updateChallenge(Challenge challenge) async {
    await _firestore
        .collection(collection)
        .document(challenge.id)
        .updateData(challenge.toJson());
  }
}
