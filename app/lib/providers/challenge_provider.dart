import 'package:cookoff/models/challenge.dart';

abstract class ChallengeProvider {
  // This is a temporary interface - the user param should be changed to a
  // class at some point rather than a string
  Stream<Iterable<Challenge>> challengesStream(String user);

  Stream<Iterable<Challenge>> archivedChallengesStream(String user);

  Future<Challenge> addChallenge(Challenge challenge);

  Future deleteChallenge(Challenge challenge);

  Future updateChallenge(Challenge challenge);
}
