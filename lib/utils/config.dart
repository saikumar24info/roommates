import 'package:flutter/material.dart';

class Config {
  int designHieght = 852;
  int designWidth = 393;

  double getDeviceHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  double getDevieWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
