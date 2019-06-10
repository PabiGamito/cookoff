import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'challenge.g.dart';

@JsonSerializable(anyMap: true)
class Challenge {
  @JsonKey(includeIfNull: false, nullable: true)
  final String id;
  final String owner;
  final Set<String> participants;
  final Set<String> finishedParticipants;
  final String ingredient;
  final bool complete;
  final DateTime end;
  final List<String> images;

  Challenge(
      {this.id,
      @required this.owner,
      Set<String> participants,
      @required this.ingredient,
      this.complete = false,
      @required this.end,
      List<String> images,
      Set<String> finishedParticipants})
      : participants = participants ?? {owner},
        images = images ?? [],
        finishedParticipants = finishedParticipants ?? {};

  factory Challenge.fromJson(Map<String, dynamic> json) =>
      _$ChallengeFromJson(json);

  bool get started => id != null;

  bool hasParticipant(String participant) => participants.contains(participant);

  Challenge copyWithId(String id) => Challenge(
      id: id,
      owner: owner,
      participants: participants,
      finishedParticipants: finishedParticipants,
      ingredient: ingredient,
      complete: complete,
      end: end,
      images: images);

  Challenge copyWithParticipant(String participant) => Challenge(
      id: id,
      owner: owner,
      participants: {...participants, participant},
      ingredient: ingredient,
      complete: complete,
      end: end,
      images: images);

  Challenge copyWithoutParticipant(String participant) => Challenge(
      id: id,
      owner: owner,
      participants: participants.where((p) => p != participant).toSet(),
      finishedParticipants: finishedParticipants,
      ingredient: ingredient,
      complete: complete,
      end: end,
      images: images);

  Challenge copyAsComplete() => Challenge(
      id: id,
      owner: owner,
      participants: participants,
      finishedParticipants: finishedParticipants,
      ingredient: ingredient,
      complete: true,
      end: end,
      images: images);

  Challenge copyWithImage(String path) => Challenge(
      id: id,
      owner: owner,
      participants: participants,
      finishedParticipants: finishedParticipants,
      ingredient: ingredient,
      complete: complete,
      end: end,
      images: [...images, path]);

  Challenge copyWithParticipantFinished(String participant) => Challenge(
      id: id,
      owner: owner,
      participants: participants,
      finishedParticipants: {...finishedParticipants, participant},
      ingredient: ingredient,
      complete: finishedParticipants.length == participants.length,
      end: end,
      images: images);

  Map<String, dynamic> toJson() => _$ChallengeToJson(this);
}
