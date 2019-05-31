import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String email;
  final String profilePictureUrl;
  final String name;
  final String userId;

  User(this.email, this.profilePictureUrl, this.name, this.userId);

  static User fromJson(Map<String, dynamic> json) {
    return _$UserFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$UserToJson(this);
  }
}
