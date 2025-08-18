import 'package:get/get.dart';
import 'package:admin_campaign_coffe_repo/controller/bluetooth_printer_controller.dart';

class BluetoothPrinterBinding extends Bindings {
  @override
  void dependencies() {
    // Use put instead of lazyPut to make controller persistent
    Get.put<BluetoothPrinterController>(BluetoothPrinterController(),
        permanent: true);
  }
}
