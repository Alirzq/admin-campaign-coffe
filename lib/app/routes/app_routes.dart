import 'package:get/get.dart';
import '../modules/pages/homepage/view/admin_homepage_view.dart';
import '../modules/pages/login/binding/login_binding.dart';
import '../modules/pages/signup/binding/signup_binding.dart';
import '../modules/pages/splash/controller/splash_view.dart';
import '../modules/pages/welcome/view/welcome_screen.dart';
import '../modules/pages/login/view/login_view.dart';
import '../modules/pages/signup/view/signup_view.dart';
import '../modules/pages/one_time_password/view/otp_view.dart';
import '../modules/pages/one_time_password/binding/otp_binding.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/splash', page: () => SplashView()),
    GetPage(name: '/welcome', page: () => WelcomeScreen()),
    GetPage(name: '/login', page: () => LoginView(), binding: LoginBinding()),
    GetPage(
        name: '/signup', page: () => SignupView(), binding: SignupBinding()),
    GetPage(name: '/otp', page: () => OtpView(), binding: OtpBinding()),
    GetPage(name: '/home', page: () => HomepageView()),
  ];
}
