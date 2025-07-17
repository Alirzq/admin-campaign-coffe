class HistoryModel {
  final String customerName;
  final List<String> items;
  final double totalPrice;

  HistoryModel({
    required this.customerName,
    required this.items,
    required this.totalPrice,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      customerName: json['customer_name'] ?? '',
      items: (json['items'] as List?)?.map((e) => e['product_name']?.toString() ?? '').toList() ?? [],
      totalPrice: (json['total_price'] is int)
          ? (json['total_price'] as int).toDouble()
          : (json['total_price'] is String)
              ? double.tryParse(json['total_price']) ?? 0.0
              : (json['total_price'] ?? 0.0),
    );
  }
}
