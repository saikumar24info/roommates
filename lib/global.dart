import 'package:flutter/material.dart';
import 'package:room_mates/services/food_menu_update.dart';
import 'package:room_mates/services/google_login.dart';
import 'package:room_mates/services/notification.dart';
import 'package:room_mates/utils/config.dart';
import 'package:room_mates/utils/util.dart';

Config deviceConfig = Config();
UserGoogleSignup userGoogleSignup = UserGoogleSignup();
Utils utils = Utils();
HostelManagement hostelManagement = HostelManagement();
NotificationServices notificationService = NotificationServices();

double height(BuildContext context) {
  return (deviceConfig.getDeviceHeight(context) / deviceConfig.designHieght);
}

double width(BuildContext context) {
  return (deviceConfig.getDevieWidth(context) / deviceConfig.designWidth);
}

double fontSize(BuildContext context) {
  return (deviceConfig.getDevieWidth(context) / deviceConfig.designWidth) *
      0.97;
}
