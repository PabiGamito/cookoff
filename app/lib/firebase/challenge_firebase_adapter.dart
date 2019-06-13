import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookoff/models/challenge.dart';
import 'package:cookoff/providers/challenge_provider.dart';

class ChallengeFirebaseAdapter implements ChallengeProvider {
  static const String _collection = 'challenges';

  static final Firestore _firestore = Firestore.instance;

  // Return all challenges
  Stream<Iterable<Challenge>> allChallengesStream(String user) => _firestore
      .collection(_collection)
      .where('participants', arrayContains: user)
      .snapshots()
      .map((snapshot) => snapshot.documents.map((document) =>
          Challenge.fromJson(document.data..['id'] = document.documentID)));

  // Return challenges that expired at most 1 day ago, or are still ongoing
  @override
  Stream<Iterable<Challenge>> challengesStream(String user) =>
      allChallengesStream(user).map((challenges) => challenges.where(
          (challenge) => challenge.end
              .isAfter(DateTime.now().subtract(Duration(days: 1)))));

  // Return challenges that expired more than one day ago
  @override
  Stream<Iterable<Challenge>> archivedChallengesStream(String user) =>
      allChallengesStream(user).map((challenges) => challenges.where(
          (challenge) => challenge.end
              .isBefore(DateTime.now().subtract(Duration(days: 1)))));

  @override
  Future<Challenge> addChallenge(Challenge challenge) async {
    var reference = await _firestore
        .collection(_collection)
        .add(challenge.toJson()..remove('id'));
    return challenge.copyWithId(reference.documentID);
  }

  @override
  Future deleteChallenge(Challenge challenge) async =>
      await _firestore.collection(_collection).document(challenge.id).delete();

  @override
  Future updateChallenge(Challenge challenge) async {
    await _firestore
        .collection(_collection)
        .document(challenge.id)
        .updateData(challenge.toJson()..remove('id'));
  }
}
