class SaleDetailModel {
  final String productName;
  final int quantity;

  SaleDetailModel({
    required this.productName,
    required this.quantity,
  });

  factory SaleDetailModel.fromJson(Map<String, dynamic> json) {
    return SaleDetailModel(
      productName: json['product'] != null && json['product']['name'] != null 
          ? json['product']['name'].toString() 
          : 'Desconocido',
      quantity: json['quantity'] != null ? int.tryParse(json['quantity'].toString()) ?? 1 : 1,
    );
  }
}

class SaleModel {
  final String id;
  final double total;
  final String status;
  final String? paymentMethod;
  final DateTime createdAt;
  final String? dinerName;
  final String? tableName;
  final String orderType;
  final int? invoiceNumber;
  final List<SaleDetailModel> items;

  SaleModel({
    required this.id,
    required this.total,
    required this.status,
    this.paymentMethod,
    required this.createdAt,
    this.dinerName,
    this.tableName,
    this.orderType = 'DINE_IN',
    this.invoiceNumber,
    this.items = const [],
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    // Intentamos extraer el paymentMethod de manera segura si es un objeto anidado o un simple string
    String? parsedPaymentMethod;
    if (json['paymentMethod'] != null) {
      if (json['paymentMethod'] is Map) {
        parsedPaymentMethod = json['paymentMethod']['name']?.toString() ?? 'Desconocido';
      } else {
        parsedPaymentMethod = json['paymentMethod'].toString();
      }
    }

    // Manejo de dinerName
    String? parsedDinerName;
    if (json['dinerName'] != null) {
      parsedDinerName = json['dinerName'].toString();
    } else if (json['customer'] != null && json['customer'] is Map) {
      parsedDinerName = json['customer']['name']?.toString();
    }

    String? parsedTableName;
    if (json['table'] != null && json['table'] is Map) {
      parsedTableName = json['table']['name']?.toString();
    }

    List<SaleDetailModel> parsedItems = [];
    if (json['details'] != null && json['details'] is List) {
      parsedItems = (json['details'] as List)
          .map((detailJson) => SaleDetailModel.fromJson(detailJson))
          .toList();
    }

    return SaleModel(
      id: json['id']?.toString() ?? '',
      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,
      status: json['status']?.toString() ?? 'completed',
      paymentMethod: parsedPaymentMethod ?? 'Efectivo',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
      dinerName: parsedDinerName,
      tableName: parsedTableName,
      orderType: json['orderType']?.toString() ?? 'DINE_IN',
      invoiceNumber: json['invoiceNumber'] != null ? int.tryParse(json['invoiceNumber'].toString()) : null,
      items: parsedItems,
    );
  }
}
