import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Constants {
  static const APP_TITLE = "Cancionero";
  static const MASS_TITLE = "Misas";
  static const PARISH_TITLE = "Parroquias";
  static const MASS_VIEW_TITLE = "Misa: ";

  static const SONGS_WAITING = "canciones";
  static const SONG_WAITING = "cancion";
  static const PARISH_WAITING = "misas y canciones";

  static const FILTERING_TEXT = "Filtrando: ";
  static const FETCHING_TEXT = "Recuperando ";

  static const APP_RADIUS = 8.0;

  static ThemeData whiteTheme = ThemeData(
      brightness: Brightness.light,
      accentColor: Colors.black,
      primaryColor: Color(0xff424242),
      primaryColorLight: Color(0xff6d6d6d),
      primaryColorDark: Color(0xff1b1b1b),
      backgroundColor: Colors.white,
      textTheme: TextTheme(title: TextStyle(color: Colors.black)),
      appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          iconTheme: IconThemeData(color: Colors.black),
          actionsIconTheme: IconThemeData(color: Colors.black),
          textTheme: TextTheme(
              subhead: TextStyle(color: Colors.black),
              title: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 24))),
    );

    static ThemeData blackTheme = ThemeData(
      brightness: Brightness.dark,
      accentColor: Colors.black,
      primaryColor: Color(0xff424242),
      primaryColorLight: Color(0xff6d6d6d),
      primaryColorDark: Color(0xff1b1b1b),
      appBarTheme: AppBarTheme(
          textTheme: TextTheme(
              title: TextStyle(fontWeight: FontWeight.bold, fontSize: 24))),
      backgroundColor: Color(0xff1b1b1b),
    );

  static Future<void> systemBarsSetup(ThemeData theme) async {
    await statusBarsSetupByColor(theme.brightness, Colors.transparent);
  }

  static Future<void> systemBarsSetupByColor(
      Brightness brightness, Color backgroundColor) async {
    await statusBarsSetupByColor(brightness, backgroundColor);
  }

  static Future<void> statusBarsSetupByColor(
      Brightness brightness, Color backgroundColor) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarBrightness: (Brightness.dark == brightness)
            ? Brightness.light
            : Brightness.dark,
        statusBarColor: backgroundColor));
  }

  static ThemeData getBlackTheme(BuildContext context) {
    return Theme.of(context).copyWith(
        //brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(color: Colors.black, ),
        textTheme: TextTheme(
          body1: TextStyle(color: Colors.white),
        ));
  }
}
