import 'package:get/get.dart';
import '../controller/order_controller.dart';
import '../controller/bluetooth_printer_controller.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderController>(() => OrderController());
    // Use put with permanent flag to make controller persistent
    Get.put<BluetoothPrinterController>(BluetoothPrinterController(),
        permanent: true);
  }
}
