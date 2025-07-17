import 'package:admin_campaign_coffe_repo/models/product_model.dart';
import 'package:admin_campaign_coffe_repo/models/user_model.dart';

class Order {
  final int id;
  final String customerName;
  final double totalPrice;
  final String status;
  final String orderType;
  final String createdAt;
  final List<OrderItem> items;
  final String paymentMethod;
  final String location;

  Order({
    required this.id,
    required this.customerName,
    required this.totalPrice,
    required this.status,
    required this.orderType,
    required this.createdAt,
    required this.items,
    required this.paymentMethod,
    required this.location,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      customerName: json['customer_name'] ?? '',
      totalPrice: (json['total_price'] is int)
          ? (json['total_price'] as int).toDouble()
          : (json['total_price'] is String)
              ? double.tryParse(json['total_price']) ?? 0.0
              : (json['total_price'] ?? 0.0),
      status: json['status'] ?? '',
      orderType: json['order_type'] ?? '',
      createdAt: json['created_at'] ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromJson(e))
              .toList() ?? [],
      paymentMethod: json['payment_method'] ?? '-',
      location: json['location'] ?? '-',
    );
  }
}

class OrderItem {
  final int id;
  final int productId;
  final String productName;
  final String? productImage;
  final double price;
  final int quantity;

  OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    this.productImage,
    required this.price,
    required this.quantity,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      productId: json['product_id'],
      productName: json['product_name'] ?? '',
      productImage: json['product_image'],
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : (json['price'] is String)
              ? double.tryParse(json['price']) ?? 0.0
              : (json['price'] ?? 0.0),
      quantity: json['quantity'] ?? 0,
    );
  }
}