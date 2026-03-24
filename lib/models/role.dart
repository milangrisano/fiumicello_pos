class RoleDefinitionModel {
  final String id;
  final String name;
  final String description;
  bool isActive;

  RoleDefinitionModel({
    required this.id,
    required this.name,
    required this.description,
    required this.isActive,
  });

  factory RoleDefinitionModel.fromJson(Map<String, dynamic> json) {
    return RoleDefinitionModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isActive': isActive,
    };
  }
}
