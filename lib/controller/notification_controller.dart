import 'package:mennyu_rider/data/api/api_checker.dart';
import 'package:mennyu_rider/data/model/response/notification_model.dart';
import 'package:mennyu_rider/data/repository/notification_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController implements GetxService {
  final NotificationRepo notificationRepo;
  NotificationController({@required this.notificationRepo});

  List<NotificationModel> _notificationList;
  List<NotificationModel> get notificationList => _notificationList;

  Future<void> getNotificationList() async {
    Response response = await notificationRepo.getNotificationList();
    if (response.statusCode == 200) {
      _notificationList = [];
      List<dynamic> _notifications = response.body.reversed.toList();
      _notifications.forEach((notification) =>
          _notificationList.add(NotificationModel.fromJson(notification)));
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  void saveSeenNotificationCount(int count) {
    notificationRepo.saveSeenNotificationCount(count);
  }

  int getSeenNotificationCount() {
    return notificationRepo.getSeenNotificationCount();
  }
}
