class TableModel {
  final int id;
  final String name;
  final bool isActive;
  final double x;
  final double y;

  TableModel({
    required this.id,
    required this.name,
    this.isActive = true,
    this.x = 0,
    this.y = 0,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['id'] is String ? int.tryParse(json['id']) ?? 0 : (json['id'] ?? 0),
      name: json['name'] ?? '',
      isActive: json['isActive'] ?? true,
      x: (json['x'] ?? 0).toDouble(),
      y: (json['y'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isActive': isActive,
      'x': x,
      'y': y,
    };
  }
}
