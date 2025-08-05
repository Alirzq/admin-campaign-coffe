import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class OrderService {
  final box = GetStorage();

  Future<http.Response> getOrders() async {
    final token = box.read('token');
    return await http.get(
      Uri.parse('https://90b763d4ac5f.ngrok-free.app/api/login'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }
}
