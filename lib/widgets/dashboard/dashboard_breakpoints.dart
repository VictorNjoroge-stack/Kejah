import 'package:flutter/material.dart';

class DashboardBreakpoints {
  DashboardBreakpoints._();

  static const double tablet = 700;
  static const double desktop = 1100;

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < tablet;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= tablet && width < desktop;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktop;
  }

  static int gridColumns(BuildContext context) {
    if (isDesktop(context)) return 3;
    if (isTablet(context)) return 2;
    return 1;
  }

  static double maxContentWidth(BuildContext context) {
    if (isDesktop(context)) {
      return 1400;
    }

    if (isTablet(context)) {
      return 1000;
    }

    return double.infinity;
  }

  static double horizontalPadding(BuildContext context) {
    if (isDesktop(context)) {
      return 32;
    }

    if (isTablet(context)) {
      return 24;
    }

    return 16;
  }
}