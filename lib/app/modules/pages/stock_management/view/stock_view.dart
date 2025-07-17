import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

import '../../../../../controller/stock_controller.dart';
import '../../../../global-component/widget/custom_navbar.dart';
import '../../../../global-component/stock/stock_card.dart';
import '../../../../global-component/stock/header_stock_view.dart';
import '../../../../../models/product_model.dart';
import '../../../../../controller/product_controller.dart';
import '../../../../../controller/custom_add_menu_controller.dart';

class StockView extends GetView<StockController> {
  const StockView({super.key});

  void _showAddStockDialog(
      BuildContext context, String productName, void Function(int) onSubmit) {
    final TextEditingController controllerInput = TextEditingController();
    String? errorText;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: Text(
                'Tambah Stok',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black),
              ),
              content: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextField(
                  controller: controllerInput,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    hintText: 'Masukkan jumlah',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400),
                    errorText: errorText,
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.blue.shade100),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Colors.blue.shade900, width: 2),
                    ),
                  ),
                  cursorColor: Colors.blue.shade900,
                ),
              ),
              actionsPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Batal',
                      style: GoogleFonts.poppins(color: Colors.blue.shade900)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {
                    final value = int.tryParse(controllerInput.text);
                    if (value != null) {
                      final isValid =
                          Get.find<StockController>().isValidAmount(value);
                      if (isValid) {
                        onSubmit(value);
                        Navigator.of(context).pop();
                      } else {
                        setState(() {
                          errorText = 'Maksimal 100.000';
                        });
                      }
                    }
                  },
                  child: Text('Tambah',
                      style: GoogleFonts.poppins(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditProductDialog(BuildContext context, Product product, ProductController productController) {
    final nameController = TextEditingController(text: product.name);
    final descController = TextEditingController(text: product.description);
    final priceController = TextEditingController(text: product.price.toString());
    final stockController = TextEditingController(text: product.stock.toString());
    String selectedCategory = product.category;
    final categoryIdMap = Get.find<CustomAddMenuController>().categoryIdMap;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Produk'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Nama Produk'),
                ),
                TextField(
                  controller: descController,
                  decoration: InputDecoration(labelText: 'Deskripsi'),
                ),
                TextField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Harga'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: stockController,
                  decoration: InputDecoration(labelText: 'Stok'),
                  keyboardType: TextInputType.number,
                ),
                DropdownButtonFormField<String>(
                  value: selectedCategory.isNotEmpty ? selectedCategory : null,
                  items: controller.categories.map((cat) {
                    return DropdownMenuItem<String>(
                      value: cat,
                      child: Text(cat),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) selectedCategory = val;
                  },
                  decoration: InputDecoration(labelText: 'Kategori'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                final categoryId = categoryIdMap[selectedCategory] ?? 1;
                await productController.updateProduct(
                  id: product.id,
                  title: nameController.text,
                  description: descController.text,
                  price: priceController.text,
                  stock: stockController.text,
                  categoryId: categoryId,
                  rating: product.rating.toDouble(),
                  reviewCount: product.reviewCount,
                );
                Navigator.of(context).pop();
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const HeaderStockView(),
          Expanded(
            child: Obx(() {
              final selectedCategory =
                  controller.categories[controller.selectedCategoryIndex.value];
              final filteredStock = controller.filteredStock;

              final Map<String, String> categoryIcons = {
                "Coffee": 'assets/coffee.svg',
                "Non Coffee": 'assets/non_coffee.svg',
                "Snack": 'assets/snack.svg',
                "Main Course": 'assets/main_course.svg',
              };

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 120,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: controller.categories.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 25),
                        itemBuilder: (context, index) {
                          final isSelected =
                              index == controller.selectedCategoryIndex.value;
                          final categoryName = controller.categories[index];
                          final iconPath = categoryIcons[categoryName] ?? '';

                          return GestureDetector(
                            onTap: () => controller.selectCategory(index),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 20),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.blue.shade100
                                        : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.transparent,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 5,
                                        spreadRadius: 2,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: SvgPicture.asset(
                                    iconPath,
                                    width: 28,
                                    height: 28,
                                    colorFilter: ColorFilter.mode(
                                      isSelected
                                          ? Colors.blue.shade900
                                          : Colors.black,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  categoryName,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.blue.shade900
                                        : Colors.black87,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Product Stock",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: filteredStock.length,
                      itemBuilder: (context, index) {
                        final item = filteredStock[index];
                        return StockCard(
                          imagePath: item['image'],
                          title: item['title'],
                          category: selectedCategory,
                          amount: item['amount'],
                          onAddTap: () {
                            _showAddStockDialog(context, item['title'],
                                (value) async {
                              await controller.setStockAmountByName(item['title'], value);
                            });
                          },
                          onEditTap: () async {
                            final productController = Get.find<ProductController>();
                            final product = controller.products.firstWhereOrNull((p) => p.name == item['title']);
                            if (product != null) {
                              final detail = await productController.getProductById(product.id);
                              _showEditProductDialog(context, detail, productController);
                            }
                          },
                          onDeleteTap: () async {
                            final productController = Get.find<ProductController>();
                            // Tampilkan dialog konfirmasi
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Hapus Produk'),
                                content: Text('Yakin ingin menghapus produk ini?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: Text('Hapus'),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              // Cari id produk dari nama
                              final product = controller.products.firstWhereOrNull((p) => p.name == item['title']);
                              if (product != null) {
                                await productController.deleteProduct(product.id);
                              }
                            }
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: const CustomNavbar(),
    );
  }
}
