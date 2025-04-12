import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StockView extends GetView {
  const StockView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Halaman Stock',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
