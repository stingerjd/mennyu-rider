import 'package:mennyu_rider/data/model/response/order_model.dart';
import 'package:mennyu_rider/view/screens/auth/sign_in_screen.dart';
import 'package:mennyu_rider/view/screens/dashboard/dashboard_screen.dart';
import 'package:mennyu_rider/view/screens/forget/forget_pass_screen.dart';
import 'package:mennyu_rider/view/screens/forget/new_pass_screen.dart';
import 'package:mennyu_rider/view/screens/forget/verification_screen.dart';
import 'package:mennyu_rider/view/screens/notification/notification_screen.dart';

import 'package:mennyu_rider/view/screens/order/order_details_screen.dart';
import 'package:mennyu_rider/view/screens/profile/update_profile_screen.dart';
import 'package:mennyu_rider/view/screens/splash/splash_screen.dart';
import 'package:mennyu_rider/view/screens/language/language_screen.dart';
import 'package:get/get.dart';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String language = '/language';
  static const String signIn = '/sign-in';
  static const String verification = '/verification';
  static const String main = '/main';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String orderDetails = '/order-details';
  static const String updateProfile = '/update-profile';
  static const String notification = '/notification';

  static String getInitialRoute() => '$initial';
  static String getSplashRoute() => '$splash';
  static String getLanguageRoute(String page) => '$language?page=$page';

  static String getSignInRoute() => '$signIn';
  static String getVerificationRoute(String number) =>
      '$verification?number=$number';
  static String getMainRoute(String page) => '$main?page=$page';
  static String getForgotPassRoute() => '$forgotPassword';
  static String getResetPasswordRoute(
          String phone, String token, String page) =>
      '$resetPassword?phone=$phone&token=$token&page=$page';
  static String getOrderDetailsRoute(int id) => '$orderDetails?id=$id';
  static String getUpdateProfileRoute() => '$updateProfile';
  static String getNotificationRoute() => '$notification';

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => DashboardScreen(pageIndex: 0)),
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(
        name: language,
        page: () =>
            ChooseLanguageScreen(fromMenu: Get.parameters['page'] == 'menu')),
    GetPage(name: signIn, page: () => SignInScreen()),
    GetPage(
        name: verification,
        page: () => VerificationScreen(number: Get.parameters['number'])),
    GetPage(
        name: main,
        page: () => DashboardScreen(
              pageIndex: Get.parameters['page'] == 'home'
                  ? 0
                  : Get.parameters['page'] == 'order-request'
                      ? 1
                      : Get.parameters['page'] == 'order'
                          ? 2
                          : Get.parameters['page'] == 'profile'
                              ? 3
                              : 0,
            )),
    GetPage(name: forgotPassword, page: () => ForgetPassScreen()),
    GetPage(
        name: resetPassword,
        page: () => NewPassScreen(
              resetToken: Get.parameters['token'],
              number: Get.parameters['phone'],
              fromPasswordChange: Get.parameters['page'] == 'password-change',
            )),
    GetPage(
        name: orderDetails,
        page: () {
          OrderDetailsScreen _orderDetails = Get.arguments;
          return _orderDetails != null
              ? _orderDetails
              : OrderDetailsScreen(
                  orderModel: OrderModel(id: int.parse(Get.parameters['id'])),
                  orderIndex: null,
                  isRunningOrder: null,
                );
        }),
    GetPage(name: updateProfile, page: () => UpdateProfileScreen()),
    GetPage(name: notification, page: () => NotificationScreen()),
  ];
}
