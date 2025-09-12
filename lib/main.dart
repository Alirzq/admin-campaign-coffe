import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/routes/app_routes.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: '/splash', // Set splash sebagai rute awal
      getPages: AppRoutes.routes,
      defaultTransition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
      opaqueRoute: true,
      builder: (context, child) {
        return OrientationBuilder(
          builder: (context, orientation) {
            _setOrientationBasedOnDevice(context);
            return child!;
          },
        );
      },
    );
  }

  void _setOrientationBasedOnDevice(BuildContext context) {
    // Semua perangkat: hanya portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Lakukan pengecekan token setelah 2 detik untuk memberikan efek splash
    _checkTokenAndNavigate();

    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo atau ikon aplikasi
            Icon(
              Icons.store,
              size: 80,
              color: Colors.white,
            ),
            const SizedBox(height: 20),
            // Nama aplikasi atau teks
            Text(
              'My App',
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            // Indikator loading
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  void _checkTokenAndNavigate() async {
    // Tunggu 2 detik untuk efek splash
    await Future.delayed(const Duration(seconds: 2));
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      if (token != null && token.isNotEmpty) {
        Get.offAllNamed('/home'); // Arahkan ke home jika sudah login
      } else {
        Get.offAllNamed('/login'); // Arahkan ke login jika belum login
      }
    } catch (e) {
      // Jika terjadi error, arahkan ke login sebagai fallback
      Get.offAllNamed('/login');
    }
  }
}

// Helper class untuk mengelola SharedPreferences (opsional)
class PreferencesService {
  static SharedPreferences? _prefs;
  
  // Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // Save token
  static Future<bool> saveToken(String token) async {
    _prefs ??= await SharedPreferences.getInstance();
    return await _prefs!.setString('token', token);
  }
  
  // Get token
  static Future<String?> getToken() async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.getString('token');
  }
  
  // Remove token
  static Future<bool> removeToken() async {
    _prefs ??= await SharedPreferences.getInstance();
    return await _prefs!.remove('token');
  }
  
  // Clear all preferences
  static Future<bool> clearAll() async {
    _prefs ??= await SharedPreferences.getInstance();
    return await _prefs!.clear();
  }
  
  // Save any string value
  static Future<bool> saveString(String key, String value) async {
    _prefs ??= await SharedPreferences.getInstance();
    return await _prefs!.setString(key, value);
  }
  
  // Get any string value
  static Future<String?> getString(String key) async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.getString(key);
  }
  
  // Save boolean value
  static Future<bool> saveBool(String key, bool value) async {
    _prefs ??= await SharedPreferences.getInstance();
    return await _prefs!.setBool(key, value);
  }
  
  // Get boolean value
  static Future<bool?> getBool(String key) async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.getBool(key);
  }
  
  // Save integer value
  static Future<bool> saveInt(String key, int value) async {
    _prefs ??= await SharedPreferences.getInstance();
    return await _prefs!.setInt(key, value);
  }
  
  // Get integer value
  static Future<int?> getInt(String key) async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.getInt(key);
  }
}