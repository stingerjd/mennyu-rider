import 'package:mennyu_rider/controller/auth_controller.dart';
import 'package:mennyu_rider/controller/order_controller.dart';
import 'package:mennyu_rider/helper/notification_helper.dart';
import 'package:mennyu_rider/helper/route_helper.dart';
import 'package:mennyu_rider/util/dimensions.dart';
import 'package:mennyu_rider/view/base/custom_alert_dialog.dart';
import 'package:mennyu_rider/view/screens/dashboard/widget/bottom_nav_item.dart';
import 'package:mennyu_rider/view/screens/dashboard/widget/new_request_dialog.dart';
import 'package:mennyu_rider/view/screens/home/home_screen.dart';
import 'package:mennyu_rider/view/screens/profile/profile_screen.dart';
import 'package:mennyu_rider/view/screens/request/order_request_screen.dart';
import 'package:mennyu_rider/view/screens/order/order_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  DashboardScreen({@required this.pageIndex});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  PageController _pageController;
  int _pageIndex = 0;
  List<Widget> _screens;
  final _channel = const MethodChannel('com.menyu/app_retain');
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();

    _pageIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      HomeScreen(),
      OrderRequestScreen(onTap: () => _setPage(0)),
      OrderScreen(),
      ProfileScreen(),
    ];

    var androidInitialize = AndroidInitializationSettings('notification_icon');
    var iOSInitialize = IOSInitializationSettings();
    var initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationsSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage: ${message.data}");
      NotificationHelper.showNotification(
          message.data, flutterLocalNotificationsPlugin);
      Get.find<OrderController>().getCurrentOrders();
      Get.find<OrderController>().getLatestOrders();
      Get.find<OrderController>().getAllOrders();
      String _type = message.data['type'];
      String _orderID = message.data['order_id'];
      if (_type == 'order_request') {
        Get.dialog(NewRequestDialog(
            isRequest: true, onTap: () => _navigateRequestPage()));
      } else if (_type == 'assign' && _orderID != null && _orderID.isNotEmpty) {
        Get.dialog(
            NewRequestDialog(isRequest: false, onTap: () => _setPage(0)));
      } else if (_type == 'block') {
        Get.find<AuthController>().clearSharedData();
        Get.find<AuthController>().stopLocationRecord();
        Get.offAllNamed(RouteHelper.getSignInRoute());
      }
    });
  }

  void _navigateRequestPage() {
    if (Get.find<AuthController>().profileModel != null &&
        Get.find<AuthController>().profileModel.active == 1 &&
        Get.find<OrderController>().currentOrderList != null &&
        Get.find<OrderController>().currentOrderList.length < 1) {
      _setPage(1);
    } else {
      if (Get.find<AuthController>().profileModel == null ||
          Get.find<AuthController>().profileModel.active == 0) {
        Get.dialog(CustomAlertDialog(
            description: 'you_are_offline_now'.tr,
            onOkPressed: () => Get.back()));
      } else {
        Get.dialog(CustomAlertDialog(
            description: 'you_have_running_order'.tr,
            onOkPressed: () => Get.back()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          if (GetPlatform.isAndroid &&
              Get.find<AuthController>().profileModel.active == 1) {
            _channel.invokeMethod('sendToBackground');
            return false;
          } else {
            return true;
          }
        }
      },
      child: Scaffold(
        bottomNavigationBar: GetPlatform.isDesktop
            ? SizedBox()
            : BottomAppBar(
                elevation: 5,
                notchMargin: 5,
                shape: CircularNotchedRectangle(),
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: Row(children: [
                    BottomNavItem(
                        iconData: Icons.home,
                        isSelected: _pageIndex == 0,
                        onTap: () => _setPage(0)),
                    BottomNavItem(
                        iconData: Icons.list_alt_rounded,
                        isSelected: _pageIndex == 1,
                        onTap: () {
                          _navigateRequestPage();
                        }),
                    BottomNavItem(
                        iconData: Icons.shopping_bag,
                        isSelected: _pageIndex == 2,
                        onTap: () => _setPage(2)),
                    BottomNavItem(
                        iconData: Icons.person,
                        isSelected: _pageIndex == 3,
                        onTap: () => _setPage(3)),
                  ]),
                ),
              ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
      ),
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}
