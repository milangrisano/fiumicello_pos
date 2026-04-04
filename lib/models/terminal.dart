class Terminal {
  final int id;
  final String name;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Terminal({
    required this.id,
    required this.name,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Terminal.fromJson(Map<String, dynamic> json) {
    return Terminal(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isActive': isActive,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}
