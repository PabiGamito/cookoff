// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Challenge _$ChallengeFromJson(Map json) {
  return Challenge._internal(
      id: json['id'] as String,
      owner: json['owner'] as String,
      participants:
          (json['participants'] as List)?.map((e) => e as String)?.toSet(),
      ingredient: json['ingredient'] as String,
      complete: json['complete'] as bool,
      end: json['end'] == null ? null : DateTime.parse(json['end'] as String));
}

Map<String, dynamic> _$ChallengeToJson(Challenge instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['owner'] = instance.owner;
  val['participants'] = instance.participants?.toList();
  val['ingredient'] = instance.ingredient;
  val['complete'] = instance.complete;
  val['end'] = instance.end?.toIso8601String();
  return val;
}
