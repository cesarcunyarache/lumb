class User {
  final String? userId;
  final String email;
  final String displayName;
  final String photoUrl;

  User({
    this.userId,
    required this.email,
    required this.displayName,
    required this.photoUrl,
  });
}