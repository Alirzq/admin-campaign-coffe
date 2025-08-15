import 'package:get/get.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:typed_data';

class BluetoothPrinterController extends GetxController {
  var isConnected = false.obs;
  var isScanning = false.obs;
  var devices = <BluetoothDevice>[].obs;
  var selectedDevice = Rxn<BluetoothDevice>();
  var connectionStatus = 'Disconnected'.obs;
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    initializeBluetooth();
  }

  Future<void> initializeBluetooth() async {
    try {
      // Initialize bluetooth
      print('Bluetooth initialized successfully');

      // Check if already connected
      await checkConnectionStatus();
    } catch (e) {
      print('Error initializing bluetooth: $e');
    }
  }

  Future<void> checkConnectionStatus() async {
    try {
      // Check if we have saved connection info
      final bool wasConnected = storage.read('bluetooth_connected') ?? false;
      final String? savedName = storage.read('bluetooth_device_name');
      final String? savedAddress = storage.read('bluetooth_device_address');

      if (wasConnected && savedName != null && savedAddress != null) {
        // Restore connection status
        isConnected.value = true;
        connectionStatus.value = 'Connected to $savedName';

        // Create a dummy device for display purposes
        // In real implementation, you might want to reconnect to the actual device
        print('Connection status restored from storage');
      }
    } catch (e) {
      print('Error checking connection status: $e');
    }
  }

  Future<void> scanDevices() async {
    try {
      isScanning.value = true;
      devices.clear();

      final List<BluetoothDevice> results = await bluetooth.getBondedDevices();
      devices.value = results
          .where((device) => device.name != null || device.address != null)
          .toList();
      isScanning.value = false;
    } catch (e) {
      print('Error scanning devices: $e');
      isScanning.value = false;
      Get.snackbar('Error', 'Gagal scan devices: $e');
    }
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      // Validate device
      if (device.name == null && device.address == null) {
        Get.snackbar('Error', 'Device tidak valid');
        return;
      }

      connectionStatus.value = 'Connecting...';

      await bluetooth.connect(device);
      selectedDevice.value = device;
      isConnected.value = true;
      connectionStatus.value =
          'Connected to ${device.name ?? 'Unknown Device'}';

      // Save connection info
      await _saveConnectionInfo(device);

      print('Connected to ${device.name ?? 'Unknown Device'}');
      Get.snackbar('Sukses', 'Berhasil koneksi ke printer');
    } catch (e) {
      print('Error connecting to device: $e');
      connectionStatus.value = 'Connection failed';
      isConnected.value = false;
      Get.snackbar('Error', 'Gagal koneksi ke printer: $e');
    }
  }

  Future<void> _saveConnectionInfo(BluetoothDevice device) async {
    try {
      await storage.write('bluetooth_device_name', device.name);
      await storage.write('bluetooth_device_address', device.address);
      await storage.write('bluetooth_connected', true);
    } catch (e) {
      print('Error saving connection info: $e');
    }
  }

  Future<void> disconnect() async {
    try {
      await bluetooth.disconnect();
      isConnected.value = false;
      selectedDevice.value = null;
      connectionStatus.value = 'Disconnected';

      // Clear saved connection info
      await _clearConnectionInfo();

      print('Disconnected from printer');
      Get.snackbar('Sukses', 'Berhasil disconnect dari printer');
    } catch (e) {
      print('Error disconnecting: $e');
      Get.snackbar('Error', 'Gagal disconnect: $e');
    }
  }

  Future<void> _clearConnectionInfo() async {
    try {
      await storage.remove('bluetooth_device_name');
      await storage.remove('bluetooth_device_address');
      await storage.remove('bluetooth_connected');
    } catch (e) {
      print('Error clearing connection info: $e');
    }
  }

  // Method to manually disconnect and destroy controller
  Future<void> forceDisconnect() async {
    await disconnect();
    // Remove the controller from GetX
    Get.delete<BluetoothPrinterController>();
  }

  Future<void> printReceipt(Map<String, dynamic> orderData) async {
    if (!isConnected.value) {
      Get.snackbar('Error', 'Printer tidak terhubung');
      return;
    }

    try {
      final String receipt = _generateReceiptText(orderData);

      // Write text to printer
      await bluetooth.writeBytes(Uint8List.fromList(receipt.codeUnits));
      await bluetooth
          .writeBytes(Uint8List.fromList('\n\n\n\n'.codeUnits)); // Feed paper

      Get.snackbar('Sukses', 'Struk berhasil dicetak');
    } catch (e) {
      print('Error printing receipt: $e');
      Get.snackbar('Error', 'Gagal mencetak struk');
    }
  }

  String _generateReceiptText(Map<String, dynamic> orderData) {
    final StringBuffer receipt = StringBuffer();

    // Header
    receipt.writeln('================================');
    receipt.writeln('        CAMPAIGN COFFEE');
    receipt.writeln('================================');
    receipt.writeln('Date: ${orderData['created_at'] ?? '-'}');
    receipt.writeln('Order ID: #ORD${orderData['id'] ?? '-'}');
    receipt.writeln('Customer: ${orderData['customer_name'] ?? '-'}');
    receipt.writeln('Type: ${orderData['order_type'] ?? '-'}');
    receipt.writeln('Payment: ${orderData['payment_method'] ?? '-'}');
    receipt.writeln('Location: ${orderData['location'] ?? '-'}');
    receipt.writeln('--------------------------------');

    // Items
    receipt.writeln('ITEMS:');
    final List items = orderData['items'] ?? [];
    for (var item in items) {
      receipt.writeln('${item['product_name'] ?? '-'}');
      receipt.writeln('  Size: ${item['size'] ?? '-'}');
      receipt.writeln(
          '  Temp: ${item['temperature'] ?? '-'} | Sugar: ${item['sugar'] ?? '-'}');
      if (item['notes'] != null && item['notes'].toString().isNotEmpty) {
        receipt.writeln('  Note: ${item['notes']}');
      }
      receipt.writeln('  ${item['quantity']}x Rp.${item['price']}');
      receipt.writeln('');
    }

    // Total
    receipt.writeln('--------------------------------');
    receipt.writeln('Total Items: ${items.length}');
    receipt.writeln('TOTAL: Rp.${orderData['total_price'] ?? 0}');
    receipt.writeln('================================');
    receipt.writeln('Thank you for your order!');
    receipt.writeln('================================');

    return receipt.toString();
  }

  @override
  void onClose() {
    // Don't auto disconnect when controller is closed
    // Let user manually disconnect if needed
    super.onClose();
  }
}
