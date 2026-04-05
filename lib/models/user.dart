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

  bool get isGuestUser {
    if (roles.isEmpty) return true;
    final r = roles.first.trim().toLowerCase();
    return roles.length == 1 && (r == 'guest' || r.contains('guest'));
  }

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
        userRoles.add(json['role']['name'].toString());
      } else if (json['role'] is String) {
        userRoles.add(json['role'].toString());
      }
    } else if (json['roles'] != null) {
      final rolesList = json['roles'] as List<dynamic>?;
      if (rolesList != null) {
        userRoles = rolesList.map((e) {
          if (e is Map && e['name'] != null) return e['name'].toString();
          return e.toString();
        }).toList();
      }
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
