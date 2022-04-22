import 'package:csbook_app/MainScreen.dart';
import 'package:csbook_app/model/Settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:provider/provider.dart';

import 'Constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //I get system Preferences
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Create/Instanciate settings object and fill the preferences in.
  Settings settings = new Settings();
  settings.fill(prefs);
  //Run the app with the proper brightness
  //runApp(MyApp(_settings.getBrightness()));

  runApp(ChangeNotifierProvider<Settings>(
      builder: (context) => settings, child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp() : super();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));

    var settings = Provider.of<Settings>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'csbook',
      theme: settings.darkTheme ? Constants.blackTheme : Constants.whiteTheme,
      home: MainScreen(),
    );
  }
}
