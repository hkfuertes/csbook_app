import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController with ChangeNotifier {
  SettingsController(
      {this.english = false, this.showChords = true, this.parishData});

  bool english;
  bool showChords;
  String? parishData;

  String? getParishName() {
    if (parishData != null && parishData != "") {
      return parishData!.split("|")[1];
    } else {
      return null;
    }
  }

  int? getParishId() {
    if (parishData != null && parishData != "") {
      return int.parse(parishData!.split("|")[0]);
    } else {
      return null;
    }
  }

  void setParish(int id, String name) {
    parishData = id.toString() + "|" + name;
    notifyListeners();
  }

  void setEnglish(bool english) {
    this.english = english;
    notifyListeners();
  }

  void setShowChords(bool showChords) {
    this.showChords = showChords;
    notifyListeners();
  }

  Future savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('english', english);
    await prefs.setBool('showChords', showChords);
    await prefs.setString('parishData', parishData ?? "");
  }

  static Future<SettingsController> getFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    var english = prefs.getBool("english");
    var showChords = prefs.getBool("showChords");
    var parishData = prefs.getString("parishData");

    return SettingsController(
        english: english ?? false,
        showChords: showChords ?? true,
        parishData: parishData);
  }
}
