import 'package:mennyu_rider/controller/order_controller.dart';
import 'package:mennyu_rider/controller/splash_controller.dart';
import 'package:mennyu_rider/helper/date_converter.dart';
import 'package:mennyu_rider/helper/route_helper.dart';
import 'package:mennyu_rider/util/dimensions.dart';
import 'package:mennyu_rider/util/images.dart';
import 'package:mennyu_rider/util/styles.dart';
import 'package:mennyu_rider/view/base/custom_app_bar.dart';
import 'package:mennyu_rider/view/screens/order/order_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.find<OrderController>().getAllOrders();

    return Scaffold(
      appBar: CustomAppBar(title: 'my_orders'.tr, isBackButtonExist: false),
      body: GetBuilder<OrderController>(builder: (orderController) {
        return orderController.deliveredOrderList != null
            ? orderController.deliveredOrderList.length > 0
                ? RefreshIndicator(
                    onRefresh: () async {
                      await orderController.getAllOrders();
                    },
                    child: Scrollbar(
                        child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Center(
                          child: SizedBox(
                        width: 1170,
                        child: ListView.builder(
                          padding:
                              EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          itemCount: orderController.deliveredOrderList.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () => Get.toNamed(
                                RouteHelper.getOrderDetailsRoute(orderController
                                    .deliveredOrderList[index].id),
                                arguments: OrderDetailsScreen(
                                  orderModel:
                                      orderController.deliveredOrderList[index],
                                  isRunningOrder: false,
                                  orderIndex: index,
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.all(
                                    Dimensions.PADDING_SIZE_SMALL),
                                margin: EdgeInsets.only(
                                    bottom: Dimensions.PADDING_SIZE_SMALL),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors
                                            .grey[Get.isDarkMode ? 700 : 300],
                                        spreadRadius: 1,
                                        blurRadius: 5)
                                  ],
                                  borderRadius: BorderRadius.circular(
                                      Dimensions.RADIUS_SMALL),
                                ),
                                child: Row(children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.RADIUS_SMALL),
                                    child: FadeInImage.assetNetwork(
                                      placeholder: Images.placeholder,
                                      height: 70,
                                      width: 70,
                                      fit: BoxFit.cover,
                                      image:
                                          '${Get.find<SplashController>().configModel.baseUrls.restaurantImageUrl}'
                                          '/${orderController.deliveredOrderList[index].restaurantLogo}',
                                      imageErrorBuilder: (c, o, s) =>
                                          Image.asset(Images.placeholder,
                                              height: 70,
                                              width: 70,
                                              fit: BoxFit.cover),
                                    ),
                                  ),
                                  SizedBox(
                                      width: Dimensions.PADDING_SIZE_SMALL),
                                  Expanded(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(children: [
                                            Text('${'order_id'.tr}:',
                                                style: robotoRegular.copyWith(
                                                    fontSize: Dimensions
                                                        .FONT_SIZE_SMALL)),
                                            SizedBox(
                                                width: Dimensions
                                                    .PADDING_SIZE_EXTRA_SMALL),
                                            Text(
                                              '#${orderController.deliveredOrderList[index].id}',
                                              style: robotoMedium.copyWith(
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_SMALL),
                                            ),
                                          ]),
                                          SizedBox(
                                              height: Dimensions
                                                  .PADDING_SIZE_EXTRA_SMALL),
                                          Text(
                                            orderController
                                                .deliveredOrderList[index]
                                                .restaurantName,
                                            style: robotoMedium.copyWith(
                                                fontSize:
                                                    Dimensions.FONT_SIZE_SMALL,
                                                color: Theme.of(context)
                                                    .primaryColor),
                                          ),
                                          SizedBox(
                                              height: Dimensions
                                                  .PADDING_SIZE_EXTRA_SMALL),
                                          Row(children: [
                                            Icon(Icons.access_time, size: 15),
                                            SizedBox(
                                                width: Dimensions
                                                    .PADDING_SIZE_EXTRA_SMALL),
                                            Text(
                                              DateConverter
                                                  .isoStringToLocalDateAnTime(
                                                      orderController
                                                          .deliveredOrderList[
                                                              index]
                                                          .updatedAt),
                                              style: robotoRegular.copyWith(
                                                  color: Theme.of(context)
                                                      .disabledColor,
                                                  fontSize: Dimensions
                                                      .FONT_SIZE_SMALL),
                                            ),
                                          ]),
                                        ]),
                                  ),
                                ]),
                              ),
                            );
                          },
                        ),
                      )),
                    )),
                  )
                : Center(child: Text('no_order_found'.tr))
            : Center(child: CircularProgressIndicator());
      }),
    );
  }
}
