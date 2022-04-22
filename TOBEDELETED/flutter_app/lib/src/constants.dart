import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

import 'package:flutter/material.dart';

class Constants {
  static var baseUrl = "http://localhost/api/v1";
  static var baseOldUrl = "https://parroquias.csbook.es/api/v1";

  static const DEVICE_IS_TABLET = 0x01;
  static const DEVICE_IS_PHONE = 0x02;
  static const BOTTOMAPPBAR_COLOR = Color.fromARGB(255, 48, 51, 50); //#ff303332

  //i.e. else show back arrow
  static bool isWebOrAndroid() {
    if (kIsWeb) {
      return true;
    } else {
      return Platform.isAndroid;
    }
  }

  static int getDeviceType() {
    var window = WidgetsBinding.instance?.window;
    if (window != null) {
      return MediaQueryData.fromWindow(window).size.shortestSide < 600
          ? DEVICE_IS_PHONE
          : DEVICE_IS_TABLET;
    } else {
      return DEVICE_IS_PHONE;
    }
  }
}
