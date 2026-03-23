class Product {
  final String id;
  final String name;
  final String type;
  final String category;
  final String description;
  final double price;
  final bool availability;
  final bool isActive;

  Product({
    required this.id,
    required this.name,
    required this.type,
    required this.category,
    required this.description,
    required this.price,
    required this.availability,
    required this.isActive,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String? ?? '',
      category: json['category'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      availability: json['availability'] as bool? ?? true,
      isActive: json['isActive'] as bool? ?? true,
    );
  }
}
