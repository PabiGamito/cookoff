import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String email;
  final String profilePictureUrl;
  final String name;
  final String userId;
  final String firstName;
  final List<User> friendsList;

  User(this.email, this.profilePictureUrl, String name, this.userId,
      {friendsList = const <User>[]})
      : this.name = name,
        this.firstName = name.split(' ')[0],
        this.friendsList = friendsList;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  User copyWithFriendsList(List<User> friendsList) =>
      User(email, profilePictureUrl, name, userId, friendsList: friendsList);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

class NullUser extends User {
  // Don't set data to null, as widgets have null/empty string assertions
  NullUser()
      : super(
            'anonymous@cookoff.me',
            'https://firebasestorage.googleapis.com/v0/b/pomegranate-catfish.ap'
                'pspot.com/o/240_F_64672736_U5kpdGs9keUll8CRQ3p3YaEv2M6qkVY5.jpg'
                '?alt=media&token=3c1cb58c-f054-4fc1-a684-734b4ee0e3d3',
            'Anonymous',
            '0');

  factory NullUser.fromJson(Map<String, dynamic> json) =>
      throw UnimplementedError();

  Map<String, dynamic> toJson() => throw UnimplementedError();
}
