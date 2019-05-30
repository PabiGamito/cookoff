import 'package:json_annotation/json_annotation.dart';

part 'challenge.g.dart';

@JsonSerializable(anyMap: true)
class Challenge {
  @JsonKey(includeIfNull: false, nullable: true)
  String id;
  final String owner;
  final List<String> participants;
  final String ingredient;
  final bool complete;
  final DateTime end;

  Challenge(
      {this.id,
      this.owner,
      this.participants,
      this.ingredient,
      this.complete,
      this.end});

  factory Challenge.fromJson(Map<String, dynamic> json) =>
      _$ChallengeFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeToJson(this);

  Challenge addParticipant(String name) {
    return Challenge(
        id: id,
        owner: owner,
        participants: participants..add(name),
        ingredient: ingredient,
        complete: complete,
        end: end);
  }
}
