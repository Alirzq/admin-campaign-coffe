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
  late final PromotionController promoController;

  // Konstanta untuk validasi
  static const int maxFileSizeKB = 2048; // 2MB dalam KB
  static const int maxFileSizeBytes = maxFileSizeKB * 1024;
  static const List<String> allowedExtensions = ['jpg', 'jpeg', 'png'];

  @override
  void initState() {
    super.initState();
    Get.put(PromotionController());
    promoController = Get.find<PromotionController>();
    // Listener untuk update character counter
    _titleController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    Get.delete<PromotionController>();
    _titleController.dispose();
    super.dispose();
  }

  // Fungsi untuk memformat ukuran file
  String formatFileSize(int bytes) {
    if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else {
      return '$bytes B';
    }
  }

  // Fungsi untuk validasi file
  Map<String, dynamic> validateImageFile(File file) {
    // Cek ukuran file
    final fileSizeBytes = file.lengthSync();

    // Cek ekstensi file
    final fileName = file.path.toLowerCase();
    final hasValidExtension =
        allowedExtensions.any((ext) => fileName.endsWith('.$ext'));

    return {
      'isValid': fileSizeBytes <= maxFileSizeBytes && hasValidExtension,
      'fileSizeBytes': fileSizeBytes,
      'formattedSize': formatFileSize(fileSizeBytes),
      'isOversized': fileSizeBytes > maxFileSizeBytes,
      'invalidExtension': !hasValidExtension
    };
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Pilih Sumber Gambar',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Maksimal ${formatFileSize(maxFileSizeBytes)} • Format: JPG, PNG',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOptionButton(
                    icon: Icons.photo_library,
                    label: 'Galeri',
                    onTap: () async {
                      Navigator.pop(context);
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.gallery,
                        maxWidth: 1200,
                        maxHeight: 400,
                        imageQuality: 85, // Kompres ke 85% quality
                      );
                      if (image != null) {
                        await _processSelectedImage(image);
                      }
                    },
                  ),
                  _buildOptionButton(
                    icon: Icons.camera_alt,
                    label: 'Kamera',
                    onTap: () async {
                      Navigator.pop(context);
                      final ImagePicker picker = ImagePicker();
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.camera,
                        maxWidth: 1200,
                        maxHeight: 400,
                        imageQuality: 85, // Kompres ke 85% quality
                      );
                      if (image != null) {
                        await _processSelectedImage(image);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _processSelectedImage(XFile image) async {
    File imageFile = File(image.path);
    final validation = validateImageFile(imageFile);

    // Cek ekstensi file
    if (validation['invalidExtension']) {
      Get.snackbar(
        'Error',
        'Format file tidak didukung. Gunakan JPG, JPEG, atau PNG.',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 4),
        icon: Icon(Icons.error_outline, color: Colors.white),
      );
      return;
    }

    // Cek ukuran file
    if (validation['isOversized']) {
      Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.orange, size: 24),
              const SizedBox(width: 12),
              Text(
                'File Terlalu Besar',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ukuran file: ${validation['formattedSize']}',
                style: GoogleFonts.poppins(fontSize: 14),
              ),
              Text(
                'Maksimal: ${formatFileSize(maxFileSizeBytes)}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.red[600],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.lightbulb_outline,
                            color: Colors.blue[700], size: 16),
                        const SizedBox(width: 8),
                        Text(
                          'Tips untuk memperkecil ukuran:',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Gunakan aplikasi editor foto untuk kompres\n• Ubah format ke JPG\n• Kurangi resolusi gambar\n• Pilih gambar yang lebih kecil',
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: Colors.blue[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'Pilih Gambar Lain',
                style: GoogleFonts.poppins(color: Colors.blue[600]),
              ),
            ),
          ],
        ),
      );
      return;
    }

    // File valid, set sebagai selected image
    setState(() {
      _selectedImage = imageFile;
    });

    Get.snackbar(
      'Success',
      'Gambar berhasil dipilih (${validation['formattedSize']})',
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      duration: Duration(seconds: 2),
      icon: Icon(Icons.check_circle_outline, color: Colors.white),
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
    // Validasi title
    String title = _titleController.text.trim();

    if (title.isEmpty) {
      Get.snackbar(
        'Error',
        'Judul banner harus diisi',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        icon: Icon(Icons.error_outline, color: Colors.white),
      );
      return;
    }

    if (title.length < 3) {
      Get.snackbar(
        'Error',
        'Judul banner minimal 3 karakter',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        icon: Icon(Icons.error_outline, color: Colors.white),
      );
      return;
    }

    if (title.length > 100) {
      Get.snackbar(
        'Error',
        'Judul banner maksimal 100 karakter',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        icon: Icon(Icons.error_outline, color: Colors.white),
      );
      return;
    }

    String? imageFilename;
    if (_selectedImage != null) {
      // Validasi ulang sebelum upload (double check)
      final validation = validateImageFile(_selectedImage!);
      if (!validation['isValid']) {
        Get.snackbar(
          'Error',
          'File gambar tidak valid. Ukuran: ${validation['formattedSize']}',
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          icon: Icon(Icons.error_outline, color: Colors.white),
        );
        return;
      }

      // Show loading untuk upload
      Get.dialog(
        AlertDialog(
          backgroundColor: Colors.grey[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0D47A1)),
              ),
              const SizedBox(height: 16),
              Text(
                'Mengupload gambar...',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        barrierDismissible: false,
      );

      imageFilename =
          await promoController.uploadPromotionImage(_selectedImage!);
      Get.back(); // Close loading dialog

      if (imageFilename == null) {
        return; // Error sudah ditampilkan di controller
      }
    }

    try {
      await promoController.addPromotion(title, image: imageFilename);

      Get.snackbar(
        'Success',
        'Banner berhasil ditambahkan',
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        icon: Icon(Icons.check_circle_outline, color: Colors.white),
      );

      // Clear form after success
      _titleController.clear();
      setState(() {
        _selectedImage = null;
      });
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menambahkan banner: $e',
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        icon: Icon(Icons.error_outline, color: Colors.white),
      );
    }
  }

  void _showDeleteConfirmation(dynamic promoId, String promoTitle) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.grey[50],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
        contentPadding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange,
              size: 30,
            ),
            const SizedBox(width: 12),
            Text(
              'Konfirmasi',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus banner:\n\n"$promoTitle"?',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.black87,
            height: 1.4,
          ),
        ),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              side: BorderSide(color: Colors.grey.shade400),
            ),
            onPressed: () => Get.back(),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () async {
              Get.back();

              try {
                if (promoId is int) {
                  await promoController.deletePromotion(promoId);
                } else {
                  await promoController
                      .deletePromotion(int.parse(promoId.toString()));
                }

                Get.snackbar(
                  'Success',
                  'Banner berhasil dihapus',
                  backgroundColor: Colors.green.withOpacity(0.9),
                  colorText: Colors.white,
                  snackPosition: SnackPosition.TOP,
                  margin: const EdgeInsets.all(12),
                  borderRadius: 12,
                  icon: const Icon(Icons.check_circle_outline,
                      color: Colors.white),
                );
              } catch (e) {
                // error sudah ditangani di controller
              }
            },
            child: Text(
              'Hapus',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
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
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Add Banner',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Upload Image Section
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upload Banner Image',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Info ukuran dan format
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFF0D47A1).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Color(0xFF0D47A1).withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16,
                              color: Color(0xFF0D47A1),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Ukuran maksimal: ${formatFileSize(maxFileSizeBytes)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Color(0xFF0D47A1),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.aspect_ratio,
                              size: 16,
                              color: Color(0xFF0D47A1),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Format: JPG, PNG • Rasio 3:1 (1200x400px)',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Color(0xFF0D47A1),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _showImagePickerOptions,
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.grey.shade300,
                          style: BorderStyle.solid,
                          width: 1,
                        ),
                      ),
                      child: _selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Stack(
                                children: [
                                  Image.file(
                                    _selectedImage!,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedImage = null;
                                        });
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Info ukuran file
                                  Positioned(
                                    bottom: 8,
                                    left: 8,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        formatFileSize(
                                            _selectedImage!.lengthSync()),
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
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
                                      color: Color(0xFF0D47A1).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Icon(
                                      Icons.cloud_upload_outlined,
                                      size: 32,
                                      color: Color(0xFF0D47A1),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    "Klik untuk upload gambar",
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Max ${formatFileSize(maxFileSizeBytes)} • JPG, PNG",
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
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Title Input Section
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _buildTextField(
                  "Banner Title", "Masukkan judul banner", _titleController),
            ),
          ),

          const SizedBox(height: 24),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D47A1),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              onPressed: _savePromotion,
              child: Text(
                'Simpan Banner',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Banner List Section
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.view_list_rounded,
                        color: Color(0xFF0D47A1),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Daftar Banner/Promo',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Banner List
                  Obx(() {
                    if (promoController.isLoading.value) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF0D47A1)),
                          ),
                        ),
                      );
                    }

                    if (promoController.promotions.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            Icon(
                              Icons.image_not_supported_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Belum ada banner/promo',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tambahkan banner pertama Anda',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: promoController.promotions.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final promo = promoController.promotions[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey[200]!,
                              width: 1,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Image Container
                                  Container(
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                    ),
                                    child: promo.image != null
                                        ? Image.network(
                                            promo.image!,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                color: Colors.grey[300],
                                                child: Icon(
                                                  Icons.broken_image_outlined,
                                                  size: 24,
                                                  color: Colors.grey[500],
                                                ),
                                              );
                                            },
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Container(
                                                color: Colors.grey[300],
                                                child: Center(
                                                  child: SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                              Color>(
                                                        Color(0xFF0D47A1),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        : Container(
                                            color: Colors.grey[300],
                                            child: Icon(
                                              Icons.image_outlined,
                                              size: 24,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                  ),

                                  // Content Container
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(12),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            promo.title,
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black87,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Banner Promosi',
                                            style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              color: Colors.grey[600],
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 2,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Color(0xFF0D47A1)
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              'Aktif',
                                              style: GoogleFonts.poppins(
                                                fontSize: 9,
                                                color: Color(0xFF0D47A1),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Action Container - Only Delete Button
                                  Container(
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            onTap: () {
                                              _showDeleteConfirmation(
                                                  promo.id, promo.title);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(6),
                                              child: Icon(
                                                Icons.delete_outline,
                                                size: 16,
                                                color: Colors.red[600],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLength: 100,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: Colors.grey[500],
              fontSize: 14,
            ),
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Color(0xFF0D47A1), width: 2),
            ),
            counterText: '', // Hilangkan counter text default
          ),
        ),
        // Custom character counter
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${controller.text.length}/100 karakter',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: controller.text.length > 100
                  ? Colors.red[600]
                  : Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }
}
