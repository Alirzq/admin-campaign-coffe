import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileController extends GetxController {
  var name = 'Nama User'.obs;
  var email = 'user@email.com'.obs;
  var profileImage = 'assets/splashimage.jpg'.obs;

  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    // Coba ambil data user dari GetStorage
    final userJson = box.read('user');
    if (userJson != null) {
      try {
        name.value = userJson['name'] ?? 'Nama User';
        email.value = userJson['email'] ?? 'user@email.com';
      } catch (e) {
        // fallback ke default
      }
    }
  }

  void manageAddresses() {
    // TODO: Implementasi aksi untuk mengelola alamat
  }

  void openHelpCenter() {
    // TODO: Implementasi aksi untuk membuka help center
  }

  void openSettings() {
    // TODO: Implementasi aksi untuk membuka settings
  }
}
