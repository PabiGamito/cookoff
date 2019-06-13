// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      deviceTokens:
          (json['deviceTokens'] as List)?.map((e) => e as String)?.toSet(),
      friends: (json['friends'] as List)?.map((e) => e as String)?.toSet(),
      profilePictureUrl: json['profilePictureUrl'] as String,
      dietName: json['dietName'] as String);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'deviceTokens': instance.deviceTokens?.toList(),
      'friends': instance.friends?.toList(),
      'profilePictureUrl': instance.profilePictureUrl,
      'dietName': instance.dietName
    };
