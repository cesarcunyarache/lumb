import 'package:lumb/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    super.userId,
    required super.email,
    required super.displayName,
    required super.photoUrl,
  });

  factory UserModel.fromJson(String id, Map<String, dynamic> json) {
    return UserModel(
      userId: id,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      photoUrl: json['photoUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
    };
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      userId: user.userId,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoUrl,
    );
  }
}
