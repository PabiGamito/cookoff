import 'package:json_annotation/json_annotation.dart';

part 'challenge.g.dart';

@JsonSerializable(anyMap: true)
class Challenge {
  @JsonKey(includeIfNull: false, nullable: true)
  final String id;
  final String owner;
  final Set<String> participants;
  final String ingredient;
  final bool complete;
  final DateTime end;

  Challenge._internal(
      {this.id,
      this.owner,
      this.participants,
      this.ingredient,
      this.complete,
      this.end});

  Challenge(this.ingredient)
      : id = null,
        owner = null,
        participants = {},
        complete = false,
        end = DateTime.now().add(Duration(days: 1));

  factory Challenge.fromJson(Map<String, dynamic> json) =>
      _$ChallengeFromJson(json);

  bool get started => id != null;

  bool hasParticipant(String participant) => participants.contains(participant);

  Challenge copyWithId(String id) => Challenge._internal(
      id: id,
      owner: owner,
      participants: participants,
      ingredient: ingredient,
      complete: complete,
      end: end);

  Challenge copyWithOwner(String owner) => Challenge._internal(
      id: id,
      owner: owner,
      participants: participants..add(owner),
      ingredient: ingredient,
      complete: complete,
      end: end);

  Challenge copyWithParticipant(String participant) => Challenge._internal(
      id: id,
      owner: owner,
      participants: participants..add(participant),
      ingredient: ingredient,
      complete: complete,
      end: end);

  Challenge copyWithoutParticipant(String participant) => Challenge._internal(
      id: id,
      owner: owner,
      participants: participants.where((p) => p != participant).toSet(),
      ingredient: ingredient,
      complete: complete,
      end: end);

  Challenge copyAsComplete() => Challenge._internal(
      id: id,
      owner: owner,
      participants: participants,
      ingredient: ingredient,
      complete: true,
      end: end);

  Map<String, dynamic> toJson() => _$ChallengeToJson(this);
}
