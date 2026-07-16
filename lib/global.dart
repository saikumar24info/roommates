import 'package:flutter/material.dart';
import 'package:room_mates/services/admin_service.dart';
import 'package:room_mates/services/auth_service.dart';
import 'package:room_mates/services/food_menu_update.dart';
import 'package:room_mates/services/hostel_service.dart';
import 'package:room_mates/services/notification.dart';
import 'package:room_mates/services/profile_service.dart';
import 'package:room_mates/services/service_request_service.dart';
import 'package:room_mates/services/specification_service.dart';
import 'package:room_mates/utils/config.dart';
import 'package:room_mates/utils/util.dart';

Config deviceConfig = Config();
AuthService authService = AuthService();
HostelService hostelService = HostelService();
ProfileService profileService = ProfileService();
ServiceRequestService serviceRequestService = ServiceRequestService();
AdminService adminService = AdminService();
SpecificationService specificationService = SpecificationService();
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
