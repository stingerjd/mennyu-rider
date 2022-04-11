import 'package:mennyu_rider/helper/responsive_helper.dart';
import 'package:mennyu_rider/helper/route_helper.dart';
import 'package:mennyu_rider/util/styles.dart';
import 'package:mennyu_rider/view/base/custom_app_bar.dart';
import 'package:mennyu_rider/view/screens/language/widget/language_widget.dart';
import 'package:flutter/material.dart';
import 'package:mennyu_rider/controller/localization_controller.dart';
import 'package:mennyu_rider/util/app_constants.dart';
import 'package:mennyu_rider/util/dimensions.dart';
import 'package:mennyu_rider/util/images.dart';
import 'package:mennyu_rider/view/base/custom_button.dart';
import 'package:mennyu_rider/view/base/custom_snackbar.dart';
import 'package:get/get.dart';
import 'package:mennyu_rider/view/screens/profile/profile_screen.dart';

class ChooseLanguageScreen extends StatelessWidget {
  final bool fromMenu;
  ChooseLanguageScreen({this.fromMenu = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (fromMenu || ResponsiveHelper.isDesktop(context))
          ? CustomAppBar(title: 'language'.tr, isBackButtonExist: true)
          : null,
      body: SafeArea(
        child: GetBuilder<LocalizationController>(
            builder: (localizationController) {
          return Column(children: [
            Expanded(
                child: Center(
              child: Scrollbar(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: Center(
                      child: SizedBox(
                    width: Dimensions.WEB_MAX_WIDTH,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(child: Image.asset(Images.logo, width: 100)),

                          //Center(child: Text(AppConstants.APP_NAME, style: robotoMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE))),
                          SizedBox(height: 30),

                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child:
                                Text('select_language'.tr, style: robotoMedium),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                          GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  ResponsiveHelper.isDesktop(context)
                                      ? 4
                                      : ResponsiveHelper.isTab(context)
                                          ? 3
                                          : 2,
                              childAspectRatio: (1 / 1),
                            ),
                            itemCount: localizationController.languages.length,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) => LanguageWidget(
                              languageModel:
                                  localizationController.languages[index],
                              localizationController: localizationController,
                              index: index,
                            ),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                          Text('you_can_change_language'.tr,
                              style: robotoRegular.copyWith(
                                fontSize: Dimensions.FONT_SIZE_SMALL,
                                color: Theme.of(context).disabledColor,
                              )),
                        ]),
                  )),
                ),
              ),
            )),
            CustomButton(
                buttonText: 'save'.tr,
                margin: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                onPressed: () => {
                      Navigator.pop(context, false),
                    })
          ]);
        }),
      ),
    );
  }
}
