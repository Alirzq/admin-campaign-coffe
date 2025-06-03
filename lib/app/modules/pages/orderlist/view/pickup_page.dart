import 'package:admin_campaign_coffe_repo/app/global-component/order/pickup_section_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controller/pickup_controller.dart';
import 'list-pickup/full_pickup_list_page.dart';
import 'list-pickup/full_pickup_in_progress_page.dart';
import 'list-pickup/full_pickup_completed_page.dart';

class PickupPage extends StatelessWidget {
  const PickupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final PickupController controller = Get.put(PickupController());

    return Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              PickupSectionCard(
                title: "Pickup List",
                data: controller.pickupList[0],
                onTap: () => Get.to(() => const FullPickupListPage()),
              ),
              PickupSectionCard(
                title: "In-Progress",
                data: controller.inProgressPickupList[0],
                onTap: () => Get.to(() => const FullPickupInProgressPage()),
              ),
              PickupSectionCard(
                title: "Completed Pickup",
                data: controller.completedPickupList[0],
                onTap: () => Get.to(() => const FullPickupCompletedPage()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
