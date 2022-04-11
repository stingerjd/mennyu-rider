import 'package:mennyu_rider/controller/auth_controller.dart';
import 'package:mennyu_rider/controller/splash_controller.dart';
import 'package:mennyu_rider/controller/theme_controller.dart';
import 'package:mennyu_rider/helper/route_helper.dart';
import 'package:mennyu_rider/util/dimensions.dart';
import 'package:mennyu_rider/util/images.dart';
import 'package:mennyu_rider/util/styles.dart';
import 'package:mennyu_rider/view/base/confirmation_dialog.dart';
import 'package:mennyu_rider/view/screens/profile/widget/profile_bg_widget.dart';
import 'package:mennyu_rider/view/screens/profile/widget/profile_button.dart';
import 'package:mennyu_rider/view/screens/profile/widget/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.find<AuthController>().getProfile();

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: GetBuilder<AuthController>(builder: (authController) {
        return authController.profileModel == null
            ? Center(child: CircularProgressIndicator())
            : ProfileBgWidget(
                backButton: false,
                circularImage: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 2, color: Theme.of(context).cardColor),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: ClipOval(
                      child: FadeInImage.assetNetwork(
                    placeholder: Images.placeholder,
                    image:
                        '${Get.find<SplashController>().configModel.baseUrls.deliveryManImageUrl}'
                        '/${authController.profileModel != null ? authController.profileModel.image : ''}',
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    imageErrorBuilder: (c, o, s) => Image.asset(
                        Images.placeholder,
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover),
                  )),
                ),
                mainWidget: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Center(
                        child: Container(
                      width: 1170,
                      color: Theme.of(context).cardColor,
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      child: Column(children: [
                        Text(
                          '${authController.profileModel.fName} ${authController.profileModel.lName}',
                          style: robotoMedium.copyWith(
                              fontSize: Dimensions.FONT_SIZE_LARGE),
                        ),
                        SizedBox(height: 30),
                        Row(children: [
                          ProfileCard(
                              title: 'since_joining'.tr,
                              data:
                                  '${authController.profileModel.memberSinceDays} ${'days'.tr}'),
                          SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                          ProfileCard(
                              title: 'total_order'.tr,
                              data: authController.profileModel.orderCount
                                  .toString()),
                        ]),
                        SizedBox(height: 30),
                        ProfileButton(
                            icon: Icons.dark_mode,
                            title: 'dark_mode'.tr,
                            isButtonActive: Get.isDarkMode,
                            onTap: () {
                              Get.find<ThemeController>().toggleTheme();
                            }),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        ProfileButton(
                          icon: Icons.notifications,
                          title: 'notification'.tr,
                          isButtonActive: authController.notification,
                          onTap: () {
                            authController.setNotificationActive(
                                !authController.notification);
                          },
                        ),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        ProfileButton(
                            icon: Icons.language,
                            title: 'language'.tr,
                            onTap: () {
                              Get.toNamed(
                                  RouteHelper.getLanguageRoute('language'));
                            }),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        ProfileButton(
                            icon: Icons.map,
                            title: 'change_password'.tr,
                            onTap: () {
                              Get.toNamed(RouteHelper.getResetPasswordRoute(
                                  '', '', 'password-change'));
                            }),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        ProfileButton(
                            icon: Icons.lock,
                            title: 'change_password'.tr,
                            onTap: () {
                              Get.toNamed(RouteHelper.getResetPasswordRoute(
                                  '', '', 'password-change'));
                            }),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        ProfileButton(
                            icon: Icons.settings,
                            title: 'edit_profile'.tr,
                            onTap: () {
                              Get.toNamed(RouteHelper.getUpdateProfileRoute());
                            }),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                        ProfileButton(
                            icon: Icons.logout,
                            title: 'logout'.tr,
                            onTap: () {
                              Get.back();
                              Get.dialog(ConfirmationDialog(
                                  icon: Images.support,
                                  description: 'are_you_sure_to_logout'.tr,
                                  isLogOut: true,
                                  onYesPressed: () {
                                    Get.find<AuthController>()
                                        .clearSharedData();
                                    Get.find<AuthController>()
                                        .stopLocationRecord();
                                    Get.offAllNamed(
                                        RouteHelper.getSignInRoute());
                                  }));
                            }),
                      ]),
                    ))),
              );
      }),
    );
  }
}
