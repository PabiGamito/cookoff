import 'dart:io';

import 'package:cookoff/models/user.dart';
import 'package:cookoff/providers/challenge_provider.dart';
import 'package:cookoff/providers/picture_provider.dart';
import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {
  GameEvent([List props = const []]) : super(props);
}

class GameButton extends GameEvent {
  final ChallengeProvider challengeProvider;

  GameButton(this.challengeProvider) : super([challengeProvider]);
}

class FriendButton extends GameEvent {
  final String friend;

  FriendButton(this.friend) : super([friend]);
}

class UploadPictureButton extends GameEvent {
  final File file;
  final PictureProvider uploader;

  UploadPictureButton(this.file, this.uploader) : super([file, uploader]);
}

// Mark a single user as finished on that challenge
class FinishChallengeButton extends GameEvent {
  final User user;
  final ChallengeProvider challengeProvider;

  FinishChallengeButton(this.user, this.challengeProvider)
      : super([user, challengeProvider]);
}

// Complete a challenge (for all users)
class CompleteChallenge extends GameEvent {
  final ChallengeProvider challengeProvider;

  CompleteChallenge(this.challengeProvider) : super([challengeProvider]);
}
