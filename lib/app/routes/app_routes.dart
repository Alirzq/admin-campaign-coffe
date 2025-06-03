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
import '../modules/pages/homepage/history/history_page.dart';
import '../../binding/history_binding.dart';
import '../modules/pages/orderlist/view/pickup_page.dart';
import '../../binding/pickup_binding.dart';

class MyRoutes {
  static const String splash = '/splash';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String otp = '/otp';
  static const String home = '/home';
  static const String order = '/order';
  static const String stock = '/stock';
  static const String widget = '/widget';
  static const String addMenu = '/add-menu';
  static const String history = '/history';
  static const String pickup = '/pickup';
}

class AppRoutes {
  static final routes = [
    GetPage(name: MyRoutes.splash, page: () => SplashView()),
    GetPage(name: MyRoutes.welcome, page: () => WelcomeScreen()),
    GetPage(
        name: MyRoutes.login, page: () => LoginView(), binding: LoginBinding()),
    GetPage(
        name: MyRoutes.signup,
        page: () => SignupView(),
        binding: SignupBinding()),
    GetPage(name: MyRoutes.otp, page: () => OtpView(), binding: OtpBinding()),
    GetPage(name: MyRoutes.home, page: () => HomepageView()),
    GetPage(
      name: MyRoutes.order,
      page: () => const OrderView(),
      binding: OrderBinding(),
    ),
    GetPage(
      name: MyRoutes.stock,
      page: () => const StockView(),
      binding: StockBinding(),
    ),
    GetPage(
      name: MyRoutes.widget,
      page: () => const CustomWidgetView(),
      binding: CustomWidgetBinding(),
    ),
    GetPage(
      name: MyRoutes.addMenu,
      page: () => CustomAddMenuView(),
      binding: CustomAddMenuBinding(),
    ),
    GetPage(
      name: MyRoutes.history,
      page: () => const HistoryPage(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: MyRoutes.pickup,
      page: () => const PickupPage(),
      binding: PickupBinding(),
    ),
  ];
}
