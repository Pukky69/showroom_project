class User {
  String id;
  String username;
  String password;
  bool isAdmin;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.isAdmin,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      isAdmin: json['isAdmin'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'isAdmin': isAdmin,
    };
  }
}
