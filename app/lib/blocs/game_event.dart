import 'dart:io';

import 'package:cookoff/models/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

abstract class GameEvent extends Equatable {
  GameEvent([List props = const []]) : super(props);
}

class SetOwner extends GameEvent {
  final User owner;

  SetOwner(this.owner) : super([owner]);
}

class GameButton extends GameEvent {
  final BuildContext context;

  GameButton(this.context) : super([context]);
}

class FriendButton extends GameEvent {
  final String friend;

  FriendButton(this.friend) : super([friend]);
}

class UploadPictureButton extends GameEvent {
  final File file;

  UploadPictureButton(this.file) : super([file]);
}
