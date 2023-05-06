import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tandrustito/core/shared/imports.dart';

class ThemeLangNotifier with ChangeNotifier {
  bool showInfo = Platform.isAndroid;

  setShowInfo(bool val) {
    showInfo = val;
    notifyListeners();
  }

  static final ThemeLangNotifier _singleton = ThemeLangNotifier._();
  static ThemeLangNotifier get instance => _singleton;
  ThemeLangNotifier._();
  File? file;
  setFile(File? file) {
    this.file = file;
    notifyListeners();
  }

  String lang = "ku";
  bool isEn = true;
  bool reciveNotifications = true;
  toggleReciveNotifactions(bool reciveNotificationsParam) {
    reciveNotifications = reciveNotificationsParam;
    notifyListeners();
  }

  bool themeMode = false;
  init() {
    lang = SharedPrefsHalper.instance.lang;
    themeMode = SharedPrefsHalper.instance.themeMode;
  }

  changeLang(String newLang) {
    lang = newLang;
    isEn = lang == "ku";
    SharedPrefsHalper.instance.setLang(newLang);
    notifyListeners();
  }

  changeTheme(bool mod) async {
    themeMode = mod;
    SharedPrefsHalper.instance.setMode(mod);
    notifyListeners();
  }
}
