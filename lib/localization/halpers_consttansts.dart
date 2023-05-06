import 'package:flutter/material.dart';
import 'package:tandrustito/core/shared/theme_lang_notifier.dart';

Locale getLocale(String? lang) {
  if (ThemeLangNotifier.instance.showInfo == false) {
    return const Locale('ku');
  }
  if (lang == "ku") {
    return const Locale('ku');
  } else if (lang == "ar") {
    return const Locale('ar');
  } else if (lang == "en") {
    return const Locale('en', 'US');
  }
  return const Locale('ku');
}

const List<Locale> supportedLocales = [
  Locale('en', "US"),
  Locale('ar'),
  Locale('ku')
];
