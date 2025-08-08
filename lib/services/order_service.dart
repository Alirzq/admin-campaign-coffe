import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/order_model.dart';
import 'package:get_storage/get_storage.dart';

class OrderService {
  static const String baseUrl = 'https://a7d765cc68b7.ngrok-free.app/api/admin';
  final box = GetStorage();

  Future<List<Order>> getOrders() async {
    final token = box.read('token');
    final response = await http.get(
      Uri.parse('$baseUrl/orders'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Order>.from(data['data'].map((json) => Order.fromJson(json)));
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<List<Order>> getOrdersByStatus(String status) async {
    final token = box.read('token');
    final response = await http.get(
      Uri.parse('$baseUrl/orders/status/$status'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Order>.from(data['data'].map((json) => Order.fromJson(json)));
    } else {
      throw Exception('Failed to load orders by status');
    }
  }

  Future<void> updateOrderStatus(int id, String status) async {
    const validStatuses = [
      'pending',
      'paid',
      'inprogress',
      'completed',
      'cancelled'
    ];
    if (!validStatuses.contains(status)) {
      throw Exception('Status tidak valid');
    }
    final token = box.read('token');
    final response = await http.put(
      Uri.parse('$baseUrl/orders/$id/status'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'status': status}),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update order status');
    }
  }

  Future<List<int>> generateInvoice(int id) async {
    final token = box.read('token');
    final response = await http.get(
      Uri.parse('$baseUrl/orders/$id/invoice'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to generate invoice');
    }
  }

  Future<List<Order>> getPickupOrdersByStatus(String status) async {
    final token = box.read('token');
    String endpoint = '';
    if (status == 'paid') {
      endpoint = 'pickup-orders/pending';
    } else if (status == 'inprogress') {
      endpoint = 'pickup-orders/in-progress';
    } else if (status == 'completed') {
      endpoint = 'pickup-orders/completed';
    } else {
      throw Exception('Status tidak dikenali');
    }
    final response = await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    print('DEBUG PICKUP $endpoint: ${response.body}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Order>.from(data['data'].map((json) => Order.fromJson(json)));
    } else {
      throw Exception('Failed to load pickup orders');
    }
  }
}
