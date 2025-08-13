import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StockCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String category;
  final String amount;
  final void Function() onAddTap;
  final void Function()? onEditTap;
  final void Function()? onDeleteTap;
  final double imageHeightMobile;
  final double imageHeightTablet;

  const StockCard({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.category,
    required this.amount,
    required this.onAddTap,
    this.onEditTap,
    this.onDeleteTap,
    this.imageHeightMobile = 141.6, // default tinggi gambar mobile
    this.imageHeightTablet = 169.2, // default tinggi gambar tablet
  }) : super(key: key);

  bool isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600;
  }

  @override
  Widget build(BuildContext context) {
    final bool tablet = isTablet(context);

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(1.85),
          padding: const EdgeInsets.all(8),
          constraints: BoxConstraints(
            minHeight: tablet ? 340 : 320,
            minWidth: tablet ? 340 : 320,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar dengan tinggi manual
              Container(
                height: tablet ? imageHeightTablet : imageHeightMobile,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imagePath,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child:
                            Icon(Icons.error_outline, color: Colors.grey[400]),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 1),

              // Judul
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: tablet ? 15 : 13,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 1),

              // Kategori
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  category,
                  style: GoogleFonts.poppins(
                    fontSize: tablet ? 10 : 9,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 1),

              // Amount dan tombol edit
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  amount == '0'
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Stok Habis',
                            style: GoogleFonts.poppins(
                              fontSize: tablet ? 11 : 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                          ),
                        )
                      : Text(
                          "Amount : $amount",
                          style: GoogleFonts.poppins(
                            fontSize: tablet ? 11 : 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.blue.shade900,
                          ),
                        ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onAddTap,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF004AAD),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF004AAD).withOpacity(0.3),
                              blurRadius: 4,
                              spreadRadius: 1,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Tombol hapus di pojok kanan atas
        Positioned(
          top: 10,
          right: 10,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onDeleteTap,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.delete, size: 18, color: Colors.red),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
