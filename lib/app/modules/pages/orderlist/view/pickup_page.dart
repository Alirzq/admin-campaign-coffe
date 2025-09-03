import 'package:admin_campaign_coffe_repo/app/global-component/order/pickup_section_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controller/pickup_controller.dart';
import 'list-pickup/full_pickup_list_page.dart';
import 'list-pickup/full_pickup_in_progress_page.dart';
import 'list-pickup/full_pickup_completed_page.dart';
import 'package:intl/intl.dart';
import '../../../../../utils/currency_formatter.dart';

class PickupPage extends StatelessWidget {
  const PickupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PickupController controller = Get.find<PickupController>();

    Map<String, String> orderToMap(order) {
      return {
        'pickupName': order.customerName,
        'pickupItems': order.items.map((e) => e.productName).join(', '),
        'price': CurrencyFormatter.formatCurrencyFromDouble(order.totalPrice),
      };
    }

    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              Obx(() => PickupSectionCard(
                    title: "Pickup List",
                    data: controller.orderList.isNotEmpty
                        ? orderToMap(controller.orderList[0])
                        : {},
                    onTap: () => Get.to(() => const FullPickupListPage()),
                  )),
              PickupSectionCard(
                title: "In-Progress",
                data: controller.inProgressList.isNotEmpty
                    ? orderToMap(controller.inProgressList[0])
                    : {},
                onTap: () => Get.to(() => const FullPickupInProgressPage()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String getCurrentDayDate() {
  final now = DateTime.now();
  final day = DateFormat('EEEE').format(now);
  final date = DateFormat('d').format(now);
  final year = DateFormat('y').format(now);
  return '$day, $date/$year'; // Lebih natural
}
