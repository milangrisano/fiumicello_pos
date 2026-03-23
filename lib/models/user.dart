class User {
  final String id;
  final String email;
  final String name;
  final bool isActive;
  final bool isEmailVerified;
  final List<String> roles;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.isActive = true,
    this.isEmailVerified = false,
    this.roles = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Manejar casos donde el backend envía firstName y lastName
    final String firstName = json['firstName'] ?? '';
    final String lastName = json['lastName'] ?? '';
    final String composedName =
        [firstName, lastName].where((s) => s.isNotEmpty).join(' ');

    // Manejar el formato de un único role
    List<String> userRoles = [];
    if (json['role'] != null) {
      if (json['role'] is Map && json['role']['name'] != null) {
        userRoles.add(json['role']['name']);
      } else if (json['role'] is String) {
        userRoles.add(json['role']);
      }
    } else if (json['roles'] != null) {
      userRoles = List<String>.from(json['roles']);
    }

    return User(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: composedName.isNotEmpty ? composedName : (json['name'] ?? ''),
      isActive: json['isActive'] ?? true,
      isEmailVerified: json['isEmailVerified'] ?? false,
      roles: userRoles,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'isActive': isActive,
      'isEmailVerified': isEmailVerified,
      'roles': roles,
    };
  }
}
