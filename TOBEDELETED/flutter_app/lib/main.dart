import 'dart:convert';

import 'package:csbook/src/constants.dart';
import 'package:csbook/src/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';
import 'package:provider/provider.dart';
import 'src/settings_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SettingsController controller = await SettingsController.getFromPrefs();

  //If device if phone only portrait.
  if (Constants.getDeviceType() == Constants.DEVICE_IS_PHONE) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  var themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  var themeJson = json.decode(themeStr);
  var theme = ThemeDecoder.decodeThemeData(themeJson) ?? ThemeData.dark();
  runApp(ChangeNotifierProvider<SettingsController>(
      create: (_) => controller,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          restorationScopeId: 'app',
          theme: theme,
          themeMode: ThemeMode.dark,
          title: "Cancionero",
          home: const MainPage())));
}
