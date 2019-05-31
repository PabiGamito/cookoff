import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String email;
  final String profilePictureUrl;
  final String name;
  final String userId;

  User(this.email, this.profilePictureUrl, this.name, this.userId);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}

class NullUser extends User {
  NullUser() : super(null, null, null, null);

  factory NullUser.fromJson(Map<String, dynamic> json) =>
      throw UnimplementedError();

  Map<String, dynamic> toJson() => throw UnimplementedError();
}
