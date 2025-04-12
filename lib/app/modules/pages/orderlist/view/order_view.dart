import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderView extends GetView {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Halaman Order',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
