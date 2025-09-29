import 'dart:io';
import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';

class LanguageProvider with ChangeNotifier {
  Locale? _locale;
  Locale get locale => _locale ?? Locale('en');

  LanguageProvider() {
    getLocale();
  }

  Future<void> getLocale() async {
    try {
      String? localeName = await LocalStorageService.getLang();
      if (localeName == null) {
        String deviceLocale = Platform.localeName.split('_')[0];
        localeName = deviceLocale != 'vi' ? 'en' : 'vi';
        await LocalStorageService.saveLang(localeName);
      }
      _locale = Locale(localeName);
      notifyListeners();
    } catch (_) {}
  }

  void saveLocale(Locale locale) async {
    if (locale.languageCode == _locale?.languageCode) {
      return;
    }
    _locale = locale;
    notifyListeners();
    await LocalStorageService.saveLang(_locale!.languageCode);
  }
}
