import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/history_model.dart';
import 'package:get_storage/get_storage.dart';

class HistoryService {
  static const String baseUrl = 'https://campaign.rplrus.com/api/admin';

  static Future<List<HistoryModel>> fetchOrderHistory() async {
    final box = GetStorage();
    final token = box.read('token');
    final response = await http.get(
      Uri.parse('$baseUrl/history'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      print('RESPONSE BODY: ${response.body}');
      final data = jsonDecode(response.body);
      print('DATA: $data');
      print('DATA[data]: ${data['data']}');
      return List<HistoryModel>.from(
        data['data'].map((item) => HistoryModel.fromJson(item)),
      );
    } else {
      print('ERROR STATUS: ${response.statusCode}');
      print('ERROR BODY: ${response.body}');
      throw Exception('Failed to load order history');
    }
  }
}
