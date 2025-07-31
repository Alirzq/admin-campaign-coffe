import 'package:admin_campaign_coffe_repo/models/product_model.dart';
import 'package:admin_campaign_coffe_repo/models/user_model.dart';
import 'package:intl/intl.dart';

class Order {
  final int id;
  final String customerName;
  final double totalPrice;
  final String status;
  final String orderType;
  final DateTime create_at;
  final List<OrderItem> items;
  final String paymentMethod;
  final String location;
  final String? address;
  final String? notes;
  final User? user;

  Order({
    required this.id,
    required this.customerName,
    required this.totalPrice,
    required this.status,
    required this.orderType,
    required this.create_at,
    required this.items,
    required this.paymentMethod,
    required this.location,
    this.address,
    this.notes,
    this.user,
  });

  // Metode untuk memformat tanggal dan waktu untuk invoice
  String getFormattedDateTime() {
    return DateFormat('d MMM y HH:mm A').format(create_at);
  }

  // Metode untuk memformat tanggal dalam format dd-MM-yyyy HH:mm
  String getFormattedDate() {
    return DateFormat('dd-MM-yyyy HH:mm').format(create_at);
  }

  // Method untuk mendapatkan raw created_at dalam format string original
  String getRawCreatedAt() {
    return DateFormat('yyyy-MM-dd HH:mm').format(create_at);
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    // Parsing created_at dari string ke DateTime
    DateTime parsedCreatedAt;
    try {
      if (json['created_at'] is String) {
        String dateStr = json['created_at'];

        // Handle format "2025-07-18 01:13" dari JSON
        if (dateStr.contains(' ') && !dateStr.contains('T')) {
          // Format: "2025-07-18 01:13"
          parsedCreatedAt = DateFormat('yyyy-MM-dd HH:mm').parse(dateStr);
        }
        // Handle format ISO 8601
        else if (dateStr.contains('T')) {
          parsedCreatedAt = DateTime.parse(dateStr);
        }
        // Handle format date only
        else if (dateStr.contains('-')) {
          parsedCreatedAt = DateTime.parse(dateStr + ' 00:00:00');
        }
        // Try direct parsing
        else {
          parsedCreatedAt = DateTime.parse(dateStr);
        }
      } else {
        // Fallback ke waktu saat ini jika format tidak valid
        parsedCreatedAt = DateTime.now();
      }
    } catch (e) {
      print('Error parsing created_at: ${json['created_at']}, error: $e');
      // Fallback ke waktu saat ini jika terjadi error
      parsedCreatedAt = DateTime.now();
    }

    // Parse user jika ada
    User? user;
    if (json['user'] != null) {
      user = User.fromJson(json['user']);
    }

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
      create_at: parsedCreatedAt,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItem.fromJson(e))
              .toList() ??
          [],
      paymentMethod: json['payment_method'] ?? '-',
      location: json['location'] ?? '-',
      address: json['address'],
      notes: json['notes'],
      user: user,
    );
  }

  // Method untuk convert kembali ke Map (untuk debugging atau export)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_name': customerName,
      'total_price': totalPrice,
      'status': status,
      'order_type': orderType,
      'created_at': getRawCreatedAt(),
      'payment_method': paymentMethod,
      'location': location,
      'address': address,
      'notes': notes,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class OrderItem {
  final int id;
  final int productId;
  final String productName;
  final String? productImage;
  final double price;
  final int quantity;
  final String? size;
  final String? sugar;
  final String? temperature;

  OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    this.productImage,
    required this.price,
    required this.quantity,
    this.size,
    this.sugar,
    this.temperature,
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
      size: json['size'],
      sugar: json['sugar'],
      temperature: json['temperature'],
    );
  }

  // Method untuk convert kembali ke Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'product_image': productImage,
      'price': price,
      'quantity': quantity,
      'size': size,
      'sugar': sugar,
      'temperature': temperature,
    };
  }
}
