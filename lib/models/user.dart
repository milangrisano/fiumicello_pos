class User {
  final String id;
  final String email;
  final String name;
  final bool isActive;
  final bool isEmailVerified;
  final List<String> roles;
  final List<String> permissions;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.isActive = true,
    this.isEmailVerified = false,
    this.roles = const [],
    this.permissions = const [],
  });

  bool get isGuestUser {
    if (roles.isEmpty) return true;
    final r = roles.first.trim().toLowerCase();
    return roles.length == 1 && (r == 'guest' || r.contains('guest'));
  }

  bool hasPermission(String key) {
    if (permissions.contains('all')) return true;
    return permissions.contains(key);
  }

  factory User.fromJson(Map<String, dynamic> json) {
    // Manejar casos donde el backend envía firstName y lastName
    final String firstName = json['firstName'] ?? '';
    final String lastName = json['lastName'] ?? '';
    final String composedName =
        [firstName, lastName].where((s) => s.isNotEmpty).join(' ');

    // Manejar el formato de un único role
    List<String> userRoles = [];
    List<String> userPermissions = [];
    
    if (json['role'] != null) {
      if (json['role'] is Map) {
        if (json['role']['name'] != null) {
          userRoles.add(json['role']['name'].toString());
        }
        if (json['role']['permissions'] != null) {
          if (json['role']['permissions'] is List) {
            userPermissions = List<String>.from(json['role']['permissions']);
          } else if (json['role']['permissions'] is String) {
            // Case for simple-array if it somehow comes as a raw string
            userPermissions = (json['role']['permissions'] as String)
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();
          }
        }
      } else if (json['role'] is String) {
        userRoles.add(json['role'].toString());
      }
    } else if (json['roles'] != null) {
      final rolesList = json['roles'] as List<dynamic>?;
      if (rolesList != null) {
        userRoles = rolesList.map((e) {
          if (e is Map && e['name'] != null) {
            // If permissions are inside one of the roles, we collect them too
            if (e['permissions'] != null) {
              if (e['permissions'] is List) {
                userPermissions.addAll(List<String>.from(e['permissions']));
              } else if (e['permissions'] is String) {
                userPermissions.addAll(e['permissions']
                    .toString()
                    .split(',')
                    .map((p) => p.trim())
                    .where((p) => p.isNotEmpty));
              }
            }
            return e['name'].toString();
          }
          return e.toString();
        }).toList();
      }
    }

    // Ensure uniqueness in permissions
    userPermissions = userPermissions.toSet().toList();


    return User(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      name: composedName.isNotEmpty ? composedName : (json['name'] ?? ''),
      isActive: json['isActive'] ?? true,
      isEmailVerified: json['isEmailVerified'] ?? false,
      roles: userRoles,
      permissions: userPermissions,
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
      'permissions': permissions,
    };
  }
}
