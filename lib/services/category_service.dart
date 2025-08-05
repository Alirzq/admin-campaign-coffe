import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';
import 'package:get_storage/get_storage.dart';

class CategoryService {
  static const String baseUrl = 'https://90b763d4ac5f.ngrok-free.app/api/admin';
  final box = GetStorage();

  Future<List<Category>> getCategories() async {
    final token = box.read('token');
    final response = await http.get(
      Uri.parse('$baseUrl/categories'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Category>.from(
          data['data'].map((json) => Category.fromJson(json)));
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<Category> createCategory(Category category) async {
    final token = box.read('token');
    final response = await http.post(
      Uri.parse('$baseUrl/categories'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(category.toJson()),
    );
    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return Category.fromJson(data['data']);
    } else {
      throw Exception('Failed to create category');
    }
  }

  Future<Category> updateCategory(int id, Category category) async {
    final token = box.read('token');
    final response = await http.put(
      Uri.parse('$baseUrl/categories/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(category.toJson()),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Category.fromJson(data['data']);
    } else {
      throw Exception('Failed to update category');
    }
  }

  Future<void> deleteCategory(int id) async {
    final token = box.read('token');
    final response = await http.delete(
      Uri.parse('$baseUrl/categories/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete category');
    }
  }
}
