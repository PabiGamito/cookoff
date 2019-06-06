import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookoff/firebase/challenge_firebase_adapter.dart';
import 'package:cookoff/models/challenge.dart';
import 'package:cookoff/providers/challenge_provider.dart';
import 'package:cookoff/providers/picture_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class PictureFirebaseAdapter implements PictureProvider {
  static final Firestore _firestore = Firestore.instance;

  final FirebaseStorage _storage = FirebaseStorage();
  final ChallengeProvider _challengeProvider = ChallengeFirebaseAdapter();

  @override
  Stream<Iterable<String>> picturesStream(String ingredient) => _firestore
      .collection('challenges')
      .where('ingredient', isEqualTo: ingredient)
      .snapshots()
      .map((QuerySnapshot e) => e.documents
          .map((DocumentSnapshot doc) => Challenge.fromJson(doc.data).images)
          .reduce((List<String> a, List<String> b) => [...a, ...b]));

  @override
  Future<Challenge> uploadPicture(String path, Challenge challenge) async {
    // Prepare data
    var file = File(path);
    var ref = _storage.ref().child(basename(file.path));
    var task = ref.putFile(File(path));

    // Upload
    await task.onComplete;

    String downloadUrl = await ref.getDownloadURL();
    // Store upload in database
    var newChallenge = challenge.copyWithImage(downloadUrl);
    _challengeProvider.updateChallenge(newChallenge);
    return newChallenge;
  }
}
