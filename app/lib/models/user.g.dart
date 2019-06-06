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
      friends: (json['friends'] as List)?.map((e) => e as String)?.toList(),
      profilePictureUrl: json['profilePictureUrl'] as String);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'friends': instance.friends,
      'profilePictureUrl': instance.profilePictureUrl
    };
