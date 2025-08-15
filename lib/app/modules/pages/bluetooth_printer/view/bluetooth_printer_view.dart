import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:admin_campaign_coffe_repo/controller/bluetooth_printer_controller.dart';
import 'package:admin_campaign_coffe_repo/app/global-component/widget/custom_navbar.dart';

class BluetoothPrinterView extends GetView<BluetoothPrinterController> {
  const BluetoothPrinterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Bluetooth Printer",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Connection
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: controller.isConnected.value
                    ? Colors.green[50]
                    : Colors.red[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      controller.isConnected.value ? Colors.green : Colors.red,
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        controller.isConnected.value
                            ? Icons.bluetooth_connected
                            : Icons.bluetooth_disabled,
                        color: controller.isConnected.value
                            ? Colors.green
                            : Colors.red,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Status Koneksi',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Obx(() => Text(
                        controller.connectionStatus.value,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: controller.isConnected.value
                              ? Colors.green[700]
                              : Colors.red[700],
                        ),
                      )),
                  if (controller.selectedDevice.value != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Device: ${controller.selectedDevice.value!.name ?? 'Unknown Device'}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                  if (controller.isConnected.value) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Koneksi akan tetap terjaga saat keluar dari halaman ini',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.green[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Scan Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed:
                    controller.isScanning.value ? null : controller.scanDevices,
                icon: Obx(() => controller.isScanning.value
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.search)),
                label: Obx(() => Text(
                      controller.isScanning.value
                          ? 'Scanning...'
                          : 'Scan Devices',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    )),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D47A1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Devices List
            Text(
              'Available Devices',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: Obx(() {
                if (controller.devices.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bluetooth_searching,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No devices found',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap "Scan Devices" to find bluetooth printers',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.devices.length,
                  itemBuilder: (context, index) {
                    final device = controller.devices[index];
                    final isSelected =
                        controller.selectedDevice.value?.address ==
                                device.address &&
                            device.address != null;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue[50] : Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.print,
                          color: isSelected ? Colors.blue : Colors.grey[600],
                        ),
                        title: Text(
                          device.name ?? 'Unknown Device',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.blue[700] : Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          device.address ?? 'No address available',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle, color: Colors.blue)
                            : TextButton(
                                onPressed: () =>
                                    controller.connectToDevice(device),
                                child: Text(
                                  'Connect',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFF0D47A1),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                        onTap: () => controller.connectToDevice(device),
                      ),
                    );
                  },
                );
              }),
            ),

            // Disconnect Button
            if (controller.isConnected.value) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: controller.disconnect,
                  icon: const Icon(Icons.bluetooth_disabled),
                  label: Text(
                    'Disconnect',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Get.dialog(
                      AlertDialog(
                        title: Text(
                          'Force Disconnect',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w600),
                        ),
                        content: Text(
                          'Ini akan memutuskan koneksi printer dan menghapus pengaturan. Lanjutkan?',
                          style: GoogleFonts.poppins(),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: Text(
                              'Batal',
                              style: GoogleFonts.poppins(),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.back();
                              controller.forceDisconnect();
                            },
                            child: Text(
                              'Ya, Disconnect',
                              style: GoogleFonts.poppins(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete_forever),
                  label: Text(
                    'Force Disconnect & Clear',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red[700],
                    side: BorderSide(color: Colors.red[700]!),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
