import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import '../models/earnings_model.dart';

class EarningsService extends GetConnect {
  final box = GetStorage();

  EarningsService() {
    httpClient.baseUrl ='https://60b17e4d490e.ngrok-free.app/api/admin';
  }

  Future<EarningsResponse> fetchEarnings({String? month}) async {
    final savedToken = box.read('token');
    if (savedToken == null) throw Exception('Admin token not found');
    final token = 'Bearer $savedToken';
    print('Token dipakai: $token');

    final response = await get(
      '/earnings${month != null ? '?month=$month' : ''}',
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    print('Earnings response: \\${response.statusCode}\\n${response.body}');

    if (response.statusCode == 200) {
      try {
        return EarningsResponse.fromJson(response.body);
      } catch (e) {
        throw Exception('Format data earnings tidak sesuai.');
      }
    } else {
      // Jika response HTML atau bukan JSON
      if (response.body is String && response.body.toString().contains('<html')) {
        throw Exception('Endpoint earnings tidak ditemukan di server (404). Cek URL backend dan route Laravel.');
      }
      throw Exception('Gagal memuat earnings: ${response.body}');
    }
  }
}