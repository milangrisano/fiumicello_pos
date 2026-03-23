import 'package:responsive_app/models/user.dart';

class AuthResponse {
  final User user;
  final String token;

  AuthResponse({
    required this.user,
    required this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      // Si el backend viene con 'user' anidado, lo usamos, si no usamos las propiedades raíz (por ej si sólo manda firstName, lastName, etc)
      user: User.fromJson(json['user'] ?? json),
      token: (json['token'] ?? json['access_token'] ?? '') as String,
    );
  }
}
