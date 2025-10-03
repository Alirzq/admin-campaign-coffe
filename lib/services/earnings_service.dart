import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import '../models/earnings_model.dart';
import '../utils/error_utils.dart';

class EarningsService extends GetConnect {
  final box = GetStorage();

  EarningsService() {
    httpClient.baseUrl = 'https://campaign.rplrus.com/api/admin';
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

    if (response.statusCode == 200) {
      try {
        return EarningsResponse.fromJson(response.body);
      } catch (e) {
        throw Exception('Format data earnings tidak sesuai.');
      }
    }
    final message = ErrorUtils.friendlyMessage(
        'Gagal memuat earnings (${response.statusCode})');
    throw Exception(message);
  }

  Future<List<MonthlyEarnings>> fetchEarningsByMonth() async {
    final savedToken = box.read('token');
    if (savedToken == null) throw Exception('Admin token not found');
    final token = 'Bearer $savedToken';
    print('Token dipakai: $token');

    final response = await get(
      '/earningsByMonth',
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      try {
        final data = response.body['data'] ?? [];
        return data
            .map<MonthlyEarnings>((json) => MonthlyEarnings.fromJson(json))
            .toList();
      } catch (e) {
        throw Exception('Format data earnings by month tidak sesuai.');
      }
    }
    final message = ErrorUtils.friendlyMessage(
        'Gagal memuat earnings by month (${response.statusCode})');
    throw Exception(message);
  }
}

// Tambahkan model untuk earningsByMonth
class MonthlyEarnings {
  final String month;
  final double total;

  MonthlyEarnings({
    required this.month,
    required this.total,
  });

  factory MonthlyEarnings.fromJson(Map<String, dynamic> json) {
    return MonthlyEarnings(
      month: json['month'] ?? '',
      total: (json['total'] is int)
          ? (json['total'] as int).toDouble()
          : (json['total'] is String)
              ? double.tryParse(json['total']) ?? 0.0
              : (json['total'] ?? 0.0),
    );
  }
}
