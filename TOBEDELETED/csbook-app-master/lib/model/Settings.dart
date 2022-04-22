import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Parish.dart';

class Settings extends ChangeNotifier {
  static const IS_DARK_TOKEN = "isDark";

  static const PARISH_ID = "parish_id";
  static const PARISH_NAME = "parish_name";

  static const NOTATION_TOKEN = "notation_token";
  static const NOTATION_SPANISH = 0x01;
  static const NOTATION_ENGLISH = 0x02;

  //Settings
  bool darkTheme = false;
  int parishId = -1;
  String parishName = "";
  int notation = NOTATION_SPANISH;

  Settings() {
    this.darkTheme = false;
    this.parishId = -1;
    this.parishName = "";
    this.notation = NOTATION_SPANISH;
  }

  void fill(SharedPreferences sp) {
    this.notation = sp.getInt(NOTATION_TOKEN);
    this.notation = (this.notation == null) ? NOTATION_SPANISH : this.notation;

    this.darkTheme = sp.getBool(IS_DARK_TOKEN);
    this.darkTheme = (this.darkTheme == null) ? false : this.darkTheme;

    this.parishId = sp.get(PARISH_ID);
    this.parishId = (this.parishId == null) ? -1 : this.parishId;

    this.parishName = sp.getString(PARISH_NAME);
    this.parishName = (this.parishName == null) ? "" : this.parishName;

    //notifyListeners();
  }

  Brightness getBrightness() {
    return (this.darkTheme ?? true) ? Brightness.dark : Brightness.light;
  }

  Parish getParish() {
    return (parishId != null)
        ? Parish(parishId, parishName, null, null, null)
        : null;
  }

  void setDarkTheme(bool value) {
    this.darkTheme = value;

    saveSettings().then((_) {});
  }

  Future<void> saveSettings() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setInt(PARISH_ID, this.parishId);
    await sp.setString(PARISH_NAME, this.parishName);
    await sp.setBool(IS_DARK_TOKEN, this.darkTheme);
    await sp.setInt(NOTATION_TOKEN, this.notation);

    Fluttertoast.showToast(
        msg: "¡Ajustes guardados!", toastLength: Toast.LENGTH_SHORT);

    notifyListeners();
  }

  Parish setParish(Parish parish) {
    this.parishId = parish.id;
    this.parishName = parish.name;
    saveSettings().then((_) {});
    return parish;
  }

  int setNotation(int notation) {
    this.notation = notation;
    saveSettings().then((_) {});
    return notation;
  }
}
