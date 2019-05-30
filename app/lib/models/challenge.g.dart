// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Challenge _$ChallengeFromJson(Map<String, dynamic> json) {
  return Challenge(
      json['id'] as String,
      json['owner'] as String,
      (json['participants'] as List)
          ?.map((e) => e == null
              ? null
              : Participant.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['ingredient'] as String,
      json['complete'] as bool,
      json['end'] == null ? null : DateTime.parse(json['end'] as String));
}

Map<String, dynamic> _$ChallengeToJson(Challenge instance) => <String, dynamic>{
      'id': instance.id,
      'owner': instance.owner,
      'participants': instance.participants,
      'ingredient': instance.ingredient,
      'complete': instance.complete,
      'end': instance.end?.toIso8601String()
    };
