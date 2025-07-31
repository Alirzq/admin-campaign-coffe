import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../../../controller/promotion_controller.dart';

class CustomAddBannerView extends StatefulWidget {
  const CustomAddBannerView({super.key});

  @override
  State<CustomAddBannerView> createState() => _CustomAddBannerViewState();
}

class _CustomAddBannerViewState extends State<CustomAddBannerView> {
  final _titleController = TextEditingController();
  File? _selectedImage;
  late final PromotionController promoController; // Gunakan late untuk inisialisasi di initState

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller saat widget pertama kali dibuat
    Get.put(PromotionController());
    promoController = Get.find<PromotionController>();
  }

  @override
  void dispose() {
    // Hapus controller saat widget dihapus untuk mencegah memory leak
    Get.delete<PromotionController>();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _showImagePickerOptions() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildOptionButton(
                icon: Icons.photo_library,
                label: 'File',
                onTap: () async {
                  Navigator.pop(context);
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    setState(() {
                      _selectedImage = File(image.path);
                    });
                  }
                },
              ),
              _buildOptionButton(
                icon: Icons.camera_alt,
                label: 'Camera',
                onTap: () async {
                  Navigator.pop(context);
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    setState(() {
                      _selectedImage = File(image.path);
                    });
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required VoidCallback onTap,
    required String label,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 50,
              color: const Color(0xFF0D47A1),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: const Color(0xFF0D47A1),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _savePromotion() async {
    if (_titleController.text.isEmpty) {
      Get.snackbar('Error', 'Title is required');
      return;
    }

    String? imageFilename;
    if (_selectedImage != null) {
      imageFilename = await promoController.uploadPromotionImage(_selectedImage!);
      if (imageFilename == null) {
        Get.snackbar('Error', 'Failed to upload image');
        return;
      }
    }

    try {
      // Panggil addPromotion dan abaikan nilai kembaliannya
      await promoController.addPromotion(_titleController.text, image: imageFilename);
      Get.snackbar('Success', 'Promotion added successfully');
      Get.back(); // Kembali setelah operasi selesai
    } catch (e) {
      Get.snackbar('Error', 'Failed to add promotion: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Add Banner',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: _showImagePickerOptions,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: _selectedImage != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.file(
                        _selectedImage!,
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/banner_icon.svg',
                            width: 40,
                            height: 40,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Click to upload image",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 24),
          _buildTextField("Title", "enter your title", _titleController),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D47A1),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                shadowColor: Colors.black45,
              ),
              onPressed: _savePromotion,
              child: Text(
                'Finish',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Daftar Banner/Promo',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (promoController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }
            if (promoController.promotions.isEmpty) {
              return Center(child: Text('Belum ada promo/banner'));
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: promoController.promotions.length,
              itemBuilder: (context, index) {
                final promo = promoController.promotions[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: promo.image != null
                        ? Image.network(
                            promo.image!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              print('Error loading promo image: $error');
                              return SvgPicture.asset(
                                'assets/banner_icon.svg',
                                width: 40,
                                height: 40,
                              );
                            },
                          )
                        : SvgPicture.asset('assets/banner_icon.svg', width: 40, height: 40),
                    title: Text(promo.title),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => promoController.deletePromotion(promo.id),
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: const Color(0xFFF1F3FF),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}