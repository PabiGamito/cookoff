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
        .where("owner", isEqualTo: user)
        .snapshots()
        .map((qs) =>
        qs.documents.map((ds) =>
            Challenge(
                ds.documentID,
                ds.data["owner"],
                ds.data["participants"],
                ds.data["ingredient"],
                ds.data["complete"],
                ds.data["endtime"]
            )));
  }

  @override
  Future addChallenge(Challenge challenge) async {
    await _firestore.collection(collection).add({
      "participants": challenge.participants,
      "complete": challenge.complete,
      "endtime": challenge.endTime,
      "ingredient": challenge.ingredient,
      "owner": challenge.owner
    });
  }

  @override
  Future deleteChallenge(Challenge challenge) async {
    await _firestore.collection(collection).document(challenge.id).delete();
  }

  @override
  Future updateChallenge(Challenge curr, Challenge next) async {
    await _firestore.collection(collection).document(curr.id).updateData({
      "participants": next.participants,
      "complete": next.complete,
      "endtime": next.endTime,
      "ingredient": next.ingredient,
      "owner": next.owner
    });
  }


}
