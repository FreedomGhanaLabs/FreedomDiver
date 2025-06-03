import 'dart:math';

import 'package:flutter/material.dart';
import 'package:freedomdriver/shared/app_config.dart';

class Responsive {
  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
  
  static double top(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

// from small to big screens
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width > smallMobileWidth;
  }

// from small to big screens
  static bool isBigMobile(BuildContext context) {
    return MediaQuery.of(context).size.width > mobileWidth;
  }

// from small to big screens
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width > bigMobileWidth;
  }

  static double textScaleFactor(
    BuildContext context, {
    double maxTextScaleFactor = 1.3,
    int screenWidth = 800,
  }) {
    final width = MediaQuery.of(context).size.width;
    final val = (width / screenWidth) * maxTextScaleFactor;
    return max(1, min(val, maxTextScaleFactor));
  }

  static Size size(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static Orientation orientation(BuildContext context) {
    return MediaQuery.of(context).orientation;
  }
}
