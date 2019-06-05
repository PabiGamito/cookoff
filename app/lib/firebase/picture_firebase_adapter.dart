import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookoff/models/challenge.dart';
import 'package:cookoff/providers/challenge_provider.dart';
import 'package:cookoff/providers/picture_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class PictureFirebaseAdapter implements PictureProvider {
  final FirebaseStorage storage = FirebaseStorage();
  final ChallengeProvider _challengeProvider;
  final Firestore _firestore = Firestore.instance;

  PictureFirebaseAdapter({ChallengeProvider challengeProvider})
      : this._challengeProvider = challengeProvider;

  @override
  Future<Challenge> uploadPicture(String path, Challenge challenge) async {
    // prepare data
    final file = File(path);
    final ref = storage.ref().child(basename(file.path));
    final task = ref.putFile(File(path));

    // upload
    await task.onComplete;

    // store upload in database
    final newChallenge = challenge.copyWithImage(ref.path);
    _challengeProvider.updateChallenge(challenge);
    return newChallenge;
  }

  @override
  Stream<Iterable<String>> picturesOfIngredient(String ingredient) {
    return _firestore
        .collection('challenges')
        .where('ingredient', isEqualTo: ingredient)
        .snapshots()
        .map((QuerySnapshot e) => e.documents
            .map((DocumentSnapshot doc) => Challenge.fromJson(doc.data).images)
            .reduce((List<String> a, List<String> b) => [...a, ...b]));
  }
}
