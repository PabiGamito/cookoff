import 'package:json_annotation/json_annotation.dart';

import 'participant.dart';

part 'challenge.g.dart';

@JsonSerializable(anyMap: true)
class Challenge {
  final String id;
  final String owner;
  final List<Participant> participants;
  final String ingredient;
  final bool complete;
  final DateTime end;

  Challenge(this.id, this.owner, this.participants, this.ingredient,
      this.complete, this.end);

  factory Challenge.fromJson(Map<String, dynamic> json) =>
      _$ChallengeFromJson(json);

  Map<String, dynamic> toJson() => _$ChallengeToJson(this);

  Challenge addParticipant(String name) {
    return Challenge(id, owner, participants..add(Participant(name)),
        ingredient, complete, end);
  }
}
