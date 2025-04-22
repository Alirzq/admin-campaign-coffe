import 'package:admin_campaign_coffe_repo/app/modules/pages/custom_widgets/view/custom_add_menu_view.dart';
import 'package:admin_campaign_coffe_repo/binding/custom_add_menu_binding.dart';
import 'package:admin_campaign_coffe_repo/binding/custom_widgets_binding.dart';
import 'package:admin_campaign_coffe_repo/binding/stock_binding.dart';
import 'package:get/get.dart';
import 'package:admin_campaign_coffe_repo/app/modules/pages/custom_widgets/view/custom_widgets.dart';
import 'package:admin_campaign_coffe_repo/app/modules/pages/orderlist/view/order_view.dart';
import 'package:admin_campaign_coffe_repo/app/modules/pages/stock_management/view/stock_view.dart';
import '../../binding/order_binding.dart';
import '../modules/pages/homepage/view/admin_homepage_view.dart';
import '../../binding/login_binding.dart';
import '../../binding/signup_binding.dart';
import '../modules/pages/splash/view/splash_view.dart';
import '../modules/pages/welcome/view/welcome_screen.dart';
import '../modules/pages/login/view/login_view.dart';
import '../modules/pages/signup/view/signup_view.dart';
import '../modules/pages/one_time_password/view/otp_view.dart';
import '../../binding/otp_binding.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: '/splash', page: () => SplashView()),
    GetPage(name: '/welcome', page: () => WelcomeScreen()),
    GetPage(name: '/login', page: () => LoginView(), binding: LoginBinding()),
    GetPage(
        name: '/signup', page: () => SignupView(), binding: SignupBinding()),
    GetPage(name: '/otp', page: () => OtpView(), binding: OtpBinding()),
    GetPage(name: '/home', page: () => HomepageView()),
    GetPage(
      name: '/order',
      page: () => const OrderView(),
      binding: OrderBinding(),
    ),
    GetPage(
      name: '/stock',
      page: () => const StockView(),
      binding: StockBinding(),
    ),
    GetPage(
      name: '/widget',
      page: () => const CustomWidgetView(),
      binding: CustomWidgetBinding(),
    ),
  ];
}
