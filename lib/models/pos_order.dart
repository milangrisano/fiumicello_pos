import 'package:responsive_app/models/product.dart';

class PosCartItem {
  final Product product;
  final String? selectedSize;
  int quantity;

  PosCartItem({required this.product, this.selectedSize, this.quantity = 1});
}

class PosOrder {
  final String id;
  String name;
  List<PosCartItem> items;

  PosOrder({
    required this.id,
    required this.name,
    required this.items,
  });
}
