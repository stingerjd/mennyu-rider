import 'package:mennyu_rider/controller/auth_controller.dart';
import 'package:mennyu_rider/controller/splash_controller.dart';
import 'package:mennyu_rider/helper/route_helper.dart';
import 'package:mennyu_rider/view/base/custom_snackbar.dart';
import 'package:get/get.dart';

class ApiChecker {
  static void checkApi(Response response) {
    if (response.statusCode == 401) {
      Get.find<SplashController>().removeSharedData();
      Get.find<AuthController>().stopLocationRecord();
      Get.offAllNamed(RouteHelper.getSignInRoute());
    } else {
      showCustomSnackBar(response.statusText);
    }
  }
}
