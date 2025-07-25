import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../models/promotion_model.dart';

class PromotionService {
  final String baseUrl ='https://a5bdb374b8e2.ngrok-free.app/api/admin/promotions';
  final box = GetStorage();

  String? get token => box.read('token');

  Map<String, String> get headers => {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

  Future<List<Promotion>> fetchPromotions() async {
    final response = await http.get(Uri.parse(baseUrl), headers: headers);
    final data = jsonDecode(response.body);
    if (data['success']) {
      return (data['data'] as List).map((e) => Promotion.fromJson(e)).toList();
    } else {
      throw Exception(data['message']);
    }
  }

  Future<Promotion> addPromotion(String title, {String? image}) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode({'title': title, 'image': image}),
    );
    final data = jsonDecode(response.body);
    if (data['success']) {
      return Promotion.fromJson(data['data']);
    } else {
      throw Exception(data['message']);
    }
  }

  Future<void> deletePromotion(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: headers,
    );
    final data = jsonDecode(response.body);
    if (!data['success']) {
      throw Exception(data['message']);
    }
  }
}
