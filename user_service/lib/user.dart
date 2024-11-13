class User {
  final String userId;
  final String username;
  final String password;

  User({
    required this.userId,
    required this.username,
    required this.password,
  });

  Map<String, Object?> toJson() {
    return {
      'userId': userId,
      'username': username,
      'password': password,
    };
  }
}

final Map<String, User> usersById = <String, User>{};
