import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final List<String> friends;
  final Set<String> deviceTokens;
  final String profilePictureUrl;
  final String dietName;

  User(
      {this.id,
      this.name,
      this.email,
      this.friends = const [],
      this.deviceTokens,
      this.profilePictureUrl,
      this.dietName});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  String get firstName => name.split(' ')[0];

  User copyWithFriend(String friend) => User(
      id: id,
      name: name,
      email: email,
      friends: [...friends, friend],
      profilePictureUrl: profilePictureUrl,
      dietName: dietName);

  User copyWithDiet(String dietName) => User(
      id: id,
      name: name,
      email: email,
      friends: friends,
      deviceTokens: deviceTokens,
      profilePictureUrl: profilePictureUrl,
      dietName: dietName);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

class NullUser extends User {
  // Don't set data to null, as widgets have null/empty string assertions
  NullUser()
      : super(
            name: 'Anonymous',
            email: 'anonymous@cookoff.me',
            profilePictureUrl:
                'https://firebasestorage.googleapis.com/v0/b/pomegranate-catfish.ap'
                'pspot.com/o/240_F_64672736_U5kpdGs9keUll8CRQ3p3YaEv2M6qkVY5.jpg'
                '?alt=media&token=3c1cb58c-f054-4fc1-a684-734b4ee0e3d3');

  factory NullUser.fromJson(Map<String, dynamic> json) =>
      throw UnimplementedError();

  Map<String, dynamic> toJson() => throw UnimplementedError();
}
