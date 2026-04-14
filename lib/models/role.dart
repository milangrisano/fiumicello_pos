class RoleDefinitionModel {
  final String id;
  final String name;
  final String description;
  bool isActive;
  List<String> permissions;
  String? defaultRoute;

  RoleDefinitionModel({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
    required this.permissions,
    this.defaultRoute,
  });

  factory RoleDefinitionModel.fromJson(Map<String, dynamic> json) {
    return RoleDefinitionModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      isActive: json['isActive'] ?? true,
      permissions: json['permissions'] != null 
          ? List<String>.from(json['permissions']) 
          : [],
      defaultRoute: json['defaultRoute'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isActive': isActive,
      'permissions': permissions,
      'defaultRoute': defaultRoute,
    };
  }
}
