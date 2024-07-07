import 'package:coach_web/model/auth_model.dart';

class AuthResponse {
  final String accessToken;
  final User user;

  AuthResponse({required this.accessToken, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'] ?? '',
      user: json['user'] != null ? User.fromJson(json['user']) : User.empty(),
    );
  }
}
