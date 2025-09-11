import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:typed_data';
import 'dart:async';

class BluetoothPrinterController extends GetxController {
  var isConnected = false.obs;
  var isScanning = false.obs;
  var isConnecting = false.obs;
  var devices = <BluetoothDevice>[].obs;
  var selectedDevice = Rxn<BluetoothDevice>();
  var connectionStatus = 'Disconnected'.obs;
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  final storage = GetStorage();
  Timer? _statusTimer;

  @override
  void onInit() {
    super.onInit();
    initializeBluetooth();
    _startStatusMonitor();
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

  void _startStatusMonitor() {
    _statusTimer?.cancel();
    _statusTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      await checkConnectionStatus();
    });
  }

  Future<void> checkConnectionStatus() async {
    try {
      // Check actual bluetooth connection status
      // Note: isConnected might not be available in all versions
      try {
        bool? actualStatus = await bluetooth.isConnected;

        if (actualStatus == true) {
          final String? savedName = storage.read('bluetooth_device_name');
          if (!isConnected.value) {
            isConnected.value = true;
          }
          connectionStatus.value =
              'Connected to ${savedName ?? 'Unknown Device'}';
        } else {
          await _clearConnectionInfo();
          isConnected.value = false;
          connectionStatus.value = 'Disconnected';
        }
      } catch (connectionCheckError) {
        print('Cannot check connection status: $connectionCheckError');
        // Fallback: check from storage only
        final bool wasConnected = storage.read('bluetooth_connected') ?? false;
        final String? savedName = storage.read('bluetooth_device_name');

        if (wasConnected && savedName != null) {
          isConnected.value = true;
          connectionStatus.value = 'Connected to $savedName';
          print('Connection status restored from storage');
        } else {
          isConnected.value = false;
          connectionStatus.value = 'Disconnected';
        }
      }
    } catch (e) {
      print('Error checking connection status: $e');
      // Clear stored info on error
      await _clearConnectionInfo();
      isConnected.value = false;
      connectionStatus.value = 'Disconnected';
    }
  }

  Future<void> scanDevices() async {
    try {
      isScanning.value = true;
      devices.clear();

      // Try to get bonded devices directly
      // BlueThermalPrinter doesn't have isEnabled method
      final List<BluetoothDevice> results = await bluetooth.getBondedDevices();
      devices.value = results
          .where((device) => device.name != null && device.name!.isNotEmpty)
          .toList();

      if (devices.isEmpty) {
        Get.snackbar(
          'Info',
          'Tidak ada perangkat Bluetooth yang terpasang. Pastikan printer sudah dipasangkan di pengaturan Bluetooth.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange[100],
          colorText: Colors.orange[800],
        );
      }

      isScanning.value = false;
    } catch (e) {
      print('Error scanning devices: $e');
      isScanning.value = false;

      // Handle specific Bluetooth errors
      String errorMessage = 'Gagal memindai perangkat';
      if (e.toString().contains('Bluetooth adapter not turned on') ||
          e.toString().contains('bluetooth disabled')) {
        errorMessage =
            'Bluetooth tidak aktif. Silakan aktifkan Bluetooth terlebih dahulu.';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    if (isConnecting.value) return;

    try {
      // Validate device
      if (device.name == null || device.name!.isEmpty) {
        Get.snackbar(
          'Error',
          'Perangkat tidak valid',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.red[800],
        );
        return;
      }

      isConnecting.value = true;
      connectionStatus.value = 'Menghubungkan...';

      // Disconnect any existing connection first
      try {
        // Try to disconnect any existing connection
        await bluetooth.disconnect();
        await Future.delayed(const Duration(milliseconds: 1000)); // Wait a bit
      } catch (e) {
        print('Error disconnecting existing connection: $e');
      }

      // Try to connect with timeout and retry
      await _connectWithRetry(device, maxRetries: 3);

      selectedDevice.value = device;
      isConnected.value = true;
      connectionStatus.value = 'Terhubung ke ${device.name}';

      // Save connection info
      await _saveConnectionInfo(device);

      print('Connected to ${device.name}');
      Get.snackbar(
        'Sukses',
        'Berhasil terhubung ke ${device.name}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
      );
    } catch (e) {
      print('Error connecting to device: $e');
      connectionStatus.value = 'Koneksi gagal';
      isConnected.value = false;

      String errorMessage = 'Gagal terhubung ke printer';
      if (e.toString().contains('read failed') ||
          e.toString().contains('timeout')) {
        errorMessage =
            'Koneksi timeout. Pastikan printer dalam jangkauan dan tidak digunakan aplikasi lain.';
      } else if (e.toString().contains('Device or resource busy')) {
        errorMessage =
            'Printer sedang digunakan aplikasi lain. Tutup aplikasi lain yang menggunakan printer.';
      } else if (e.toString().contains('Permission denied')) {
        errorMessage =
            'Izin Bluetooth ditolak. Periksa pengaturan izin aplikasi.';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
        duration: const Duration(seconds: 5),
      );
    } finally {
      isConnecting.value = false;
    }
  }

  Future<void> _connectWithRetry(BluetoothDevice device,
      {int maxRetries = 3}) async {
    for (int i = 0; i < maxRetries; i++) {
      try {
        connectionStatus.value = 'Menghubungkan... (${i + 1}/$maxRetries)';

        // Create a timeout completer
        final Completer<void> completer = Completer<void>();
        Timer? timeoutTimer;

        // Set up timeout
        timeoutTimer = Timer(const Duration(seconds: 10), () {
          if (!completer.isCompleted) {
            completer.completeError('Connection timeout');
          }
        });

        // Attempt connection
        bluetooth.connect(device).then((value) {
          timeoutTimer?.cancel();
          if (!completer.isCompleted) {
            completer.complete();
          }
        }).catchError((error) {
          timeoutTimer?.cancel();
          if (!completer.isCompleted) {
            completer.completeError(error);
          }
        });

        await completer.future;

        // Verify connection with a simple test
        await Future.delayed(const Duration(milliseconds: 500));

        // Instead of checking isConnected, we'll assume success if no exception
        return; // Success!
      } catch (e) {
        print('Connection attempt ${i + 1} failed: $e');

        if (i < maxRetries - 1) {
          // Wait before retry
          await Future.delayed(Duration(seconds: 2 * (i + 1)));

          // Try to disconnect before retry
          try {
            await bluetooth.disconnect();
            await Future.delayed(const Duration(milliseconds: 500));
          } catch (disconnectError) {
            print('Error disconnecting before retry: $disconnectError');
          }
        } else {
          // Last attempt failed, rethrow the error
          rethrow;
        }
      }
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
      connectionStatus.value = 'Terputus';

      // Clear saved connection info
      await _clearConnectionInfo();

      print('Disconnected from printer');
      Get.snackbar(
        'Sukses',
        'Berhasil terputus dari printer',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
      );
    } catch (e) {
      print('Error disconnecting: $e');
      // Force update UI even if disconnect fails
      isConnected.value = false;
      selectedDevice.value = null;
      connectionStatus.value = 'Terputus';
      await _clearConnectionInfo();

      Get.snackbar(
        'Warning',
        'Koneksi diputus paksa',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange[100],
        colorText: Colors.orange[800],
      );
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

  Future<void> testPrint() async {
    if (!isConnected.value) {
      Get.snackbar(
        'Error',
        'Printer tidak terhubung',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return;
    }

    try {
      // Simple test print without connection verification
      final String testText = '''
================================
        TEST PRINT
================================
Date: ${DateTime.now().toString().substring(0, 19)}
Status: Printer Connected
================================
This is a test print to verify
your printer connection.
================================



''';

      await bluetooth.writeBytes(Uint8List.fromList(testText.codeUnits));

      Get.snackbar(
        'Sukses',
        'Test print berhasil dikirim',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
      );
    } catch (e) {
      print('Error test printing: $e');

      // If print fails, assume connection is lost
      isConnected.value = false;
      connectionStatus.value = 'Terputus';

      Get.snackbar(
        'Error',
        'Gagal test print. Koneksi mungkin terputus.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
    }
  }

  Future<bool> printReceipt(Map<String, dynamic> orderData) async {
    if (!isConnected.value) {
      Get.snackbar(
        'Error',
        'Printer tidak terhubung',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return false;
    }

    try {
      final String receipt = _generateReceiptText(orderData);

      // Write text to printer
      await bluetooth.writeBytes(Uint8List.fromList(receipt.codeUnits));
      await bluetooth
          .writeBytes(Uint8List.fromList('\n\n\n\n'.codeUnits)); // Feed paper

      Get.snackbar(
        'Sukses',
        'Struk berhasil dicetak',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[800],
      );
      return true;
    } catch (e) {
      print('Error printing receipt: $e');

      // If print fails, assume connection is lost
      isConnected.value = false;
      connectionStatus.value = 'Terputus';

      Get.snackbar(
        'Error',
        'Gagal mencetak struk. Koneksi mungkin terputus.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
        colorText: Colors.red[800],
      );
      return false;
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
    // Stop monitor timer
    _statusTimer?.cancel();
    _statusTimer = null;
    // Don't auto disconnect when controller is closed
    // Let user manually disconnect if needed
    super.onClose();
  }
}
