import 'dart:io';

import 'package:cookoff/providers/picture_provider.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

abstract class GameEvent extends Equatable {
  GameEvent([List props = const []]) : super(props);
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
  final PictureProvider uploader;

  UploadPictureButton(this.file, this.uploader) : super([file, uploader]);
}
