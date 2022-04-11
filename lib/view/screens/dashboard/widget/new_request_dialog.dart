import 'package:mennyu_rider/controller/order_controller.dart';
import 'package:mennyu_rider/util/dimensions.dart';
import 'package:mennyu_rider/util/images.dart';
import 'package:mennyu_rider/util/styles.dart';
import 'package:mennyu_rider/view/base/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NewRequestDialog extends StatelessWidget {
  final bool isRequest;
  final Function onTap;
  NewRequestDialog({@required this.isRequest, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL)),
      //insetPadding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      child: Padding(
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Image.asset(Images.notification_in,
              height: 60, color: Theme.of(context).primaryColor),
          Padding(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
            child: Text(
              isRequest
                  ? 'new_order_request_from_a_customer'.tr
                  : 'you_have_assigned_a_new_order'.tr,
              textAlign: TextAlign.center,
              style:
                  robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
            ),
          ),
          CustomButton(
            height: 40,
            buttonText: isRequest
                ? (Get.find<OrderController>().currentOrderList != null &&
                        Get.find<OrderController>().currentOrderList.length > 0)
                    ? 'ok'.tr
                    : 'go'.tr
                : 'ok'.tr,
            onPressed: () {
              Get.back();
              onTap();
            },
          ),
        ]),
      ),
    );
  }
}
