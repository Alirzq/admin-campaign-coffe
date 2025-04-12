import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomWidgetView extends GetView {
  const CustomWidgetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Widget'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Halaman Custom Widget',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
