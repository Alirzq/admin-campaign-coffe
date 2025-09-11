class Earnings {
  final int id;
  final String customerName;
  final double totalPrice;
  final String status;
  final String orderType;
  final String createdAt;
  final List<EarningsItem> items;

  Earnings({
    required this.id,
    required this.customerName,
    required this.totalPrice,
    required this.status,
    required this.orderType,
    required this.createdAt,
    required this.items,
  });

  factory Earnings.fromJson(Map<String, dynamic> json) {
    return Earnings(
      id: json['id'] ?? 0,
      customerName: json['customer_name'] ?? '',
      totalPrice: (json['total_price'] is int)
          ? (json['total_price'] as int).toDouble()
          : (json['total_price'] is String)
              ? double.tryParse(json['total_price']) ?? 0.0
              : (json['total_price'] ?? 0.0),
      status: json['status'] ?? '',
      orderType: json['order_type'] ?? '',
      createdAt: json['created_at'] ?? '',
      items: (json['items'] as List<dynamic>?)?.map((e) => EarningsItem.fromJson(e)).toList() ?? [],
    );
  }
}

class EarningsItem {
  final int id;
  final int productId;
  final String productName;
  final String? productImage;
  final double price;
  final int quantity;

  EarningsItem({
    required this.id,
    required this.productId,
    required this.productName,
    this.productImage,
    required this.price,
    required this.quantity,
  });

  factory EarningsItem.fromJson(Map<String, dynamic> json) {
    return EarningsItem(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
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

class EarningsResponse {
  final double total;
  final List<Earnings> orders;

  EarningsResponse({
    required this.total,
    required this.orders,
  });

  factory EarningsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    var orders = (data['orders'] as List? ?? [])
        .map((item) => Earnings.fromJson(item))
        .toList();

    return EarningsResponse(
      total: (data['total'] is int)
          ? (data['total'] as int).toDouble()
          : (data['total'] is String)
              ? double.tryParse(data['total']) ?? 0.0
              : (data['total'] ?? 0.0),
      orders: orders,
    );
  }
}

class MonthlySales {
  final String monthYear;
  final double totalSales;

  MonthlySales({
    required this.monthYear,
    required this.totalSales,
  });

  factory MonthlySales.fromJson(Map<String, dynamic> json) {
    return MonthlySales(
      monthYear: json['month_year'] ?? '',
      totalSales: (json['total_sales'] is int)
          ? (json['total_sales'] as int).toDouble()
          : (json['total_sales'] is String)
              ? double.tryParse(json['total_sales']) ?? 0.0
              : (json['total_sales'] ?? 0.0),
    );
  }
}