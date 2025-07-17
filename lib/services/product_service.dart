import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import 'package:get_storage/get_storage.dart'; // pastikan sudah import

class ProductService {
  static const String baseUrl = 'https://f1b98737fb3b.ngrok-free.app/api';

  Future<List<Product>> getProducts({String? search}) async {
  try {
  final box = GetStorage();
    final token = box.read('token');
final headers = {
  'Authorization': 'Bearer $token',
  'Accept': 'application/json',
  'X-Requested-With': 'XMLHttpRequest',
};
String url = '$baseUrl/admin/products';
if (search != null && search.isNotEmpty) {
  url += '?search=${Uri.encodeComponent(search)}';
}
    final response = await http.get(
  Uri.parse(url),
  headers: headers,
);

    print('RESPONSE STATUS: ${response.statusCode}');
    print('RESPONSE BODY: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> productsJson = data['data'];
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  } catch (e) {
    throw Exception('Error: $e');
  }
}

  Future<bool> updateProductStock(int productId, int newStock) async {
  final box = GetStorage();
  final token = box.read('token');
  print('TOKEN YANG DIKIRIM: $token');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
  };
  print('HEADER YANG DIKIRIM: $headers');
  final response = await http.put(
    Uri.parse('$baseUrl/admin/products/$productId'),
    headers: headers,
    body: jsonEncode({'stock': newStock}),
  );
  print('UPDATE STOK RESPONSE STATUS: ${response.statusCode}');
  print('UPDATE STOK RESPONSE BODY: ${response.body}');
  if (response.statusCode == 200 || response.statusCode == 201) {
    try {
      final data = jsonDecode(response.body);
      if (data is Map && data['success'] == true) {
        return true;
      } else {
        print('UPDATE STOK: Response tidak mengandung success: true');
        return false;
      }
    } catch (e) {
      print('UPDATE STOK: Error parsing response: $e');
      return false;
    }
  } else {
    print('UPDATE STOK: Status code bukan 200/201');
    return false;
  }
}

  Future<void> addProduct({
    required String title,
    required String description,
    required String price,
    required String stock,
    required int categoryId,
    double rating = 0,
    int reviewCount = 0,
  }) async {
    final box = GetStorage();
    final token = box.read('token');
    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'X-Requested-With': 'XMLHttpRequest',
    };
    final response = await http.post(
      Uri.parse('$baseUrl/admin/products'),
      headers: headers,
      body: jsonEncode({
        'name': title,
        'description': description,
        'price': price,
        'stock': stock,
        'category_id': categoryId,
        'rating': rating,
        'review_count': reviewCount,
      }),
    );
    final data = jsonDecode(response.body);
    if (response.statusCode == 201 || data['success'] == true) {
      // Success
      return;
    } else {
      throw Exception(data['message'] ?? 'Gagal menambahkan menu');
    }
  }

  Future<Product> getProductById(int id) async {
  final box = GetStorage();
  final token = box.read('token');
  final headers = {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
  };
  final response = await http.get(
    Uri.parse('$baseUrl/admin/products/$id'),
    headers: headers,
  );
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return Product.fromJson(data['data']);
  } else {
    throw Exception('Failed to load product');
  }
}

Future<void> updateProduct({
  required int id,
  required String title,
  required String description,
  required String price,
  required String stock,
  required int categoryId,
  double rating = 0,
  int reviewCount = 0,
}) async {
  final box = GetStorage();
  final token = box.read('token');
  final headers = {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
  };
  final response = await http.put(
    Uri.parse('$baseUrl/admin/products/$id'),
    headers: headers,
    body: jsonEncode({
      'name': title,
      'description': description,
      'price': price,
      'stock': stock,
      'category_id': categoryId,
      'rating': rating,
      'review_count': reviewCount,
    }),
  );
  final data = jsonDecode(response.body);
  if (response.statusCode == 200 || data['success'] == true) {
    return;
  } else {
    throw Exception(data['message'] ?? 'Gagal update produk');
  }
}

Future<void> deleteProduct(int id) async {
  final box = GetStorage();
  final token = box.read('token');
  final headers = {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
    'X-Requested-With': 'XMLHttpRequest',
  };
  final response = await http.delete(
    Uri.parse('$baseUrl/admin/products/$id'),
    headers: headers,
  );
  if (response.statusCode == 200) {
    return;
  } else {
    throw Exception('Gagal menghapus produk');
  }
}
}
