class Product {
  final int id;
  final String name;
  final String category;
  final String price;
  final String description;
  final int rating;
  final int reviewCount;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.image,
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
      image: json['image'].toString().replaceAll('`', '').trim(),
    );
  }
}
