import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import '../models/earnings_model.dart';

class EarningsService extends GetConnect {
  final box = GetStorage();

  EarningsService() {
    httpClient.baseUrl = 'https://96057b35e6b9.ngrok-free.app/api/admin';
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

    print('Earnings response: ${response.statusCode}\n${response.body}');

    if (response.statusCode == 200) {
      try {
        return EarningsResponse.fromJson(response.body);
      } catch (e) {
        throw Exception('Format data earnings tidak sesuai.');
      }
    } else {
      if (response.body is String && response.body.toString().contains('<html')) {
        throw Exception('Endpoint earnings tidak ditemukan di server (404). Cek URL backend dan route Laravel.');
      }
      throw Exception('Gagal memuat earnings: ${response.body}');
    }
  }

  Future<MonthlySales> fetchCurrentMonthlySales() async {
    final savedToken = box.read('token');
    if (savedToken == null) throw Exception('Admin token not found');
    final token = 'Bearer $savedToken';

    final response = await get(
      '/sales/current',
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    print('Monthly Sales response: ${response.statusCode}\n${response.body}');

    if (response.statusCode == 200) {
      try {
        final data = response.body['data'];
        return MonthlySales.fromJson(data);
      } catch (e) {
        throw Exception('Format data monthly sales tidak sesuai.');
      }
    } else {
      throw Exception('Gagal memuat monthly sales: ${response.body}');
    }
  }
}