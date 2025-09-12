import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import '../models/promotion_model.dart';
import 'dart:io';

class PromotionService {
  final String baseUrl =
      'https://campaign.rplrus.com/api/admin/promotions';
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

  Future<String> uploadImage(File imageFile) async {
    try {
      // Buat request multipart untuk mengunggah gambar
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://campaign.rplrus.com/api/admin/upload-image'),
      );

      // Tambahkan header authorization yang lengkap
      request.headers.addAll({
        ...headers,
        'ngrok-skip-browser-warning':
            'any-value', // Tambahkan header ngrok jika diperlukan
      });

      // Tambahkan field 'type' sebagai 'promotion'
      request.fields['type'] = 'promotion';

      // Tambahkan file gambar
      var multipartFile =
          await http.MultipartFile.fromPath('image', imageFile.path);
      request.files.add(multipartFile);

      // Kirim request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          // Return nama file saja, path akan ditambahkan di backend
          return data['data']['filename'];
        } else {
          throw Exception(data['message'] ?? 'Gagal upload gambar');
        }
      } else {
        throw Exception(
            'Gagal upload gambar: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error: $e');
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
