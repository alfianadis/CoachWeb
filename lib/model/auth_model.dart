class User {
  final String username;
  final String password;
  final String fullName;
  final String role;

  User({
    required this.username,
    required this.password,
    required this.fullName,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'fullName': fullName,
        'role': role,
      };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      fullName: json['fullName'] ?? '',
      role: json['role'] ?? '',
    );
  }

  factory User.empty() {
    return User(
      username: '',
      password: '',
      fullName: '',
      role: '',
    );
  }
}
