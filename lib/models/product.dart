class Product {
  final String id;
  final String name;
  final String type;
  final String categoryId;
  final String category; // Para el categoryName
  final String restaurantId;
  final String restaurantName;
  final String description;
  final double price;
  final bool availability;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.type,
    required this.categoryId,
    required this.category,
    required this.restaurantId,
    required this.restaurantName,
    required this.description,
    required this.price,
    required this.availability,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    String categoryName = '';
    String categoryId = '';
    
    if (json['category'] is Map) {
      categoryName = json['category']['name'] ?? '';
      categoryId = json['category']['id'] ?? '';
    } else {
      categoryName = json['category'] as String? ?? '';
    }

    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String? ?? '',
      categoryId: categoryId,
      category: categoryName,
      restaurantId: json['restaurant'] != null ? (json['restaurant']['id'] ?? '') : '',
      restaurantName: json['restaurant'] != null ? (json['restaurant']['name'] ?? '') : '',
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      availability: json['availability'] as bool? ?? true,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'categoryId': categoryId,
      'category': category,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'description': description,
      'price': price,
      'availability': availability,
      'isActive': isActive,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}
