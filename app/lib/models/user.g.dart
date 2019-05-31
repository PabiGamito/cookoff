// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(json['email'] as String, json['profilePictureUrl'] as String,
      json['name'] as String, json['userId'] as String);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'email': instance.email,
      'profilePictureUrl': instance.profilePictureUrl,
      'name': instance.name,
      'userId': instance.userId
    };
