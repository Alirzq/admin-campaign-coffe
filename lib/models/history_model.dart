class HistoryModel {
  final int id;
  final String customerName;
  final List<String> items;
  final double totalPrice;
  final String status;
  final String orderType;
  final String? createdAt;
  final String paymentMethod;
  final String? address;
  final String? notes;
  final List<HistoryItemModel> orderItems;

  HistoryModel({
    required this.id,
    required this.customerName,
    required this.items,
    required this.totalPrice,
    required this.status,
    required this.orderType,
    this.createdAt,
    required this.paymentMethod,
    this.address,
    this.notes,
    required this.orderItems,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id'] ?? 0,
      customerName: json['customer_name'] ?? '',
      items: (json['items'] as List?)
              ?.map((e) => e['product_name']?.toString() ?? '')
              .toList() ??
          [],
      totalPrice: (json['total_price'] is int)
          ? (json['total_price'] as int).toDouble()
          : (json['total_price'] is String)
              ? double.tryParse(json['total_price']) ?? 0.0
              : (json['total_price'] ?? 0.0),
      status: json['status'] ?? '',
      orderType: json['order_type'] ?? '',
      createdAt: json['created_at'],
      paymentMethod: json['payment_method'] ?? '',
      address: json['address'],
      notes: json['notes'],
      orderItems: (json['items'] as List?)
              ?.map((e) => HistoryItemModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class HistoryItemModel {
  final int id;
  final int productId;
  final String? productName;
  final String? productImage;
  final double price;
  final int quantity;
  final String? size;
  final String? sugar;
  final String? temperature;

  HistoryItemModel({
    required this.id,
    required this.productId,
    this.productName,
    this.productImage,
    required this.price,
    required this.quantity,
    this.size,
    this.sugar,
    this.temperature,
  });

  factory HistoryItemModel.fromJson(Map<String, dynamic> json) {
    return HistoryItemModel(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      productName: json['product_name'],
      productImage: json['product_image'],
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : (json['price'] is String)
              ? double.tryParse(json['price']) ?? 0.0
              : (json['price'] ?? 0.0),
      quantity: json['quantity'] ?? 0,
      size: json['size'],
      sugar: json['sugar'],
      temperature: json['temperature'],
    );
  }
}
