import 'package:flutter/widgets.dart';

enum ScreenSize {
  mobile,   // < 600
  tabletS,  // 600 – 899
  tabletL,  // 900 – 1199
  desktopS, // 1200 – 1399
  desktopL, // >= 1400
}

class Breakpoints {
  Breakpoints._();

  static const double mobile = 600;
  static const double tabletS = 900;
  static const double tabletL = 1200;
  static const double desktopS = 1400;

  static ScreenSize of(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobile) return ScreenSize.mobile;
    if (width < tabletS) return ScreenSize.tabletS;
    if (width < tabletL) return ScreenSize.tabletL;
    if (width < desktopS) return ScreenSize.desktopS;
    return ScreenSize.desktopL;
  }

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < tabletS;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w >= mobile && w < tabletL;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= tabletL;
}
