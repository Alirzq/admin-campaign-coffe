import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../controller/custom_add_menu_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CustomAddMenuView extends StatefulWidget {
  const CustomAddMenuView({super.key});

  @override
  State<CustomAddMenuView> createState() => _CustomAddMenuViewState();
}

class _CustomAddMenuViewState extends State<CustomAddMenuView> {
  File? _selectedImage;
  final CustomAddMenuController controller = Get.put(CustomAddMenuController());
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    stockController.dispose();
    super.dispose();
  }

  Future<void> _showImagePickerOptions() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Pilih Gambar Menu',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pilih sumber gambar untuk menu Anda',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildOptionButton(
                      icon: Icons.photo_library_outlined,
                      label: 'Galeri',
                      subtitle: 'Pilih dari galeri',
                      onTap: () async {
                        Navigator.pop(context);
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(
                          source: ImageSource.gallery,
                          maxWidth: 1024,
                          maxHeight: 1024,
                          imageQuality: 85,
                        );
                        if (image != null) {
                          setState(() {
                            _selectedImage = File(image.path);
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildOptionButton(
                      icon: Icons.camera_alt_outlined,
                      label: 'Kamera',
                      subtitle: 'Ambil foto baru',
                      onTap: () async {
                        Navigator.pop(context);
                        final ImagePicker picker = ImagePicker();
                        final XFile? image = await picker.pickImage(
                          source: ImageSource.camera,
                          maxWidth: 1024,
                          maxHeight: 1024,
                          imageQuality: 85,
                        );
                        if (image != null) {
                          setState(() {
                            _selectedImage = File(image.path);
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
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
    required String subtitle,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF0D47A1).withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF0D47A1).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D47A1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: const Color(0xFF0D47A1),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAddMenu() {
    final title = titleController.text.trim();
    final description = descriptionController.text.trim();
    final price = priceController.text.trim();
    final stock = stockController.text.trim();

    // Validation
    if (_selectedImage == null) {
      Get.snackbar(
        "Error",
        "Silakan upload gambar menu.",
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
      return;
    }

    if (title.isEmpty ||
        description.isEmpty ||
        price.isEmpty ||
        stock.isEmpty) {
      Get.snackbar(
        "Error",
        "Semua field wajib diisi.",
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
      return;
    }

    if (controller.selectedCategoryIndex.value == -1) {
      Get.snackbar(
        "Error",
        "Silakan pilih kategori menu.",
        backgroundColor: Colors.red.withOpacity(0.9),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        icon: const Icon(Icons.error_outline, color: Colors.white),
      );
      return;
    }

    final selectedCategory =
        controller.categories[controller.selectedCategoryIndex.value];
    final categoryId = controller.categoryIdMap[selectedCategory];

    // Show loading
    Get.dialog(
      Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0D47A1)),
              ),
              const SizedBox(height: 16),
              Text(
                'Menambahkan menu...',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    controller.addMenu(
      title: title,
      description: description,
      price: price,
      stock: stock,
      categoryId: categoryId!,
      imageFile: _selectedImage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D47A1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Tambah Menu',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              // Show help dialog
              Get.dialog(
                AlertDialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  title: Text(
                    'Bantuan',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                  ),
                  content: Text(
                    'Isi semua field yang diperlukan untuk menambahkan menu baru ke dalam sistem.',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        'OK',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF0D47A1),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Image Upload Section
          _buildSection(
            title: 'Gambar Menu',
            subtitle: 'Upload gambar yang menarik untuk menu Anda',
            icon: Icons.image_outlined,
            child: GestureDetector(
              onTap: _showImagePickerOptions,
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _selectedImage != null
                        ? const Color(0xFF0D47A1).withOpacity(0.3)
                        : Colors.grey.shade300,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Stack(
                          children: [
                            Image.file(
                              _selectedImage!,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 12,
                              right: 12,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedImage = null;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0D47A1).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Icon(
                                Icons.add_photo_alternate_outlined,
                                size: 32,
                                color: Color(0xFF0D47A1),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Tap untuk upload gambar",
                              style: GoogleFonts.poppins(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "JPG, PNG hingga 10MB",
                              style: GoogleFonts.poppins(
                                color: Colors.grey[500],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Basic Information Section
          _buildSection(
            title: 'Informasi Dasar',
            subtitle: 'Detail menu yang akan ditampilkan',
            icon: Icons.info_outline,
            child: Column(
              children: [
                _buildTextField(
                  "Nama Menu",
                  "Masukkan nama menu",
                  controller: titleController,
                  prefixIcon: Icons.restaurant_menu_outlined,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  "Deskripsi",
                  "Deskripsikan menu Anda",
                  maxLines: 3,
                  controller: descriptionController,
                  prefixIcon: Icons.description_outlined,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Pricing & Stock Section
          _buildSection(
            title: 'Harga & Stok',
            subtitle: 'Tentukan harga dan ketersediaan menu',
            icon: Icons.attach_money_outlined,
            child: Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    "Harga (Rp)",
                    "0",
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    prefixIcon: Icons.payments_outlined,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    "Stok",
                    "0",
                    controller: stockController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    prefixIcon: Icons.inventory_outlined,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Categories Section
          _buildSection(
            title: 'Kategori Menu',
            subtitle: 'Pilih kategori yang sesuai untuk menu',
            icon: Icons.category_outlined,
            child: Obx(() => Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children:
                      List.generate(controller.categories.length, (index) {
                    final isSelected =
                        controller.selectedCategoryIndex.value == index;
                    final category = controller.categories[index];
                    final iconPath = controller.categoryIcons[category] ?? '';

                    return GestureDetector(
                      onTap: () => controller.selectCategory(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: (MediaQuery.of(context).size.width - 64) / 3,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF0D47A1)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF0D47A1)
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? const Color(0xFF0D47A1).withOpacity(0.2)
                                  : Colors.black.withOpacity(0.04),
                              blurRadius: isSelected ? 8 : 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              iconPath,
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(
                                isSelected
                                    ? Colors.white
                                    : const Color(0xFF0D47A1),
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              category,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color:
                                    isSelected ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                )),
          ),

          const SizedBox(height: 32),

          // Submit Button
          Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0D47A1).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D47A1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: _handleAddMenu,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add_circle_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Tambah Menu',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D47A1).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: const Color(0xFF0D47A1),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String hint, {
    int maxLines = 1,
    TextEditingController? controller,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    IconData? prefixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: Colors.grey[500],
              fontSize: 14,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: Colors.grey[500],
                    size: 20,
                  )
                : null,
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: EdgeInsets.symmetric(
              horizontal: prefixIcon != null ? 12 : 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF0D47A1), width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
