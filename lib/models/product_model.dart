class Product {
  final int id;
  final String name;
  final String category;
  final String price;
  final String description;
  final int rating;
  final int reviewCount;
  final String image;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.image,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] as String,
      price: json['price'] as String,
      description: json['description'] as String,
      rating: json['rating'] as int,
      reviewCount: json['review_count'] as int,
      image: json['image'],
      stock: json['stock'] != null
          ? (json['stock'] is int
              ? json['stock']
              : int.tryParse(json['stock'].toString()) ?? 0)
          : 0,
    );
  }
}
