import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../login/view/login_view.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: screenHeight),
          child: Column(
            children: [
              // Image Section
              Container(
                height: screenHeight * 0.6,
                width: double.infinity,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        // Background atau image pertama
                        Positioned(
                          top: isTablet ? 20 : 0,
                          left: isTablet ? constraints.maxWidth * 0.1 : 40,
                          child: Image.asset(
                            'assets/barista_1.png',
                            width: isTablet
                                ? constraints.maxWidth * 0.4
                                : constraints.maxWidth * 0.8,
                            fit: BoxFit.contain,
                          ),
                        ),
                        // Image kedua
                        Positioned(
                          top: isTablet ? 80 : 110,
                          right: isTablet ? constraints.maxWidth * 0.1 : 40,
                          child: Image.asset(
                            'assets/barista_2.png',
                            width: isTablet
                                ? constraints.maxWidth * 0.35
                                : constraints.maxWidth * 0.6,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // Text Content Section
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 60.0 : 40.0,
                  vertical: 20.0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Fall in Love with Coffee in\nCampaign Coffee",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 38 : 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: isTablet ? 15 : 10),
                    Text(
                      "Welcome to our cozy coffee corner, where every cup is a delightful for you.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 16 : 14,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Button Section
              Padding(
                padding: EdgeInsets.only(
                  bottom: isTablet ? 50.0 : 30.0,
                  top: 20.0,
                ),
                child: SizedBox(
                  width: isTablet ? 400 : 350,
                  height: isTablet ? 55 : 50,
                  child: ElevatedButton(
                    onPressed: () => Get.to(() => LoginView()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    child: Text(
                      'Welcome',
                      style: GoogleFonts.poppins(
                        fontSize: isTablet ? 20 : 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
