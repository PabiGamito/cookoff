import 'dart:io';

import 'package:cookoff/models/challenge.dart';
import 'package:cookoff/providers/challenge_provider.dart';
import 'package:cookoff/providers/picture_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class PictureFirebaseAdapter implements PictureProvider {

  final FirebaseStorage storage = FirebaseStorage();
  final ChallengeProvider _challengeProvider;

  PictureFirebaseAdapter({ChallengeProvider challengeProvider})
      : this._challengeProvider = challengeProvider;

  @override
  Future uploadPicture(String path, Challenge challenge) async {
    // prepare data
    final file = File(path);
    final ref = storage.ref().child(basename(file.path));
    final task = ref.putFile(File(path));

    // upload
    await task.onComplete;

    // store upload in database
    challenge.addImage(ref.path);
    _challengeProvider.updateChallenge(challenge);
  }

}
